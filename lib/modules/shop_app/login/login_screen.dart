// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/layout/shop/layout.dart';
import 'package:shop_app/modules/shop_app/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            print(state.loginModel.status);
            if (state.loginModel.status) {
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!.token;
                navigatorAndFinish(context, ShopLayout(), until: false);
              });
            } else {
              ToastShow(
                  text: state.loginModel.message.toString(),
                  state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          var cubit = ShopLoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Text(
                          'login now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String? val) {
                              if (val!.isEmpty) {
                                return 'please enter your email address';
                              }
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: passController,
                            type: TextInputType.visiblePassword,
                            suffix: cubit.suffix,
                            validate: (String? val) {
                              if (val!.isEmpty) {
                                return 'password is to short';
                              }
                            },
                            obscureText: cubit.obscureText,
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffixPressed: () {
                              cubit.obscureTextFun();
                            },
                            onSubmit: (String? val) {
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passController.text);
                              }
                            },
                            textInputAction: TextInputAction.done),
                        SizedBox(
                          height: 30,
                        ),
                        Conditional.single(
                          conditionBuilder: (context) =>
                              state is! ShopLoginLoadingState,
                          fallbackBuilder: (context) =>
                              Center(child: CircularProgressIndicator()),
                          context: context,
                          widgetBuilder: (context) => defaultButton(
                            text: 'login',
                            toUpperCase: true,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passController.text);
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            defaultTextButton(
                                onPressed: () {
                                  navigatorAndFinish(
                                    context,
                                    RegisterScreen(),
                                  );
                                },
                                text: 'Register'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
