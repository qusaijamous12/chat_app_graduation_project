import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/widgets/my_text_field.dart';
import 'package:chat_app/shared/widgets/no%20friends.dart';
import 'package:chat_app/view/home_screen/user_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../shared/config/resources/color_manger.dart';
import '../../shared/config/resources/style_manger.dart';
import '../../shared/config/utils/utils.dart';
import '../../shared/widgets/my_app_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _userController = Get.find<UserController>(tag: 'user_controller');
  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _userController.getAllUsers();
      filteredUsers = _userController.allUsers; // Initialize the filtered list
    });

    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = _userController.allUsers
          .where((user) {
        return user.userName?.toLowerCase().contains(query) ?? false ||
            user.major!.toLowerCase().contains(query);
      })
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.hideKeyboard(context);
      },
      onVerticalDragDown: (details) {
        Utils.hideKeyboard(context);
      },
      child: Obx(
            () => LoadingOverlay(
          isLoading: _userController.isLoading,
          progressIndicator: CircularProgressIndicator(
            color: ColorManger.kPrimaryTwo,
          ),
          child: Scaffold(
            appBar: myAppBar(title: 'Search Screen'),
            body: Padding(
              padding: const EdgeInsets.all(PaddingManger.kPadding),
              child: Column(
                children: [
                  MyTextField(
                    controller: _searchController,
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (filteredUsers.isNotEmpty) ...[
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) =>
                            buildAllUser(filteredUsers[index]),
                        separatorBuilder: (context, index) =>
                        const SizedBox(
                          height: 30,
                        ),
                        itemCount: filteredUsers.length,
                      ),
                    )
                  ] else ...[
                    const Spacer(),
                    NoFriends(title: 'No Users Found!'),
                    const Spacer(),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAllUser(UserModel model) => GestureDetector(
    onTap: () {
      Get.to(()=> UserDetailsScreen(model: model,isUser: false,));
    },
    behavior: HitTestBehavior.opaque,
    child: Row(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: NetworkImage(model.profileImage??''),
        ),
        const SizedBox(
          width: PaddingManger.kPadding / 2,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.userName?.capitalizeFirst ?? '',
              style: getMyRegulerTextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              model.major ?? "",
              style: getMyRegulerTextStyle(color: ColorManger.grey),
            ),
          ],
        ),
        const Spacer(),
        Icon(
          Icons.arrow_forward_ios,
          color: ColorManger.kPrimaryTwo,
        )
      ],
    ),
  );
}

