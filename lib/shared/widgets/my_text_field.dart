import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/resources/color_manger.dart';
import '../config/resources/padding_manger.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget prefixIcon;
  final bool enabled;
  const MyTextField({super.key,required this.controller,required this.labelText,required this.prefixIcon,this.enabled=true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(
              PaddingManger.kPadding),
          color: ColorManger.grey2
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: TextFormField(
        enabled: enabled,
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: prefixIcon,
            border: InputBorder.none


        ),
      ),
    );
  }
}
