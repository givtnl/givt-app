import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';

class Organisation extends Equatable {
  const Organisation({
    required this.guid,
    required this.collectGroupId,
    required this.name,
    required this.namespace,
    required this.qrCodeURL,
    required this.organisationLogoURL,
    required this.promoPictureUrl,
    required this.shortDescription,
    required this.longDescription,
    required this.tags,
  });

  factory Organisation.fromMap(Map<String, dynamic> map) {
    return Organisation(
      guid: map['guid'] as String,
      collectGroupId: map['collectGroupId'] as String,
      name: map['name'] as String,
      namespace: map['namespace'] as String,
      qrCodeURL: map['qrCodeURL'] as String,
      organisationLogoURL: map['organisationLogoURL'] as String,
      promoPictureUrl: map['promoPictureUrl'] as String,
      shortDescription: map['shortDescription'] as String,
      longDescription: map['longDescription'] as String,
      tags: List<Tag>.from(
        (map['tags'] as List<dynamic>)
            .map((e) => Tag.fromMap(e as Map<String, dynamic>)),
      ),
    );
  }

  final String guid;
  final String collectGroupId;
  final String name;
  final String namespace;
  final String qrCodeURL;
  final String organisationLogoURL;
  final String promoPictureUrl;
  final String shortDescription;
  final String longDescription;
  final List<Tag> tags;

  @override
  List<Object?> get props => [
        guid,
        collectGroupId,
        name,
        namespace,
        qrCodeURL,
        organisationLogoURL,
        promoPictureUrl,
        shortDescription,
        longDescription,
        tags,
      ];

  Organisation copyWith({
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
