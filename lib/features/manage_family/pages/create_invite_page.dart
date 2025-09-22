import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/manage_family/cubit/manage_family_cubit.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:go_router/go_router.dart';

class CreateInvitePage extends StatefulWidget {
  const CreateInvitePage({super.key});

  @override
  State<CreateInvitePage> createState() => _CreateInvitePageState();
}

class _CreateInvitePageState extends State<CreateInvitePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Create Family Invite',
        leading: GivtBackButtonFlat(),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          OutlinedTextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Enter the email address',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email address';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 48),

          // Message field
          TextFormField(
            controller: _messageController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Personal Message (Optional)',
              hintText: 'Add a personal message to your invitation',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.message_outlined),
            ),
          ),
          const Spacer(),
          // Send button
          FunButton(
            text: _isLoading ? 'Sending...' : 'Send Invitation',
            onTap: _isLoading ? null : _sendInvite,
            analyticsEvent: AnalyticsEvent(AmplitudeEvents.okClicked),
          ),
          const SizedBox(height: 8),
          // Cancel button
          FunButton.secondary(
            text: 'Cancel',
            onTap: () => context.pop(),
            analyticsEvent: AnalyticsEvent(AmplitudeEvents.okClicked),
          ),
        ],
      ),
    );
  }

  Future<void> _sendInvite() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final cubit = getIt<ManageFamilyCubit>();
      await cubit.sendInvite(
        _emailController.text.trim(),
        _messageController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitation sent to ${_emailController.text}'),
            backgroundColor: FamilyAppTheme.primary40,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send invitation: $e'),
            backgroundColor: FamilyAppTheme.primary20,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
