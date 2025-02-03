class GroupModel {
  final String title;
  final int member;
  final String groupDescription;
  final String uid;

  GroupModel({
    required this.title,
    required this.member,
    required this.uid,
    required this.groupDescription
  });

  factory GroupModel.fromJson(Map<String, dynamic> json){
    return GroupModel(
        title: json['group_name'],
        groupDescription: json['group_description'],
        uid: json['uid'],
        member: json['group_number']);
  }

}