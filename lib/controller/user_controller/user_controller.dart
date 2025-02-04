import 'package:chat_app/model/group_chat_model.dart';
import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/model/request_model.dart';
import 'package:chat_app/view/admin_screen/admin_screen.dart';
import 'package:chat_app/view/home_screen/chat_screen.dart';
import 'package:chat_app/view/home_screen/group_details.dart';
import 'package:chat_app/view/home_screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../../model/chat_model.dart';
import '../../model/user_model.dart';
import '../../shared/config/utils/utils.dart';
import '../../view/home_screen/chat_group_screen.dart';
import '../../view/login_screen/login_screen.dart';

class UserController extends GetxController {
  final _isLoading = RxBool(false);
  final _userModel = Rxn<UserModel>();

  final _allUsers = RxList<UserModel>([]);
  final _allFriendRequest = RxList<UserModel>([]);
  final _myFriends = RxList<UserModel>([]);
  final _listChatModel = RxList<ChatModel>([]);
  final _instance = FirebaseFirestore.instance;
  
  final _allGroups=RxList<GroupModel>([]);
  final _allRequests=RxList<RequestModel>([]);

  final _allChatMessageGroup=RxList<GroupChatModel>([]);


  Future<void> login({required String email, required String password}) async {
    _isLoading(true);
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (result.user != null) {
        await getUserData(uid: result.user!.uid);

        Utils.myToast(title: 'Login Success');
        if (_userModel.value?.status == 0) {
          Get.offAll(() => const HomeScreen());
        }
        if (_userModel.value?.status == 1) {
          Get.offAll(() => const AdminScreen());
        }
      } else {
        Utils.myToast(title: 'Login Failed');
      }
    } catch (e) {
      print('there is an error in login $e');
      Utils.myToast(title: 'Login Failed');
    }
    _isLoading(false);
  }

  Future<void> createAccount(
      {required String email,
      required String name,
      required String password,
      required String phoneNumber,
      int status = 0,
      required String age,
      required String description,
      required String major,
      required String gender}) async {
    _isLoading(true);
    try {
      final auth = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (auth.user != null) {
        await saveDataToFireStore(
            email: email,
            name: name,
            phone: phoneNumber,
            uid: auth.user!.uid,
            status: status,
            age: age,
            description: description,
            major: major,
            gender: gender);

        Get.offAll(() => const LoginScreen());
      } else {
        Utils.myToast(title: 'Register Failed');
      }
    } catch (e) {
      print('there is an error $e');
      Utils.myToast(title: 'Register Failed');
    }
    _isLoading(false);
  }


  Future<void> forgetPassword({required String email})async{
    _isLoading(true);
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
      Utils.myToast(title: 'Please Check Your Email 1');
    }).catchError((error){
      Utils.myToast(title: 'Check Your Internet');
    });
    _isLoading(false);


  }

  Future<void> saveDataToFireStore(
      {required String email,
      required String name,
      required String phone,
      required String uid,
      dynamic status,
      required String description,
      required String age,
      required String major,
      required String gender}) async {
    try {
      final store =
          await _instance.collection('users').doc(uid).set({
        'email': email,
        'user_name': name,
        'mobile_number': phone,
        'uid': uid,
        'status': status,
        'age': age,
        'description': description,
        'major': major,
        'gender': gender,
        'profile_image': gender == 'Male'
            ? 'https://static.vecteezy.com/system/resources/thumbnails/051/948/045/small_2x/a-smiling-man-with-glasses-wearing-a-blue-sweater-poses-warmly-against-a-white-background-free-photo.jpeg'
            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRC6R4Gt9B7p36ZaS8rhWwq-yF4iUpakWPCWA&s'
      });
      Utils.myToast(title: 'Register Success');
    } catch (e) {
      print('There is an error in saveDataToFireStore method ');
    }
  }

  Future<void> getUserData({required String uid}) async {
    try {
      final result =
          await _instance.collection('users').doc(uid).get();
      if (result.data() != null) {
        _userModel(UserModel.fromJson(result.data()!));
      } else {
        Utils.myToast(title: 'Please Check your network!');
      }
    } catch (e) {
      print('there is an error in get user Data $e');
    }
  }

  Future<void> updateUserData(
      {required String name, required String phone}) async {
    _isLoading(true);
    await _instance
        .collection('users')
        .doc(_userModel.value?.uid)
        .update({'mobile_number': phone, 'user_name': name}).then(
            (value) async {
      await getUserData(uid: _userModel.value!.uid!);
      Utils.myToast(title: 'Update Success');
    }).catchError((error) {
      print('there is an error in update $error');
    });
    _isLoading(false);
  }

  Future<void> getAllUsers() async {
    _allUsers.clear();
    _isLoading(true);
    await _instance.collection('users').get().then((value) async{
      value.docs.forEach((element) {
        if (element['status'] == 0) {
          if (element['uid'] != _userModel.value?.uid) {
            _allUsers.add(UserModel.fromJson(element.data()));
          }
        }
      });
      await getMyFriends();

    }).catchError((error) {
      print('there is an error when get all users');
    });
    // _isLoading(false);
  }

  Future<void> getMyFriends() async {
    _myFriends.clear();
    // _isLoading(true);
    await _instance
        .collection('users')
        .doc(_userModel.value?.uid)
        .collection('my_friends')
        .get()
        .then((value) async{
      value.docs.forEach((element) {
        if (element['status'] == 1) {
          _myFriends.add(UserModel.fromJson(element.data()));
        }
      });
      await getAllGroups();
    }).catchError((error) {
      print('Check Your Internet');
    });

    // _isLoading(false);
  }

  Future<void> deleteUser({required String uid}) async {
    _isLoading(true);
    try {
      final userRef = _instance.collection('users').doc(uid);

      await userRef.delete();

      print("User with UID: $uid has been deleted.");
      Utils.myToast(title: 'Deleted Success');
      Get.offAll(() => const AdminScreen());
    } catch (e) {
      print("Error deleting user: $e");
    }
    _isLoading(false);
  }

  Future<void> addFriend(
      {required String userName,
      required String uid,
      required String emailAddress}) async {
    _isLoading(true);

    bool requestExists = await _checkIfRequestExists(uid);

    if (requestExists) {
      Utils.myToast(title: 'Friend request already sent!');
      _isLoading(false);
      return;
    }

    try {
      await _instance
          .collection('users')
          .doc(_userModel.value?.uid)
          .collection('my_friends')
          .doc(uid)
          .set({
        'user_name': userName,
        'email': emailAddress,
        'uid': uid,
        'status': 0,
        'send_uid': _userModel.value?.uid,
        'profile_image': _userModel.value?.profileImage
      });

      await _instance
          .collection('users')
          .doc(uid)
          .collection('my_friends')
          .doc(_userModel.value?.uid)
          .set({
        'user_name': _userModel.value?.userName,
        'email': _userModel.value?.email,
        'uid': _userModel.value?.uid,
        'status': 0,
        'send_uid': _userModel.value?.uid,
        'profile_image': _userModel.value?.profileImage
      });

      Utils.myToast(title: 'Friend request sent successfully');
    } catch (error) {
      Utils.myToast(title: 'Check your internet connection!');
    }

    _isLoading(false);
  }

  Future<bool> _checkIfRequestExists(String uid) async {
    try {
      // Check the "my_friends" collection for the current user
      var snapshot = await _instance
          .collection('users')
          .doc(_userModel.value?.uid)
          .collection('my_friends')
          .where('uid', isEqualTo: uid)
          .get();

      // Check if a document exists with this uid, meaning a request was already sent
      if (snapshot.docs.isNotEmpty) {
        return true; // Friend request already exists
      } else {
        return false; // No request sent yet
      }
    } catch (error) {
      print("Error checking friend request: $error");
      return false; // Return false in case of any error
    }
  }

  Future<void> getAllFriendsRequest() async {
    _allFriendRequest.clear();
    _isLoading(true);
    await _instance
        .collection('users')
        .doc(_userModel.value?.uid)
        .collection('my_friends')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element['status'] == 0) {
          if (element['send_uid'] != _userModel.value?.uid) {
            _allFriendRequest.add(UserModel.fromJson(element.data()));
          }
        }
      });
    }).catchError((error) {
      print('error is ${error}');
      print('there is an error when get all friends requests !!');
    });

    _isLoading(false);
  }

  Future<void> acceptFriendsRequest(UserModel model) async {
    _isLoading(true);
    await _instance
        .collection('users')
        .doc(_userModel.value?.uid)
        .collection('my_friends')
        .doc(model.uid)
        .update({'status': 1}).then((value) {
      Utils.myToast(title: 'Accepted Successfully');
    }).catchError((error) {
      Utils.myToast(title: 'Check Your Internet !');
      Get.offAll(() => HomeScreen());
    });

    await _instance
        .collection('users')
        .doc(model.uid)
        .collection('my_friends')
        .doc(_userModel.value?.uid)
        .update({'status': 1}).then((Value) {
      Get.offAll(() => HomeScreen());
    });

    _isLoading(false);
  }

  Future<void> declineFriendsRequest(UserModel model) async {
    _isLoading(true);
    await _instance
        .collection('users')
        .doc(_userModel.value?.uid)
        .collection('my_friends')
        .doc(model.uid)
        .delete()
        .then((value) {
      Utils.myToast(title: 'Declined !');
    }).catchError((error) {
      Utils.myToast(title: 'Check Your Internet !');
      Get.offAll(() => HomeScreen());
    });

    await _instance
        .collection('users')
        .doc(model.uid)
        .collection('my_friends')
        .doc(_userModel.value?.uid)
        .delete()
        .then((value) {
      Get.offAll(() => HomeScreen());
    });

    _isLoading(false);
  }

  void sendMessage(
      {required String receiverId,
      required String dateTime,
      required String text,
      String? image,
      required String profileImage}) {
    ChatModel chatModel = ChatModel(
        text: text,
        dateTime: dateTime,
        senderId: _userModel.value?.uid,
        reciverId: receiverId,
        profileImage: profileImage);
    _instance
        .collection('users')
        .doc(_userModel.value?.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(chatModel.toMap())
        .then((value) {})
        .catchError((error) {
      print('there is an error when send message !');
    });

    _instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(_userModel.value?.uid)
        .collection('message')
        .add(chatModel.toMap())
        .then((value) {
      print('message Send Success !');
    }).catchError((error) {
      print('there is an error when send message !');
    });
    _listChatModel.add(chatModel);
  }

  Future getMessages({required String receiverId}) async {
    print('getMessages');
    await _instance
        .collection('users')
        .doc(_userModel.value?.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((event) {
          print('sfsdfsfsfsf');
      _listChatModel.clear();
      event.docs.forEach((element) {
        _listChatModel.add(ChatModel.fromJson(element.data()));
      });
      print('Get Messages Success State');
    }); 
  }
  
  Future<void> getAllGroups()async{

    print('yes yes ');
    // _isLoading(true);

    _instance.collection('groups').get().then((value){
      value.docs.forEach((element){
        _allGroups..clear()..add(GroupModel.fromJson(element.data()));
      });

    }).catchError((error){
      print('there is an error when get all groups !! $error');

    });

    _isLoading(false);


  }

  ///////////////////////////////////////////////Admins/////////////////////////////////////////////////

  Future<void> createGroup({required String groupName, required int groupNumber, required String groupDescription}) async {
    _isLoading(true);

    try {
      // Create a new document in the 'groups' collection
      DocumentReference groupRef = await _instance.collection('groups').add({
        'group_name': groupName,
        'group_number': groupNumber,
        'group_description': groupDescription,
      });

      // Now update the document with the generated UID (Document ID)
      await groupRef.update({
        'uid': groupRef.id,  // Set the 'uid' field to the generated document ID
      });

      Utils.myToast(title: 'Create group success');
    } catch (error) {
      print('There was an error creating the group: $error');
    }

    _isLoading(false);
  }
  
  Future<void> sendRequestToJoinGroup({required String uid})async{
    _isLoading(true);
    _instance.collection('groups').doc(uid).collection('requests').doc(_userModel.value?.uid).set({
      'user_name':_userModel.value?.userName,
      'user_major':_userModel.value?.major,
      'uid':_userModel.value?.uid,
      'user_email':_userModel.value?.email,
      'user_phone':_userModel.value?.phoneNumber,
      'profile_image':_userModel.value?.profileImage,
      'status':0,
    }).then((value){Utils.myToast(title: 'Request Send Success');}).catchError((error){
      print('there is an error when join group ! $error');
    });
    _isLoading(false);

  }
  
  Future<void> getAllRequests({required String uid})async{
    _allRequests.clear();
    _isLoading(true);
    await _instance.collection('groups').doc(uid).collection('requests').get().then((value){
      value.docs.forEach((element){
        if(element['status']==0){
          _allRequests..clear()..add(RequestModel.fromJson(element.data()));
        }
      });

    }).catchError((error){
      print('there is an error when get all requests !');

    });
    _isLoading(false);
  }
  
  Future<void> acceptRequest({required String groupUid,required String userUid})async{
    _isLoading(true);
    await _instance.collection('groups') .doc(groupUid).collection('requests').doc(userUid).update({
      'status':1
    }).then((value){
      Utils.myToast(title: 'Accepted Success');
      Get.offAll(()=>const AdminScreen());
    });
    _isLoading(false);
    
  }
  
  Future<void> declineRequest({required String groupUid,required String userUid})async{
    _isLoading(true);
    await _instance.collection('groups') .doc(groupUid).collection('requests').doc(userUid).delete().then((value){
      Utils.myToast(title: 'Declined Request');
      Get.offAll(()=>const AdminScreen());
    });
    _isLoading(false);

  }
  
  Future<bool> isUserAcceptedOrNot({required String groupId})async{
    _isLoading(true);
    
   final result= await _instance.collection('groups').doc(groupId).collection('requests').doc(_userModel.value?.uid).get();
   if(result.exists){
     if(result['status']==1){
       _isLoading(false);
       return true;
     }
     else{
       _isLoading(false);

       return false;
     }
   }
   else{
     _isLoading(false);
     return false;
   }


    
  }



  Future<void> getMessagesGroup({required String uid})async{


    _isLoading(true);

    await _instance.collection('groups').doc(uid).collection('messages').orderBy('dateTime',descending: true).snapshots().listen((event){
      _allChatMessageGroup.clear();
      event.docs.forEach((element){
        _allChatMessageGroup.add(GroupChatModel.fromJson(element.data()));
      });

    });
    _isLoading(false);

  }
  Future<void>sendMessageGroup({required String uid,required String message,required String senderUid,String? image, required String profileImage})async{
    var dateTime = Timestamp.fromDate(DateTime.now());
    await _instance.collection('groups').doc(uid).collection('messages').add({
      'message':message,
      'sender_uid':senderUid,
      'date_time':dateTime,
      'profile_image':profileImage

    }).catchError((error){
      print('there is an error when send message');
    });
  }



  bool get isLoading => _isLoading.value;

  UserModel? get userModel => _userModel.value;

  List<UserModel> get allUsers => _allUsers;

  List<UserModel> get allFriendRequest => _allFriendRequest;

  List<UserModel> get allMyFriends => _myFriends;

  List<ChatModel> get listChatModel => _listChatModel;
  List<GroupModel> get allGroups=>_allGroups;

  List<GroupChatModel> get allChatGroupMessages=>_allChatMessageGroup;

  List<RequestModel> get allRequests=>_allRequests;
}
