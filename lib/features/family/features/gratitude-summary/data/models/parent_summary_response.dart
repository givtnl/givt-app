class SummaryResponse {

  SummaryResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.familyMemberId,
  });

  factory SummaryResponse.fromJson(Map<String, dynamic> json) {
    return SummaryResponse(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      date: json['date'] as String,
      familyMemberId: json['familyMemberId'] as String,
    );
  }
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String familyMemberId;

}