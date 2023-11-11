class TeacherFeedBack {
  num stars;
  String message;

  TeacherFeedBack({
    required this.stars,
    required this.message,
  });

  factory TeacherFeedBack.fromJson(Map<String, dynamic> json) {
    return TeacherFeedBack(
      stars: json['stars'] as num,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stars': stars,
      'message': message,
    };
  }
}
