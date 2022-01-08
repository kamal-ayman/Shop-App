// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/layout/shop/cubit/cubit.dart';
import 'package:shop_app/layout/shop/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

import 'change_password.dart';
import 'change_profile.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        if (cubit.userModel != null) {
          var model = ShopCubit.get(context).userModel!.data;
        }
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => cubit.userModel != null,
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
          widgetBuilder: (context) => Column(
            children: [
              if (state is ShopLoadingUserDataState)
                LinearProgressIndicator(),
              FlatButton(
                onPressed: () {
                  navigatorAndFinish(context, ChangeProfileScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://scontent-hbe1-1.xx.fbcdn.net/v/t39.30808-6/261646561_1514138212274881_4459059845555015064_n.jpg?_nc_cat=110&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=XI0pULe1_8cAX_55bSV&tn=CdBW1bqEEmpWwEnt&_nc_ht=scontent-hbe1-1.xx&oh=00_AT8qrUX4tmWkx_HEUWbcgTi1Md5o42UIBzXp4eeIxcpt3Q&oe=61CFFB30'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cubit.userModel!.data.name.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            cubit.userModel!.data.email.toString(),
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Column(
                children: [
                  FlatButton(
                    onPressed: () {
                      navigatorAndFinish(context, ChangeProfileScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                color: Colors.black87,
                                imageUrl:
                                "https://icons.veryicon.com/png/o/miscellaneous/black-yellow-linear-simple-icon/edit-218.png",
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Edit Profile',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.navigate_next_rounded),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      navigatorAndFinish(context, ChangePasswordScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                color: Colors.black87,
                                imageUrl:
                                "https://icon-library.com/images/reset-password-icon/reset-password-icon-29.jpg",
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Change Password',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.navigate_next_rounded),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                color: Colors.black87,
                                imageUrl:
                                    "https://icons.veryicon.com/png/o/object/material_design_icons/logout-14.png",
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Log Out',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.navigate_next_rounded),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
