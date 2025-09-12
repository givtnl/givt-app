import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/qr_code_management/cubit/qr_code_management_cubit.dart';
import 'package:givt_app/features/family/features/qr_code_management/models/qr_code_management_uimodel.dart';
import 'package:givt_app/features/family/features/qr_code_management/presentation/widgets/qr_code_list_item.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/bloc/base_state_consumer.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class QrCodeManagementScreen extends StatelessWidget {
  const QrCodeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer<QrCodeManagementCubit, QrCodeManagementUIModel, QrCodeManagementCustom>(
      onCustom: (context, custom) {
        switch (custom) {
          case QrCodeDownloadRequested(:final qrCodeId):
            _handleQrCodeDownload(context, qrCodeId);
            break;
        }
      },
      onData: (context, uiModel) {
        return FunScaffold(
          minimumPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          appBar: FunTopAppBar(
            title: 'QR Codes',
            actions: [
              _buildCreateQrCodeButton(context),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              // Mobile: Show Create QR Code button below title
              if (_isMobile(context)) ...[
                _buildMobileCreateQrCodeButton(context),
                const SizedBox(height: 16),
              ],
              _buildTabsSection(context, uiModel),
              const SizedBox(height: 24),
              Expanded(
                child: _buildQrCodeList(context, uiModel),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreateQrCodeButton(BuildContext context) {
    // Desktop: Show in top-right corner
    if (!_isMobile(context)) {
      return FunButton(
        onTap: () => _showCreateQrCodeDialog(context),
        text: 'Create QR Code',
        leftIcon: FontAwesomeIcons.plus,
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.qrCodeCreateButtonPressed,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMobileCreateQrCodeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FunButton(
        onTap: () => _showCreateQrCodeDialog(context),
        text: 'Create QR Code',
        leftIcon: FontAwesomeIcons.plus,
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.qrCodeCreateButtonPressed,
        ),
      ),
    );
  }

  Widget _buildTabsSection(BuildContext context, QrCodeManagementUIModel uiModel) {
    return FunPrimaryTabs(
      options: const ['Active', 'Inactive'],
      icons: const [
        Icon(FontAwesomeIcons.play, size: 16),
        Icon(FontAwesomeIcons.pause, size: 16),
      ],
      selectedIndex: uiModel.selectedTabIndex,
      onPressed: (index) {
        context.read<QrCodeManagementCubit>().switchTab(index);
      },
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.qrCodeTabSwitched,
      ),
    );
  }

  Widget _buildQrCodeList(BuildContext context, QrCodeManagementUIModel uiModel) {
    final qrCodes = uiModel.currentQrCodes;

    if (qrCodes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              uiModel.isActiveTabSelected
                  ? FontAwesomeIcons.play
                  : FontAwesomeIcons.pause,
              size: 48,
              color: FamilyAppTheme.neutral70,
            ),
            const SizedBox(height: 16),
            TitleMediumText(
              uiModel.isActiveTabSelected
                  ? 'No Active QR Codes'
                  : 'No Inactive QR Codes',
              color: FamilyAppTheme.neutral70,
            ),
            const SizedBox(height: 8),
            BodyMediumText(
              uiModel.isActiveTabSelected
                  ? 'Create a new QR code to get started'
                  : 'All your deactivated QR codes will appear here',
              color: FamilyAppTheme.neutral70,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: qrCodes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final qrCode = qrCodes[index];
        return QrCodeListItem(
          qrCode: qrCode,
          isMobile: _isMobile(context),
          onActivate: () {
            context.read<QrCodeManagementCubit>().activateQrCode(qrCode.instance);
          },
          onDeactivate: () {
            context.read<QrCodeManagementCubit>().deactivateQrCode(qrCode.instance);
          },
          onDownload: () {
            context.read<QrCodeManagementCubit>().downloadQrCode(qrCode.instance);
          },
        );
      },
    );
  }

  void _showCreateQrCodeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _CreateQrCodeDialog(
        onCreateQrCode: (name) {
          context.read<QrCodeManagementCubit>().createQrCode(name);
        },
      ),
    );
  }

  void _handleQrCodeDownload(BuildContext context, String qrCodeId) {
    // TODO: Implement actual QR code download/sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading QR code: $qrCodeId'),
        backgroundColor: FamilyAppTheme.secondary80,
      ),
    );
  }

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }
}

class _CreateQrCodeDialog extends StatefulWidget {
  const _CreateQrCodeDialog({
    required this.onCreateQrCode,
  });

  final void Function(String name) onCreateQrCode;

  @override
  State<_CreateQrCodeDialog> createState() => _CreateQrCodeDialogState();
}

class _CreateQrCodeDialogState extends State<_CreateQrCodeDialog> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const TitleMediumText('Create New QR Code'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'QR Code Name',
                hintText: 'Enter a name for your QR code',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FunButton(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              widget.onCreateQrCode(_nameController.text.trim());
              Navigator.of(context).pop();
            }
          },
          text: 'Create',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.qrCodeCreated,
          ),
        ),
      ],
    );
  }
}