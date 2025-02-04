class RequestModel {
  final int status;
  final String uid;
  final String email;
  final String major;
  final String name;
  final String phone;
  final String profileImage;
  final String description;

  RequestModel({
    required this.uid,
    required this.email,
    required this.major,
    required this.name,
    required this.phone,
    required this.description,
    required this.status,
    required this.profileImage
  });

  factory RequestModel.fromJson(Map<String, dynamic> json){
    return RequestModel(uid: json['uid'],
        email: json['user_email'],
        major: json['user_major'],
        name: json['user_name'],
        phone: json['user_phone'],
        description: json['description'],
        profileImage: json['profile_image'],
        status: json['status']);
  }

}