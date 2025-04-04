import 'package:equatable/equatable.dart';

class Avatar extends Equatable {
  const Avatar({
    required this.fileName,
    this.pictureURL,
  });

  factory Avatar.fromMap(Map<String, dynamic> map) {
    return Avatar(
      fileName: (map['fileName'] ?? '').toString(),
      pictureURL: (map['pictureURL'] ?? '').toString(),
    );
  }
  const Avatar.empty()
      : fileName = '',
        pictureURL = '';

  final String fileName;
  final String? pictureURL;

  @override
  List<Object?> get props => [fileName, pictureURL];
}
