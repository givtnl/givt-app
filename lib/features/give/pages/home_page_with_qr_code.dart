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
  bool _isShowingDialog = false;
  String? _confirmedOrgName; // Store organisation name when confirmed
  String? _confirmedInstanceName; // Store instance name when confirmed

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GiveBloc, GiveState>(
          listenWhen: (previous, current) {
            // Listen to status changes and readyToGive status
            return previous.status != current.status ||
                previous.organisation != current.organisation;
          },
          listener: (context, state) {
            // Reset flags when state goes back to initial (e.g., after cancel)
            if (state.status == GiveStatus.initial) {
              setState(() {
                _qrConfirmed = false;
                _isShowingDialog = false;
                _confirmedOrgName = null;
                _confirmedInstanceName = null;
              });
              return;
            }
            
            // Show confirmation dialog when QR code is ready to confirm
            if (state.status == GiveStatus.readyToConfirm && 
                !_qrConfirmed && 
                !_isShowingDialog) {
              final orgName = state.organisation.organisationName ?? '';
              
              LoggingInfo.instance.info(
                'BlocListener triggered - status: ${state.status}, '
                'orgName: $orgName, '
                'mediumId: ${state.organisation.mediumId}, '
                '_qrConfirmed: $_qrConfirmed, '
                '_isShowingDialog: $_isShowingDialog',
              );
              
              if (orgName.isNotEmpty) {
                // Prevent multiple dialogs from being shown
                _isShowingDialog = true;
                
                // Get the icon for the organisation type asynchronously
                final mediumId = state.organisation.mediumId ?? '';
                final giveBloc = context.read<GiveBloc>();
                
                // Show dialog with timeout to prevent hanging
                _getOrganisationIcon(mediumId)
                    .timeout(
                      const Duration(seconds: 3),
                      onTimeout: () {
                        LoggingInfo.instance.warning(
                          'Icon fetch timed out, using default icon',
                        );
                        return FontAwesomeIcons.church;
                      },
                    )
                    .then((iconData) {
                      if (!mounted) {
                        _isShowingDialog = false;
                        return;
                      }
                      
                      // Get current state from bloc to ensure it's still readyToConfirm
                      final currentState = giveBloc.state;
                      if (currentState.status == GiveStatus.readyToConfirm && 
                          !_qrConfirmed) {
                        // Use addPostFrameCallback to ensure dialog is shown after build completes
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) {
                            _isShowingDialog = false;
                            return;
                          }
                          
                          final instanceName = giveBloc.state.instanceName;
                          _showQrConfirmDialog(
                            context,
                            orgName: orgName,
                            iconData: iconData,
                            giveBloc: giveBloc,
                            instanceName: instanceName,
                          );
                        });
                      } else {
                        _isShowingDialog = false;
                      }
                    })
                    .catchError((Object error) {
                      LoggingInfo.instance.error(
                        'Error getting organisation icon: $error',
                      );
                      // Still show dialog with default icon even if fetch fails
                      if (mounted) {
                        final currentState = giveBloc.state;
                        if (currentState.status == GiveStatus.readyToConfirm && 
                            !_qrConfirmed) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) {
                              _isShowingDialog = false;
                              return;
                            }
                            final instanceName = giveBloc.state.instanceName;
                            _showQrConfirmDialog(
                              context,
                              orgName: orgName,
                              iconData: FontAwesomeIcons.church,
                              giveBloc: giveBloc,
                              instanceName: instanceName,
                            );
                          });
                        } else {
                          _isShowingDialog = false;
                        }
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

                // Show snackbar when QR is confirmed and we have an organisation
                // Use stored organisation name if state doesn't have it (fallback)
                // Check for both null and empty string
                final stateOrgName = state.organisation.organisationName;
                final orgName = (stateOrgName != null && stateOrgName.isNotEmpty)
                    ? stateOrgName
                    : (_confirmedOrgName ?? '');
                final stateInstanceName = state.instanceName;
                final instanceName = stateInstanceName.isNotEmpty 
                    ? stateInstanceName 
                    : (_confirmedInstanceName ?? '');
                
                final shouldShowSnackbar = _qrConfirmed &&
                    isNotSmallScreen &&
                    orgName.isNotEmpty;

                // Debug logging
                if (_qrConfirmed) {
                  LoggingInfo.instance.info(
                    'QR confirmed - shouldShowSnackbar: $shouldShowSnackbar, '
                    'isNotSmallScreen: $isNotSmallScreen, '
                    'orgName from state: ${state.organisation.organisationName}, '
                    'orgName stored: $_confirmedOrgName, '
                    'orgName final: $orgName, '
                    'status: ${state.status}',
                  );
                }

                if (shouldShowSnackbar) {
                  // Format organization name with instance name if available
                  final formattedOrgName = instanceName.isNotEmpty && 
                          instanceName != orgName
                      ? '$orgName: $instanceName'
                      : orgName;
                  
                  // Get the icon for the organisation type asynchronously
                  // Use mediumId from state, or try to get it from the confirmed state
                  final mediumId = state.organisation.mediumId?.isNotEmpty == true
                      ? state.organisation.mediumId!
                      : '';
                  qrConfirmWidget = FutureBuilder<IconData>(
                    future: _getOrganisationIcon(mediumId),
                    builder: (context, snapshot) {
                      final iconData =
                          snapshot.data ?? FontAwesomeIcons.church;
                      return FunSnackbarWidget(
                        extraText: context.l10n.homeScreenChosenOrg(formattedOrgName),
                        icon: FaIcon(
                          iconData,
                          color: FamilyAppTheme.secondary30,
                          size: 20,
                        ),
                      );
                    },
                  );
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

  /// Shows the QR confirmation dialog
  void _showQrConfirmDialog(
    BuildContext context, {
    required String orgName,
    required IconData iconData,
    required GiveBloc giveBloc,
    String? instanceName,
  }) {
    QrConfirmOrgDialog.show(
      context,
      organizationName: orgName,
      icon: iconData,
      instanceName: instanceName,
      onConfirm: () {
        // Store organisation name before state might change
        final currentState = giveBloc.state;
        
        LoggingInfo.instance.info(
          'About to confirm QR - orgName: ${currentState.organisation.organisationName}, '
          'mediumId: ${currentState.organisation.mediumId}, '
          'status: ${currentState.status}',
        );
        
        setState(() {
          _qrConfirmed = true;
          _isShowingDialog = false;
          _confirmedOrgName = currentState.organisation.organisationName;
          _confirmedInstanceName = currentState.instanceName;
        });
        // Skip submission - we'll submit when user clicks Next
        giveBloc.add(
          const GiveConfirmQRCodeScannedOutOfApp(
            skipSubmission: true,
          ),
        );
      },
      onCancel: () {
        setState(() {
          _isShowingDialog = false;
        });
        // Just close the dialog, user stays on home page
        // Reset the QR code state
        giveBloc.add(const GiveReset());
      },
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
