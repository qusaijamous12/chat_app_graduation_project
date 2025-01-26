import 'package:chat_app/shared/config/resources/font_manger.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:chat_app/shared/widgets/my_button.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller/user_controller.dart';
import '../../shared/config/resources/color_manger.dart';
import '../../shared/config/utils/utils.dart';
import '../register_screen/register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userController = Get.find<UserController>(tag: 'user_controller');

  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(PaddingManger.kPadding),
          child: Column(
            children: [
              Image.asset('assets/images/logo_remmove.png'),
              Text(
                'Sign in',
                style: getMyMediumTextStyle(color: ColorManger.kPrimaryTwo,
                    fontSize: FontSize.s20 * 1.5),
              ),
              const SizedBox(
                height: PaddingManger.kPadding,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(
                        PaddingManger.kPadding),
                    color: ColorManger.grey2
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: InputBorder.none


                  ),
                ),
              ),
              const SizedBox(
                height: PaddingManger.kPadding,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(
                        PaddingManger.kPadding),
                    color: ColorManger.grey2
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: TextFormField(
                  obscureText: isObsecure,
                  keyboardType: TextInputType.emailAddress,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isObsecure = !isObsecure;
                            });
                          },
                          child: Icon(
                              isObsecure ? Icons.visibility_off_outlined : Icons
                                  .visibility_outlined)),
                      border: InputBorder.none


                  ),
                ),
              ),
              const SizedBox(
                height: PaddingManger.kPadding * 1.5,
              ),

              Obx(()=>ConditionalBuilder(
                condition: _userController.isLoading,
                builder: (context)=>Center(child: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,)),
                fallback: (context)=> MyButton(title: 'Login', onTap: ()async{

                  if(_emailController.text.isNotEmpty&&_passwordController.text.isNotEmpty){
                    await _userController.login(email: _emailController.text, password: _passwordController.text);

                  }
                  else{
                    Utils.myToast(title: 'All Field Requierd');
                  }
                }, btnColor: ColorManger.kPrimaryTwo, textColor: Colors.white),
              )),


              const SizedBox(
                height: PaddingManger.kPadding / 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have an Account?',
                    style: getMyMediumTextStyle(color: Colors.black),
                  ),
                  TextButton(onPressed: () {
                    Get.offAll(() => const RegisterScreen());
                  }, child: Text(
                    'Register',
                    style: getMyMediumTextStyle(color: ColorManger.kPrimaryTwo),
                  ))
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
