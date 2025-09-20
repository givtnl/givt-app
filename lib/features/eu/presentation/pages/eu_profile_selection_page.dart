import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/eu/cubit/eu_profiles_cubit.dart';
import 'package:givt_app/features/eu/models/eu_profile.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:go_router/go_router.dart';

class EuProfileSelectionPage extends StatefulWidget {
  const EuProfileSelectionPage({super.key});

  @override
  State<EuProfileSelectionPage> createState() => _EuProfileSelectionPageState();
}

class _EuProfileSelectionPageState extends State<EuProfileSelectionPage> {
  late final EuProfilesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<EuProfilesCubit>();
    _cubit.fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunTopAppBar(
        title: 'Select Profile',
        showBackButton: false,
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onLoading: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        onData: (context, profiles) {
          if (profiles.isEmpty) {
            return const Center(
              child: Text('No profiles available'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Choose your profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select which profile you want to use for giving',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                // Add profile button for testing
                if (profiles.length == 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FunButton.secondary(
                      onTap: () => _addTestProfile(),
                      text: 'Add Test Profile',
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return _ProfileCard(
                        profile: profile,
                        onTap: () => _onProfileSelected(profile),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        onError: (context, error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading profiles',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.errorMessage,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FunButton(
                onTap: () => _cubit.fetchProfiles(),
                text: 'Retry',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onProfileSelected(EuProfile profile) async {
    // Log analytics event
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.profilePressed,
        eventProperties: {
          'profile_id': profile.id,
          'profile_name': profile.displayName,
        },
      ),
    );

    // Show authentication dialog for profile switching
    final shouldSwitch = await _showAuthDialog(profile);
    
    if (shouldSwitch && mounted) {
      await _cubit.switchProfile(profile.id);
      
      // Log profile switch event
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.profileSwitchPressed,
          eventProperties: {
            'profile_id': profile.id,
            'profile_name': profile.displayName,
          },
        ),
      );
      
      // Navigate to the EU home page
      if (mounted) {
        context.goNamed('home');
      }
    }
  }

  Future<bool> _showAuthDialog(EuProfile profile) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FunDialog(
        icon: FunAvatar.fromProfile(
          profile.userExt,
          size: 64,
        ),
        title: 'Switch Profile',
        subtitle: 'Please authenticate to switch to ${profile.displayName}',
        buttons: [
          FunButton(
            onTap: () async {
              // Show authentication dialog similar to login
              final authCubit = context.read<AuthCubit>();
              
              // For demo purposes, we'll simulate authentication
              // In a real implementation, this would show a login form
              await _showLoginDialog(profile);
              
              context.pop(true);
            },
            text: 'Authenticate',
            analyticsEvent: AmplitudeEvents.profileSwitchPressed.toEvent(),
          ),
          FunButton.secondary(
            onTap: () => context.pop(false),
            text: 'Cancel',
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _showLoginDialog(EuProfile profile) async {
    final emailController = TextEditingController(text: profile.email);
    final passwordController = TextEditingController();
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your password to switch profiles:'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                enabled: false, // Email is read-only
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // In a real implementation, this would authenticate with the backend
              // For demo purposes, we'll just proceed
              context.pop();
            },
            child: const Text('Authenticate'),
          ),
        ],
      ),
    );
  }

  Future<void> _addTestProfile() async {
    // Create a test profile
    final testProfile = EuProfile(
      id: 'test_profile_${DateTime.now().millisecondsSinceEpoch}',
      email: 'test.user@example.com',
      firstName: 'Test',
      lastName: 'User',
      profilePicture: '',
      isActive: false,
      userExt: UserExt.empty().copyWith(
        guid: 'test_profile_${DateTime.now().millisecondsSinceEpoch}',
        email: 'test.user@example.com',
        firstName: 'Test',
        lastName: 'User',
      ),
    );

    await _cubit.addProfile(testProfile.userExt);
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.onTap,
  });

  final EuProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: FunCard(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: profile.isActive 
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                child: profile.profilePicture.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          profile.profilePicture,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildInitialsAvatar(),
                        ),
                      )
                    : _buildInitialsAvatar(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (profile.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Text(
      profile.initials,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}