import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/features/give/pages/home_page_view.dart';
import 'package:givt_app/features/give/utils/for_you_discovery_resolvers.dart';
import 'package:givt_app/features/give/utils/mandate_popup_dismissal_tracker.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/qr_code.dart';
import 'package:givt_app/shared/repositories/repositories.dart';
import 'package:go_router/go_router.dart';

/// Home shell when the app was opened from a Givt QR deep link (ENG-595).
///
/// Shows the For You tab underneath and a confirmation dialog on top. On
/// confirm, routes into [Pages.forYouGiving]; on cancel, stays on For You.
class HomePageWithQRCode extends StatefulWidget {
  const HomePageWithQRCode({
    required this.code,
    required this.initialPageIndex,
    required this.onPageChanged,
    required this.auth,
    required this.mandatePopupDismissalTracker,
    super.key,
  });

  final String code;
  final int initialPageIndex;
  final void Function(int) onPageChanged;
  final AuthState auth;
  final MandatePopupDismissalTracker mandatePopupDismissalTracker;

  @override
  State<HomePageWithQRCode> createState() => _HomePageWithQRCodeState();
}

class _HomePageWithQRCodeState extends State<HomePageWithQRCode> {
  bool _isShowingDialog = false;
  bool _hasHandledCode = false;
  bool _hasEnteredGivingFlow = false;
  String? _lastHandledCode;

  @override
  void initState() {
    super.initState();
    _tryResolveQrCode();
  }

