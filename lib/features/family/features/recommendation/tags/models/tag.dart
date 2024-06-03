import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/areas.dart';

class Tag extends Equatable {
  const Tag({
    required this.key,
    required this.area,
    required this.displayText,
    required this.pictureUrl,
    required this.type,
  });

  final String key;
  final Areas area;
  final String displayText;
  final String pictureUrl;
  final TagType type;

  @override
  List<Object> get props => [
        key,
        area,
        displayText,
        pictureUrl,
        type,
      ];

  const Tag.empty()
      : this(
          key: '',
          area: Areas.location,
          displayText: 'Empty Tag',
          pictureUrl: '',
          type: TagType.INTERESTS,
        );

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      key: map['key'] as String,
      area: Areas.fromMap(map),
      displayText: map['displayText'] as String,
      pictureUrl: map['pictureUrl'] as String,
      type: TagType.values.firstWhere(
        (element) => element.name == map['type'],
        orElse: () => TagType.INTERESTS,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'area': area.name.toUpperCase(),
      'displayText': displayText,
      'pictureUrl': pictureUrl,
      'type': type.name,
    };
  }
}

// ignore: constant_identifier_names
enum TagType { LOCATION, INTERESTS }
