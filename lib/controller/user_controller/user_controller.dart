import 'package:chat_app/view/admin_screen/admin_screen.dart';
import 'package:chat_app/view/home_screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../model/user_model.dart';
import '../../shared/config/utils/utils.dart';
import '../../view/login_screen/login_screen.dart';

class UserController extends GetxController{
  final _isLoading=RxBool(false);
  final _userModel=Rxn<UserModel>();
  // final _bookingModel=RxList<BookingModel>([]);
  // final _acceptedBookingModel=RxList<BookingModel>([]);
  final _allUsers=RxList<UserModel>([]);


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
          _allUsers.add(UserModel.fromJson(element.data()));
        }
      });

    }).catchError((error){
      print('there is an error when get all users');
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


  bool get isLoading=>_isLoading.value;
  UserModel ?get userModel=>_userModel.value;
  List<UserModel> get allUsers=>_allUsers;


}