  @override
  void didUpdateWidget(HomePageWithQRCode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.code != oldWidget.code) {
      _hasHandledCode = false;
      _lastHandledCode = null;
      _tryResolveQrCode();
    } else if (widget.auth.status == AuthStatus.authenticated &&
        oldWidget.auth.status != AuthStatus.authenticated) {
      _tryResolveQrCode();
    }
  }

  void _tryResolveQrCode() {
    if (widget.code.isEmpty) {
      return;
    }
    if (widget.auth.status != AuthStatus.authenticated) {
      return;
    }
    if (_isShowingDialog) {
      return;
    }
    if (_hasEnteredGivingFlow) {
      return;
    }
    if (_hasHandledCode && _lastHandledCode == widget.code) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(_resolveAndPresentQr(widget.code));
    });
  }

  Future<void> _resolveAndPresentQr(String encodedMediumId) async {
    if (_isShowingDialog || !mounted) {
      return;
    }

    _isShowingDialog = true;
    _hasHandledCode = true;
    _lastHandledCode = encodedMediumId;

    try {
      final mediumId = utf8.decode(base64.decode(encodedMediumId));
      final resolved =
          await ForYouDiscoveryResolvers.resolveCollectGroupAndQrFromQrMediumId(
            mediumId,
          );

      if (!mounted) {
        return;
      }

      if (!resolved.isSuccess) {
        await _handleDiscoveryFailure(
          resolved,
          mediumId: mediumId,
        );
        return;
      }

      final collectGroup = resolved.collectGroup!;
      final qrCode = resolved.qrCode!;
      final iconData = await _getOrganisationIcon(collectGroup);

      if (!mounted) {
        return;
      }

      await _showQrConfirmDialog(
        collectGroup: collectGroup,
        qrCode: qrCode,
        mediumId: mediumId,
        iconData: iconData,
      );
    } on Object catch (error, stackTrace) {
      LoggingInfo.instance.error(
        'Failed to resolve QR deep link: $error',
        methodName: stackTrace.toString(),
      );
      if (!mounted) {
        return;
      }
      await ForYouQrDiscoveryDialogs.showNotFoundDialog(context);
    } finally {
      if (mounted) {
        setState(() => _isShowingDialog = false);
      }
    }
  }

  Future<void> _handleDiscoveryFailure(
    ForYouDiscoveryResult resolved, {
    required String mediumId,
  }) async {
    final failure = resolved.failure ?? ForYouDiscoveryFailure.notFound;

    switch (failure) {
      case ForYouDiscoveryFailure.inactiveQrCode:
        final collectGroup = resolved.collectGroup;
        if (collectGroup == null || collectGroup.nameSpace.isEmpty) {
          await ForYouQrDiscoveryDialogs.showNotFoundDialog(context);
          return;
        }
        final choice = await ForYouQrDiscoveryDialogs.showInactiveQrDialog(
          context,
          organisationName: collectGroup.orgName,
          organisationIcon: CollectGroupType.getIconByType(collectGroup.type),
        );
        if (!mounted) {
          return;
        }
        if (choice ?? false) {
          _openForYouGiving(
            collectGroup: collectGroup,
            mediumId: mediumId,
            restrictToEntryQrGoal: false,
          );
        }
      case ForYouDiscoveryFailure.inactiveCollectGroup:
        await ForYouQrDiscoveryDialogs.showInactiveCollectGroupDialog(context);
      case ForYouDiscoveryFailure.notFound:
        await ForYouQrDiscoveryDialogs.showNotFoundDialog(context);
    }
  }

  Future<void> _showQrConfirmDialog({
    required CollectGroup collectGroup,
    required QrCode qrCode,
    required String mediumId,
    required FaIconData iconData,
  }) async {
    final instanceName = qrCode.isGeneric ? null : qrCode.name;

    await QrConfirmOrgDialog.show(
      context,
      organizationName: collectGroup.orgName,
      icon: iconData,
      instanceName: instanceName,
      onConfirm: () {
        if (!mounted) {
          return;
        }
        _openForYouGiving(
          collectGroup: collectGroup,
          mediumId: mediumId,
          restrictToEntryQrGoal: !qrCode.isGeneric,
        );
      },
      onCancel: () {
        // Stay on the For You tab; nothing else to open.
      },
    );
  }

  void _openForYouGiving({
    required CollectGroup collectGroup,
    required String mediumId,
    required bool restrictToEntryQrGoal,
  }) {
    _hasEnteredGivingFlow = true;
    context.goNamed(
      Pages.forYouGiving.name,
      extra: ForYouFlowContext(
        source: ForYouEntrySource.qrCode,
        selectedOrganisation: collectGroup,
        entryMediumId: mediumId,
        restrictToEntryQrGoal: restrictToEntryQrGoal,
      ).toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RemoteDataSourceSyncBloc, RemoteDataSourceSyncState>(
          listener: (context, state) {
            if (state is RemoteDataSourceSyncSuccess) {
              if (!widget.auth.user.needRegistration &&
                  widget.auth.user.mandateSigned) {
                return;
              }
              NeedsRegistrationDialog.show(
                context,
                mandatePopupDismissalTracker:
                    widget.mandatePopupDismissalTracker,
              );
            }
          },
        ),
        BlocListener<InfraCubit, InfraState>(
          listener: (context, state) {
            if (state is InfraUpdateAvailable) {
              // Update dialog would be shown here if needed
            }
          },
        ),
      ],
      child: SafeArea(
        child: HomePageView(
          initialAmount: null,
          given: false,
          retry: false,
          code: widget.code,
          afterGivingRedirection: '',
          initialPageIndex: widget.initialPageIndex,
          onPageChanged: widget.onPageChanged,
        ),
      ),
    );
  }

  Future<FaIconData> _getOrganisationIcon(CollectGroup collectGroup) {
    return _getOrganisationIconFromNamespace(collectGroup.nameSpace);
  }

  Future<FaIconData> _getOrganisationIconFromNamespace(String namespace) async {
    if (namespace.isEmpty) {
      return FontAwesomeIcons.church;
    }

    try {
      final collectGroupRepository = getIt<CollectGroupRepository>();
      final collectGroupList = await collectGroupRepository.getCollectGroupList();

      if (collectGroupList.isEmpty) {
        return FontAwesomeIcons.church;
      }

      final collectGroup = collectGroupList.firstWhere(
        (group) =>
            group.nameSpace == namespace || group.nameSpace.startsWith(namespace),
        orElse: CollectGroup.empty,
      );

      if (collectGroup.type == CollectGroupType.none) {
        return FontAwesomeIcons.church;
      }

      return CollectGroupType.getIconByType(collectGroup.type);
    } on Object catch (error) {
      LoggingInfo.instance.error('Error getting organisation icon: $error');
      return FontAwesomeIcons.church;
    }
  }
}
