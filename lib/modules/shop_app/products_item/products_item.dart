// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/layout/shop/cubit/cubit.dart';
import 'package:shop_app/layout/shop/cubit/states.dart';
import 'package:shop_app/models/product_item_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ProductsItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Conditional.single(
            context: context,
            conditionBuilder: (context) => cubit.productItemModel != null,
            widgetBuilder: (context) =>
                ItemBuilder(context, cubit.productItemModel, cubit),
            fallbackBuilder: (context) =>
                Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget ItemBuilder(context, ProductItemModel? model, ShopCubit cubit) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                      color: Colors.white,
                      child: CarouselSlider(
                        items: model!.data.images
                            .map(
                              (e) => Image(
                                image: NetworkImage(e.toString()),
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                            height: 250.0,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            viewportFraction: 1,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(seconds: 1),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            scrollDirection: Axis.horizontal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: cubit.favorite[model.data.id] == false
                            ? Colors.grey
                            : Colors.red,
                        child: IconButton(
                          splashRadius: 0.1,
                          onPressed: () {
                            cubit.changeFavorites(model.data.id);
                          },
                          icon: Icon(
                            Icons.favorite_outline_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (model.data.discount > 0)
                  Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          'Discount'.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    model.data.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${model.data.price.round()} L.E.',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: defaultColor,
                        ),
                      ),
                      Text(
                        model.data.discount > 0
                            ? '%${100 - ((model.data.price / model.data.oldPrice) * 100).round()}'
                            : '',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        model.data.oldPrice > model.data.price
                            ? '${model.data.oldPrice} L.E.'
                            : '',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                  myDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'description:',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 19,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        model.data.description,
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
