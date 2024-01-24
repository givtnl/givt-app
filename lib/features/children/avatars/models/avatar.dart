import 'package:equatable/equatable.dart';

class Avatar extends Equatable {
  const Avatar({
    required this.fileName,
    required this.pictureURL,
  });

  factory Avatar.fromMap(Map<String, dynamic> map) {
    return Avatar(
      fileName: (map['fileName'] ?? '').toString(),
      pictureURL: (map['pictureURL'] ?? '').toString(),
    );
  }

  final String fileName;
  final String pictureURL;

  @override
  List<Object?> get props => [fileName, pictureURL];
}
