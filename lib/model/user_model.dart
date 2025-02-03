class UserModel{
  final String ?userName;
  final String ?email;
  final String ?uid;
  final String ?phoneNumber;
  final int ?status;
  final String ?age;
  final String ?description;
  final String ?major;
  final String ?sendUid;
  final String ?gender;
  final String ?profileImage;


  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.email,
    required this.userName,
    required this.status,
    required this.age,
    required this.description,
    required this.major,
    required this.sendUid,
    required this.gender,
    required this.profileImage

  });

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      uid: json['uid'],
      phoneNumber: json['mobile_number']??'',
      email: json['email']??'',
      status: json['status']??'',
      userName: json['user_name']??'',
      age: json['age']??'',
      description: json['description']??'',
      major: json['major']??'',
      sendUid: json['send_uid']??'',
      gender: json['gender']??"",
      profileImage: json['profile_image']??''


    );
  }

}