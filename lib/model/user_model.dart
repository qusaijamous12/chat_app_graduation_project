class UserModel{
  final String ?userName;
  final String ?email;
  final String ?uid;
  final String ?phoneNumber;
  final int ?status;


  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.email,
    required this.userName,
    required this.status,

  });

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      uid: json['uid'],
      phoneNumber: json['mobile_number']??'',
      email: json['email']??'',
      status: json['status']??'',
      userName: json['user_name']??'',


    );
  }

}