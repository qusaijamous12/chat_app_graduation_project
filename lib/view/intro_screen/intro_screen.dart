import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:chat_app/shared/widgets/my_button.dart';
import 'package:chat_app/view/login_screen/login_screen.dart';
import 'package:chat_app/view/register_screen/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(PaddingManger.kPadding),
        child: Column(
          children: [
            const Spacer(),

            Center(
              child: Image.asset('assets/images/logo_remmove.png'),
            ),
            const Spacer(),
            MyButton(title: 'Login', onTap: (){
              Get.offAll(()=>const LoginScreen());
            }, btnColor: ColorManger.kPrimaryTwo, textColor: Colors.white),
            const SizedBox(
              height: PaddingManger.kPadding/2,
            ),
            MyButton(title: 'Register', onTap: (){
              Get.offAll(()=>const RegisterScreen());
            }, btnColor: Colors.white, textColor:ColorManger.kPrimaryTwo),

          ],
        ),
      ),
    );
  }
}
