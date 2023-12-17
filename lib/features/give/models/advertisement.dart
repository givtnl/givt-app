import 'package:equatable/equatable.dart';
import 'package:givt_app/features/give/models/models.dart';

class Advertisement extends Equatable {
  const Advertisement({
    required this.id,
    required this.title,
    required this.text,
    required this.imageUrl,
    required this.metaInfo,
  });

  final String id;
  final Map<String, String> title;
  final Map<String, String> text;
  final Map<String, String> imageUrl;
  final AdvertisementMetaInfo metaInfo;

  Advertisement copyWith({
    String? id,
    Map<String, String>? title,
    Map<String, String>? text,
    Map<String, String>? imageUrl,
    AdvertisementMetaInfo? metaInfo,
  }) {
    return Advertisement(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      metaInfo: metaInfo ?? this.metaInfo,
    );
  }

  @override
  List<Object> get props => [
        id,
        title,
        text,
        imageUrl,
        metaInfo,
      ];
}
