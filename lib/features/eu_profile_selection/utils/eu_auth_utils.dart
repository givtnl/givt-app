import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/eu_profile_selection/models/eu_profile.dart';

class EuAuthUtils {
  static Future<void> authenticateUser(
    BuildContext context, {
    required EuProfile targetProfile,
    required VoidCallback onSuccess,
  }) async {
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.state.user;
    
    // If switching to the same profile, no authentication needed
    if (currentUser.guid == targetProfile.id) {
      onSuccess();
      return;
    }
    
    // Show authentication dialog
    final shouldAuthenticate = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Switch Profile'),
        content: Text(
          'Please authenticate to switch to ${targetProfile.name}\'s profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    
    if (shouldAuthenticate == true) {
      // For now, we'll just show a simple password dialog
      // In a real implementation, this would use biometric authentication
      // or prompt for the user's password
      final password = await _showPasswordDialog(context);
      
      if (password != null) {
        // Simulate authentication - in real implementation, verify password
        await _simulateAuthentication(context, targetProfile);
        onSuccess();
      }
    }
  }
  
  static Future<String?> _showPasswordDialog(BuildContext context) async {
    final controller = TextEditingController();
    
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Enter your password',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  static Future<void> _simulateAuthentication(
    BuildContext context,
    EuProfile targetProfile,
  ) async {
    // Show loading dialog
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));
    
    // Close loading dialog
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    
    // In a real implementation, this would:
    // 1. Verify the password with the server
    // 2. Get a new session token for the target profile
    // 3. Update the auth state
  }
}
