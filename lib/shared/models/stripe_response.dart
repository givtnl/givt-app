import 'package:equatable/equatable.dart';

class StripeResponse extends Equatable {
  const StripeResponse({
    required this.url,
    required this.successUrl,
    required this.cancelUrl,
  });

  factory StripeResponse.fromJson(Map<String, dynamic> json) => StripeResponse(
        url: json['url'] as String,
        successUrl: json['successUrl'] as String,
        cancelUrl: json['cancelUrl'] as String,
      );

  final String url;
  final String successUrl;
  final String cancelUrl;

  @override
  List<Object?> get props => [
        url,
        successUrl,
        cancelUrl,
      ];
}
