// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/layout/shop/cubit/cubit.dart';
import 'package:shop_app/layout/shop/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

class ChangePasswordScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordAgainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        if (cubit.userModel != null) {
          var model = ShopCubit.get(context).userModel!.data;
          nameController.text = model.name;
          emailController.text = model.email;
          phoneController.text = model.phone;
        }
        var formKey = GlobalKey<FormState>();
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(children: [
                  defaultFormField(
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'password must not be empty';
                        }
                        return null;
                      },
                      label: 'Password',
                      prefix: Icons.lock,
                      textInputAction: TextInputAction.next),
                  SizedBox(height: 20),
                  defaultFormField(
                      controller: passwordAgainController,
                      type: TextInputType.visiblePassword,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'password must not be empty';
                        }
                        return null;
                      },
                      label: 'Password Again',
                      prefix: Icons.lock,
                      textInputAction: TextInputAction.done),
                  SizedBox(height: 30,),
                  defaultButton(
                    text: 'update password',
                    onPressed: () {
                      if (formKey.currentState!.validate()){
                        if (passwordController.text == passwordAgainController.text){
                          cubit.updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                          );
                          ToastShow(text: 'Done Changing Profile', state: ToastStates.SUCCESS);
                          Navigator.pop(context);
                        }
                        else {
                          ToastShow(text: 'Password not correct', state: ToastStates.ERROR);
                        }
                      }

                    },
                    toUpperCase: true,
                  ),

                ],),
              ),
            ),
          ),
        );
      },
    );
  }
}
