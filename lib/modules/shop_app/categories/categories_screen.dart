// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/layout/shop/cubit/cubit.dart';
import 'package:shop_app/layout/shop/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => cubit.categoriesModel != null,
          widgetBuilder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            reverse: false,
            itemBuilder: (context, index) =>
                buildCatItem(cubit.categoriesModel!.data.data[index]),
            separatorBuilder: (context, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Container(
                color: Colors.grey[300],
                height: 1,
              ),
            ),
            itemCount: cubit.categoriesModel!.data.data.length,
          ),
          fallbackBuilder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildCatItem(DataModel model) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image(
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                image: NetworkImage(model.image.toString()),
              ),
            ),
            Expanded(
                child: Text(
              model.name.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            )),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.navigate_next_rounded)),
          ],
        ),
      );
}
