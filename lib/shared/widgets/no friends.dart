import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/resources/color_manger.dart';
import '../config/resources/font_manger.dart';
import '../config/resources/style_manger.dart';

class NoFriends extends StatelessWidget {
  final String title;
  const NoFriends({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.person_outline,color: ColorManger.kPrimaryTwo,size: 150,),
        const SizedBox(
          height: 15,
        ),
        Align(
          alignment: AlignmentDirectional.center,
          child: Text(
            title,
            style: getMyMediumTextStyle(color: Colors.black,fontSize: FontSize.s20),
          ),
        ),
      ],
    );
  }
}
