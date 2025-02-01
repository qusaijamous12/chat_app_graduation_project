import 'package:chat_app/view/admin_screen/admin_screen.dart';
import 'package:chat_app/view/home_screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../../model/chat_model.dart';
import '../../model/user_model.dart';
import '../../shared/config/utils/utils.dart';
import '../../view/login_screen/login_screen.dart';

class UserController extends GetxController{
  final _isLoading=RxBool(false);
  final _userModel=Rxn<UserModel>();

  final _allUsers=RxList<UserModel>([]);
  final _allFriendRequest=RxList<UserModel>([]);
  final _myFriends=RxList<UserModel>([]);
  final _listChatModel=RxList<ChatModel>([]);



  Future<void> login({required String email,required String password})async{
    _isLoading(true);
    try{
      final result=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      if(result.user!=null){
        await getUserData(uid: result.user!.uid);

        Utils.myToast(title: 'Login Success');
        if(_userModel.value?.status==0){
          Get.offAll(()=>const HomeScreen());
        }
        if(_userModel.value?.status==1){
          Get.offAll(()=>const AdminScreen());
        }




      }else{
        Utils.myToast(title: 'Login Failed');
      }




    }
    catch(e){
      print('there is an error in login $e');
      Utils.myToast(title: 'Login Failed');
    }
    _isLoading(false);
  }

  Future<void> createAccount({required String email,required String name,required String password,required String phoneNumber,int status=1})async{
    _isLoading(true);
    try{
      final auth=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if(auth.user!=null){
        await saveDataToFireStore(email: email, name: name, phone: phoneNumber, uid: auth.user!.uid,status:status);

        Get.offAll(()=>const LoginScreen());
      }else{
        Utils.myToast(title: 'Register Failed');
      }


    }catch(e){
      print('there is an error $e');
      Utils.myToast(title: 'Register Failed');
    }
    _isLoading(false);

  }

