import 'package:equatable/equatable.dart';

/// Featured door-to-door collect group from
/// `GET /givtservice/v1/Organisation/featured-door-to-door`.
/// Organisation name is resolved from [nameSpace] via the collect-group list.
class FeaturedCollectGroup extends Equatable {
  const FeaturedCollectGroup({
    required this.nameSpace,
    required this.logoUrl,
  });

  factory FeaturedCollectGroup.fromJson(Map<String, dynamic> json) {
    return FeaturedCollectGroup(
      nameSpace:
          (json['nameSpace'] as String?) ??
          (json['NameSpace'] as String?) ??
          '',
      logoUrl:
          (json['logoUrl'] as String?) ?? (json['LogoUrl'] as String?) ?? '',
    );
  }

  final String nameSpace;
  final String logoUrl;

  @override
  List<Object?> get props => [nameSpace, logoUrl];
}
