class Student {
  final String image;
  final String name;
  final String course;
  final String yearLevel;
  final int age;
  final String hobby;
  final String studentId;
  final String email;
  final String favoriteSubject;
  final bool isActive;

  Student({
    required this.image,
    required this.name,
    required this.course,
    required this.yearLevel,
    required this.age,
    required this.hobby,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'image': image,
    'name': name,
    'course': course,
    'yearLevel': yearLevel,
    'age': age,
    'hobby': hobby,
    'studentId': studentId,
    'email': email,
    'favoriteSubject': favoriteSubject,
    'isActive': isActive,
  };

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      image: json['image'] as String? ?? 'assets/profile2.jpg',
      name: json['name'] as String? ?? '',
      course: json['course'] as String? ?? '',
      yearLevel: json['yearLevel'] as String? ?? '',
      age: (json['age'] as num?)?.toInt() ?? 18,
      hobby: json['hobby'] as String? ?? 'Not specified',
      studentId: json['studentId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      favoriteSubject: json['favoriteSubject'] as String? ?? 'Not specified',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Student copyWith({
    String? name,
    String? course,
    String? yearLevel,
    int? age,
    String? hobby,
    String? email,
    String? favoriteSubject,
  }) {
    return Student(
      image: image,
      name: name ?? this.name,
      course: course ?? this.course,
      yearLevel: yearLevel ?? this.yearLevel,
      age: age ?? this.age,
      hobby: hobby ?? this.hobby,
      studentId: studentId,
      email: email ?? this.email,
      favoriteSubject: favoriteSubject ?? this.favoriteSubject,
      isActive: isActive,
    );
  }
}
