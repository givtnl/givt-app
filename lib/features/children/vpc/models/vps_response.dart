import 'package:equatable/equatable.dart';

class VPCResponse extends Equatable {
  const VPCResponse({
    required this.url,
    required this.successUrl,
    required this.cancelUrl,
  });

  factory VPCResponse.fromJson(Map<String, dynamic> json) => VPCResponse(
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
