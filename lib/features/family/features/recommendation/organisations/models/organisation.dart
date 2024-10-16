import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/features/reflect/data/recommendation_types.dart';

class Organisation extends Equatable {
  const Organisation({
    required this.guid,
    required this.type,
    required this.name,
    required this.organisationLogoURL,
    required this.promoPictureUrl,
    required this.shortDescription,
    required this.longDescription,
    required this.tags,
    required this.collectGroupId,
    required this.namespace,
    required this.qrCodeURL,
  });

  factory Organisation.fromMap(Map<String, dynamic> map) {
    return Organisation(
      guid: (map['guid'] ?? '') as String,
      name: (map['name'] ?? 'Organisation Name') as String,
      organisationLogoURL: (map['organisationLogoURL'] ?? '') as String,
      promoPictureUrl: (map['promoPictureUrl'] ?? '') as String,
      shortDescription: (map['shortDescription'] ?? '') as String,
      longDescription: (map['longDescription'] ?? '') as String,
      collectGroupId: (map['collectGroupId'] ?? '') as String,
      namespace: (map['namespace'] ?? '') as String,
      qrCodeURL: (map['qrCodeURL'] ?? '') as String,
      type: RecommendationTypes.fromString((map['type'] ?? '') as String),
      tags: map['tags'] != null
          ? List<Tag>.from(
              (map['tags'] as List<dynamic>)
                  .map((e) => Tag.fromMap(e as Map<String, dynamic>)),
            )
          : [],
    );
  }

  final String guid;
  final RecommendationTypes type;
  final String name;
  final String organisationLogoURL;
  final String promoPictureUrl;
  final String shortDescription;
  final String longDescription;
  final List<Tag> tags;
  final String collectGroupId;
  final String namespace;
  final String qrCodeURL;
  @override
  List<Object?> get props => [
        guid,
        collectGroupId,
        name,
        type,
        namespace,
        qrCodeURL,
        organisationLogoURL,
        promoPictureUrl,
        shortDescription,
        longDescription,
        tags,
      ];

  Organisation copyWith({
    RecommendationTypes? type,
    String? guid,
    String? collectGroupId,
    String? name,
    String? namespace,
    String? qrCodeURL,
    String? organisationLogoURL,
    String? promoPictureUrl,
    String? shortDescription,
    String? longDescription,
    List<Tag>? tags,
  }) =>
      Organisation(
        type: type ?? this.type,
        guid: guid ?? this.guid,
        collectGroupId: collectGroupId ?? this.collectGroupId,
        name: name ?? this.name,
        namespace: namespace ?? this.namespace,
        qrCodeURL: qrCodeURL ?? this.qrCodeURL,
        organisationLogoURL: organisationLogoURL ?? this.organisationLogoURL,
        promoPictureUrl: promoPictureUrl ?? this.promoPictureUrl,
        shortDescription: shortDescription ?? this.shortDescription,
        longDescription: longDescription ?? this.longDescription,
        tags: tags ?? this.tags,
      );

  Map<String, dynamic> toJson() {
    return {
      'guid': guid,
      'collectGroupId': collectGroupId,
      'type': type.value,
      'name': name,
      'namespace': namespace,
      'qrCodeURL': qrCodeURL,
      'organisationLogoURL': organisationLogoURL,
      'promoPictureUrl': promoPictureUrl,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'tags': jsonEncode(tags),
    };
  }
}