  Future<void> saveDataToFireStore({required String email,required String name,required String phone,required String uid,dynamic status})async{
    try{
      final store=await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email':email,
        'user_name':name,
        'mobile_number':phone,
        'uid':uid,
        'status':status
      });
      Utils.myToast(title: 'Register Success');

    }
    catch(e){
      print('There is an error in saveDataToFireStore method ');
    }


  }

  Future<void> getUserData({required String uid})async{
    try{
      final result=  await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if(result.data()!=null){
        _userModel(UserModel.fromJson(result.data()!));
      }
      else{
        Utils.myToast(title: 'Please Check your network!');
      }
    }
    catch(e){
      print('there is an error in get user Data $e');
    }



  }

  Future<void> updateUserData({required String name,required String phone})async{
    _isLoading(true);
    await FirebaseFirestore.instance.collection('users').doc(_userModel.value?.uid).update({
      'mobile_number':phone,
      'user_name':name
    }).then((value)async{
      await getUserData(uid: _userModel.value!.uid!);
      Utils.myToast(title: 'Update Success');
    }).catchError((error){
      print('there is an error in update $error');
    });
    _isLoading(false);
  }

  Future<void> getAllUsers()async{
    _allUsers.clear();
    _isLoading(true);
    await FirebaseFirestore.instance.collection('users').get().then((value){
      value.docs.forEach((element){
        if(element['status']==0){
          if(element['uid']!=_userModel.value?.uid){
            _allUsers.add(UserModel.fromJson(element.data()));

          }
        }
      });

    }).catchError((error){
      print('there is an error when get all users');
    });
    // _isLoading(false);
  }

  Future<void> getMyFriends()async{
    _myFriends.clear();
    _isLoading(true);
    await FirebaseFirestore.instance.collection('users').doc(_userModel.value?.uid).collection('my_friends').get().then((value){
      value.docs.forEach((element){
        if(element['status']==1){
          _myFriends.add(UserModel.fromJson(element.data()));
        }
      });


    }).catchError((error){
      print('Check Your Internet');
    });
    
   
    _isLoading(false);

  }

  Future<void> deleteUser({required String uid})async{
    _isLoading(true);
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await userRef.delete();

      print("User with UID: $uid has been deleted.");
      Utils.myToast(title: 'Deleted Success');
      Get.offAll(()=>const AdminScreen());
    } catch (e) {
      print("Error deleting user: $e");
    }
    _isLoading(false);
  }

  // Future<void> addFriend({required String userName,required String uid,required String emailAddress})async{
  //
  //
  //
  //
  //   _isLoading(true);
  //   await FirebaseFirestore.instance.collection('users').doc(_userModel.value?.uid).collection('my_friends').add({
  //     'user_name':userName,
  //     'email_address':emailAddress,
  //     'uid':uid,
  //     'status':0//Not Accept the friend yet !!!
  //   }).then((value){
  //     Utils.myToast(title: 'Friend Request Send Success');
  //
  //   }).catchError((error){
  //     Utils.myToast(title: 'Check Your Internet !');
  //   });
  //
  //   await FirebaseFirestore.instance.collection('users').doc(uid).collection('my_friends').add({
  //     'user_name':_userModel.value?.userName,
  //     'email_address':_userModel.value?.email,
  //     'uid':_userModel.value?.uid,
  //     'status':0
  //
  //   });
  //
  //   _isLoading(false);
  // }

  Future<void> addFriend({required String userName, required String uid, required String emailAddress}) async {
    _isLoading(true);

    bool requestExists = await _checkIfRequestExists(uid);

    if (requestExists) {
      Utils.myToast(title: 'Friend request already sent!');
      _isLoading(false);
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(_userModel.value?.uid).collection('my_friends').doc(uid).set({
        'user_name': userName,
        'email': emailAddress,
        'uid': uid,
        'status': 0, // Not accepted yet
      });

      // Save the friend request for the other user
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('my_friends').doc(_userModel.value?.uid).set({
        'user_name': _userModel.value?.userName,
        'email': _userModel.value?.email,
        'uid': _userModel.value?.uid,
        'status': 0, // Not accepted yet
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
      var snapshot = await FirebaseFirestore.instance
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

  Future<void> getAllFriendsRequest()async{
    _allFriendRequest.clear();
    _isLoading(true);
    await FirebaseFirestore.instance.collection('users').doc(_userModel.value?.uid).collection('my_friends').get().then((value){
      value.docs.forEach((element){
        if(element['status']==0){
          _allFriendRequest.add(UserModel.fromJson(element.data()));
        }
      });
      _isLoading(false);

    }).catchError((error){
      print('there is an error when get all friends requests !!');
    });

  }
  
  Future<void> acceptFriendsRequest(UserModel model)async{
    _isLoading(true);
    await FirebaseFirestore.instance.collection('users').doc(_userModel.value?.uid).collection('my_friends').doc(model.uid).update({
      'status':1
    }).then((value){
      Utils.myToast(title: 'Accepted Successfully');
    }).catchError((error){
      Utils.myToast(title: 'Check Your Internet !');  Get.offAll(()=>HomeScreen());

    });

    await FirebaseFirestore.instance.collection('users').doc(model.uid).collection('my_friends').doc(_userModel.value?.uid).update({
      'status':1
    }).then((Value){
      Get.offAll(()=>HomeScreen());
    });

    _isLoading(false);

  }

  Future<void> declineFriendsRequest(UserModel model)async{
    _isLoading(true);
    await FirebaseFirestore.instance.collection('users').doc(_userModel.value?.uid).collection('my_friends').doc(model.uid).delete().then((value){
      Utils.myToast(title: 'Declined !');

    }).catchError((error){
      Utils.myToast(title: 'Check Your Internet !');
      Get.offAll(()=>HomeScreen());
    });

    await FirebaseFirestore.instance.collection('users').doc(model.uid).collection('my_friends').doc(_userModel.value?.uid).delete().then((value){
      Get.offAll(()=>HomeScreen());
    });


    _isLoading(false);

  }


  void sendMessage({required String receiverId, required String dateTime, required String text, String ?image}){
    ChatModel chatModel = ChatModel(
      text: text,
      dateTime: dateTime,
      senderId: _userModel.value?.uid,
      reciverId: receiverId,

    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(_userModel.value?.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(chatModel.toMap()).then((value) {
      // _listChatModel.add(ChatModel(text: text,dateTime: dateTime,senderId: uid,reciverId: receiverId));
      print('message send Success !');


    }).catchError((error){
      print('there is an error when send message !');


    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(_userModel.value?.uid)
        .collection('message')
        .add(chatModel.toMap()).then((value) {
      print('message Send Success !');

    }).catchError((error){

      print('there is an error when send message !');
    });


  }


  Future getMessages({required String receiverId})async{
    await FirebaseFirestore.instance.
    collection('users').
    doc(_userModel.value?.uid).
    collection('chats').
    doc(receiverId).
    collection('message').orderBy('dateTime').
    snapshots()
        .listen((event) {
      _listChatModel.clear();
      event.docs.forEach((element) {
        _listChatModel.add(ChatModel.fromJson(element.data()));


      });
      print('Get Messages Success State ');

    });
  }



  bool get isLoading=>_isLoading.value;
  UserModel ?get userModel=>_userModel.value;
  List<UserModel> get allUsers=>_allUsers;
  List<UserModel> get allFriendRequest=>_allFriendRequest;
  List<UserModel> get allMyFriends=>_myFriends;
  List<ChatModel> get listChatModel =>_listChatModel;



}