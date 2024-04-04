import 'package:equatable/equatable.dart';

class StripeResponse extends Equatable {
  const StripeResponse({
    required this.customerId,
    required this.customerEphemeralKeySecret,
    required this.setupIntentClientSecret,
  });

  const StripeResponse.empty()
      : customerId = '',
        customerEphemeralKeySecret = '',
        setupIntentClientSecret = '';

  factory StripeResponse.fromJson(Map<String, dynamic> json) => StripeResponse(
        customerId: json['customerId'] as String,
        customerEphemeralKeySecret: json['customerEphemeralKeySecret'] as String,
        setupIntentClientSecret: json['setupIntentClientSecret'] as String,
      );

  final String customerId;
  final String customerEphemeralKeySecret;
  final String setupIntentClientSecret;

  @override
  List<Object?> get props => [
        customerId,
        customerEphemeralKeySecret,
        setupIntentClientSecret,
      ];
}
