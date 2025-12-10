import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/pages/home_page_view.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/repositories.dart';

class HomePageWithQRCode extends StatefulWidget {
  const HomePageWithQRCode({
    required this.initialAmount,
    required this.given,
    required this.retry,
    required this.code,
    required this.afterGivingRedirection,
    required this.onPageChanged,
    required this.auth,
    super.key,
  });

  final double? initialAmount;
  final bool given;
  final bool retry;
  final String code;
  final String afterGivingRedirection;
  final void Function(int) onPageChanged;
  final AuthState auth;

  @override
  State<HomePageWithQRCode> createState() => _HomePageWithQRCodeState();
}

class _HomePageWithQRCodeState extends State<HomePageWithQRCode> {
  bool _qrConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GiveBloc, GiveState>(
          listener: (context, state) {
            // Show confirmation dialog when QR code is ready to confirm
            if (state.status == GiveStatus.readyToConfirm && !_qrConfirmed) {
              final orgName = state.organisation.organisationName ?? '';
              if (orgName.isNotEmpty) {
                // Get the icon for the organisation type asynchronously
                final mediumId = state.organisation.mediumId ?? '';
                _getOrganisationIcon(mediumId).then((iconData) {
                  if (mounted && state.status == GiveStatus.readyToConfirm) {
                    QrConfirmOrgDialog.show(
                      context,
                      organizationName: orgName,
                      icon: iconData,
                      onConfirm: () {
                        setState(() {
                          _qrConfirmed = true;
                        });
                        // Skip submission - we'll submit when user clicks Next
                        context.read<GiveBloc>().add(
                          const GiveConfirmQRCodeScannedOutOfApp(
                            skipSubmission: true,
                          ),
                        );
                      },
                      onCancel: () {
                        // Just close the dialog, user stays on home page
                        // Reset the QR code state
                        context.read<GiveBloc>().add(const GiveReset());
                      },
                    );
                  }
                });
              }
            }

            // Handle errors
            if (state.status == GiveStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.errorOccurred),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<RemoteDataSourceSyncBloc, RemoteDataSourceSyncState>(
          listener: (context, state) {
            // Needs registration dialog
            if (state is RemoteDataSourceSyncSuccess) {
              if (!widget.auth.user.needRegistration ||
                  widget.auth.user.mandateSigned) {
                return;
              }
              // TODO: Not show over biometrics
              // Registration dialog would be shown here if needed
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
      child: Builder(
        builder: (context) {
          final giveBloc = context.read<GiveBloc>();
          return SafeArea(
            child: BlocBuilder<GiveBloc, GiveState>(
              bloc: giveBloc,
              builder: (context, state) {
                // Build inline snackbar widget when QR is confirmed
                // Hide on very small screens (< 360px), show on normal phones and larger
                Widget? qrConfirmWidget;
                final screenWidth = MediaQuery.of(context).size.width;
                final isNotSmallScreen =
                    screenWidth >=
                    360; // Hide on very small screens like iPhone SE

                if (state.status == GiveStatus.readyToGive &&
                    _qrConfirmed &&
                    isNotSmallScreen) {
                  final orgName = state.organisation.organisationName ?? '';
                  if (orgName.isNotEmpty) {
                    // Get the icon for the organisation type asynchronously
                    final mediumId = state.organisation.mediumId ?? '';
                    qrConfirmWidget = FutureBuilder<IconData>(
                      future: _getOrganisationIcon(mediumId),
                      builder: (context, snapshot) {
                        final iconData =
                            snapshot.data ?? FontAwesomeIcons.church;
                        return FunSnackbarWidget(
                          extraText: context.l10n.homeScreenChosenOrg(orgName),
                          icon: FaIcon(
                            iconData,
                            color: FamilyAppTheme.secondary30,
                            size: 20,
                          ),
                        );
                      },
                    );
                  }
                }

                return HomePageView(
                  initialAmount: widget.initialAmount,
                  given: widget.given,
                  retry: widget.retry,
                  code: widget.code,
                  afterGivingRedirection: widget.afterGivingRedirection,
                  onPageChanged: widget.onPageChanged,
                  giveBloc: giveBloc,
                  qrConfirmWidget: qrConfirmWidget,
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Helper function to get the organisation icon based on the mediumId
  /// Looks up the CollectGroup type and returns the appropriate icon
  Future<IconData> _getOrganisationIcon(String mediumId) async {
    if (mediumId.isEmpty) {
      return FontAwesomeIcons.church; // Default icon
    }

    try {
      // Extract namespace from mediumId (format: namespace.instance)
      final namespace = mediumId.contains('.')
          ? mediumId.split('.').first
          : mediumId;

      // Get CollectGroupRepository and look up the type
      final collectGroupRepository = getIt<CollectGroupRepository>();
      final collectGroupList = await collectGroupRepository
          .getCollectGroupList();

      if (collectGroupList.isEmpty) {
        return FontAwesomeIcons.church; // Default icon
      }

      // Find the matching CollectGroup by namespace
      final collectGroup = collectGroupList.firstWhere(
        (group) =>
            group.nameSpace == namespace ||
            group.nameSpace.startsWith(namespace),
        orElse: CollectGroup.empty,
      );

      if (collectGroup.type == CollectGroupType.none) {
        return FontAwesomeIcons.church; // Default icon
      }

      return CollectGroupType.getIconByType(collectGroup.type);
    } catch (e) {
      LoggingInfo.instance.error('Error getting organisation icon: $e');
      return FontAwesomeIcons.church; // Default icon on error
    }
  }
}
