class DoctorModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String specialization;
  final int experienceYears;
  final String bio;
  final double consultationFee;
  final String? clinicId;
  final bool isApproved;
  final double averageRating;
  final int totalReviews;
  final Map<String, List<String>> availability; // day -> time slots

  const DoctorModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.specialization,
    required this.experienceYears,
    required this.bio,
    required this.consultationFee,
    this.clinicId,
    this.isApproved = false,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.availability = const {},
  });

  DoctorModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? specialization,
    int? experienceYears,
    String? bio,
    double? consultationFee,
    String? clinicId,
    bool? isApproved,
    double? averageRating,
    int? totalReviews,
    Map<String, List<String>>? availability,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      specialization: specialization ?? this.specialization,
      experienceYears: experienceYears ?? this.experienceYears,
      bio: bio ?? this.bio,
      consultationFee: consultationFee ?? this.consultationFee,
      clinicId: clinicId ?? this.clinicId,
      isApproved: isApproved ?? this.isApproved,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      availability: availability ?? this.availability,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'specialization': specialization,
      'experienceYears': experienceYears,
      'bio': bio,
      'consultationFee': consultationFee,
      'clinicId': clinicId,
      'isApproved': isApproved,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'availability': availability,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map, String docId) {
    return DoctorModel(
      id: docId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      specialization: map['specialization'] ?? '',
      experienceYears: map['experienceYears'] ?? 0,
      bio: map['bio'] ?? '',
      consultationFee: (map['consultationFee'] ?? 0).toDouble(),
      clinicId: map['clinicId'],
      isApproved: map['isApproved'] ?? false,
      averageRating: (map['averageRating'] ?? 0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      availability: Map<String, List<String>>.from(
        (map['availability'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
    );
  }
}
