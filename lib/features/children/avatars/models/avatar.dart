import 'package:equatable/equatable.dart';

class Avatar extends Equatable {
  const Avatar({
    required this.filename,
    required this.url,
  });

  factory Avatar.fromMap(Map<String, dynamic> map) {
    return Avatar(
      filename: (map['filename'] ?? '').toString(),
      url: (map['url'] ?? '').toString(),
    );
  }

  final String filename;
  final String url;

  @override
  List<Object?> get props => [filename, url];
}
