import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/config/resources/font_manger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFriend = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 150,
              padding: EdgeInsetsDirectional.all(PaddingManger.kPadding),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(PaddingManger.kPadding),
                      bottomEnd: Radius.circular(PaddingManger.kPadding)),
                  color: ColorManger.kPrimaryTwo),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Messages',
                        style: getMyBoldTextStyle(
                            color: Colors.white, fontSize: FontSize.s20),
                      ),
                      Container(
                          padding: EdgeInsetsDirectional.all(
                              PaddingManger.kPadding / 4),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            Icons.search,
                            color: ColorManger.kPrimaryTwo,
                          ))
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isFriend = true;
                            });
                          },
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 7, horizontal: 10),
                            decoration: BoxDecoration(
                                color: isFriend
                                    ? Colors.white
                                    : ColorManger.kPrimaryTwo,
                                borderRadius: BorderRadiusDirectional.circular(
                                    PaddingManger.kPadding)),
                            child: Text(
                              'Friend',
                              style: getMyRegulerTextStyle(
                                  color: isFriend
                                      ? ColorManger.kPrimaryTwo
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: PaddingManger.kPadding / 2,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isFriend = false;
                            });
                          },
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 7, horizontal: 10),
                            decoration: BoxDecoration(
                                color: isFriend
                                    ? ColorManger.kPrimaryTwo
                                    : Colors.white,
                                borderRadius: BorderRadiusDirectional.circular(
                                    PaddingManger.kPadding)),
                            child: Text(
                              'Groups',
                              style: getMyMediumTextStyle(
                                  color: isFriend
                                      ? Colors.white
                                      : ColorManger.kPrimaryTwo),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: PaddingManger.kPadding / 2,
            ),
            if(isFriend)...[
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context,index)=>buildUserChat(),
                    separatorBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.symmetric(horizontal: PaddingManger.kPadding),
                      child: Divider(
                        color: ColorManger.grey2,
                        height: 1,

                      ),
                    ),
                    itemCount: 5),
              )
            ]else...[
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context,index)=>buildGroupChat(),
                    separatorBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.symmetric(horizontal: PaddingManger.kPadding),
                      child: Divider(
                        color: ColorManger.grey2,
                        height: 1,

                      ),
                    ),
                    itemCount: 5),
              )

            ]

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
          elevation: 0,
          backgroundColor: ColorManger.kPrimaryTwo,
      child: Icon(Icons.person_outline,color: Colors.white,)
      ),
    );
  }

  Widget buildUserChat() => Padding(
        padding: const EdgeInsets.all(PaddingManger.kPadding),
        child: Row(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                  'https://static.vecteezy.com/system/resources/thumbnails/051/948/045/small_2x/a-smiling-man-with-glasses-wearing-a-blue-sweater-poses-warmly-against-a-white-background-free-photo.jpeg'),
            ),
            const SizedBox(
              width: PaddingManger.kPadding / 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qusai Jamous',
                  style: getMyRegulerTextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: PaddingManger.kPadding / 4,
                ),
                Text(
                  'Hello !!',
                  style: getMyRegulerTextStyle(color: ColorManger.grey),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: ColorManger.kPrimaryTwo,
                  child: Text(
                    '1',
                    style: getMyRegulerTextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: PaddingManger.kPadding / 5,
                ),
                Text(
                  '5:45 am',
                  style: getMyRegulerTextStyle(color: ColorManger.grey),
                )
              ],
            )
          ],
        ),
      );
  Widget buildGroupChat() => Padding(
    padding: const EdgeInsets.all(PaddingManger.kPadding),
    child: Row(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: NetworkImage(
              'https://st2.depositphotos.com/3591429/8813/i/450/depositphotos_88134246-stock-photo-group-of-diversity-people.jpg'),
        ),
        const SizedBox(
          width: PaddingManger.kPadding / 2,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jobs Group',
              style: getMyRegulerTextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: PaddingManger.kPadding / 4,
            ),
            Text(
              'Hello !!',
              style: getMyRegulerTextStyle(color: ColorManger.grey),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: ColorManger.kPrimaryTwo,
              child: Text(
                '1',
                style: getMyRegulerTextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: PaddingManger.kPadding / 5,
            ),
            Text(
              '5:45 am',
              style: getMyRegulerTextStyle(color: ColorManger.grey),
            )
          ],
        )
      ],
    ),
  );
}
