// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/layout/shop/cubit/cubit.dart';
import 'package:shop_app/layout/shop/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/shop_app/products_item/products_item.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status) {
            ToastShow(text: state.model.message, state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              cubit.homeModel != null && cubit.categoriesModel != null,
          widgetBuilder: (context) =>
              ProductsBuilder(context, cubit.homeModel, cubit.categoriesModel),
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget ProductsBuilder(
          context, HomeModel? model, CategoriesModel? categories_model) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: CarouselSlider(
                items: model?.data.banners
                    .map(
                      (e) => Image(
                        image: NetworkImage(e.image.toString()),
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        reverse: false,
                        itemBuilder: (context, index) => buildCategoryItem(
                            categories_model!.data.data[index]),
                        separatorBuilder: (context, index) => SizedBox(
                              width: 5,
                            ),
                        itemCount: categories_model!.data.data.length),
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.45,
                children: List.generate(
                    model!.data.products.length,
                    (index) =>
                        buildGridProducts(model.data.products[index], context)),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(
              model.image.toString(),
            ),
            width: 100,
            height: 100,
          ),
          Container(
            width: 100,
            color: Colors.black.withOpacity(.7),
            child: Text(
              model.name.toString(),
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white, overflow: TextOverflow.ellipsis),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  Widget buildGridProducts(ProductsModel model, context) {
    var cubit = ShopCubit.get(context);
    return InkWell(
      onTap: () {
        cubit.getProductItemData(model.id);
        navigatorAndFinish(context, ProductsItemScreen());
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Image(
                        image: NetworkImage('${model.image}'),
                        width: double.infinity,
                        height: 160,
                      ),
                      if (model.discount > 0)
                        Container(
                            color: Colors.red,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                'Discount'.toUpperCase(),
                                style:
                                    TextStyle(color: Colors.white, fontSize: 8),
                              ),
                            )),
                    ],
                  ),
                  Text(
                    model.name.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.4,
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${model.price.round()} L.E.',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: defaultColor,
                        ),
                      ),
                      Text(
                        model.discount > 0
                            ? '%${100 - ((model.price / model.oldPrice) * 100).round()}'
                            : '',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        model.oldPrice > model.price
                            ? '${model.oldPrice} L.E.'
                            : '',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 15,
              backgroundColor:
                  cubit.favorite[model.id] == false ? Colors.grey : Colors.red,
              child: IconButton(
                splashRadius: 0.1,
                onPressed: () {
                  cubit.changeFavorites(model.id);
                },
                icon: Icon(
                  Icons.favorite_outline_rounded,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
