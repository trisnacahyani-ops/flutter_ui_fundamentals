class Course {
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      credits: int.tryParse(json['credits'].toString()) ?? 0,
      status: json['status']?.toString() ?? 'planned',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'title': title, 'credits': credits, 'status': status};
  }
}
