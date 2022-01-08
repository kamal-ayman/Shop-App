// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/layout/shop/cubit/cubit.dart';
import 'package:shop_app/layout/shop/cubit/states.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/modules/shop_app/products_item/products_item.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => cubit.favoritesModel != null,
          widgetBuilder: (context) {
            if (cubit.favoritesModel!.data.data.isEmpty) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please add new favorites ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              reverse: false,
              itemBuilder: (context, index) =>
                  buildFavView(context, cubit.favoritesModel, index, cubit),
              separatorBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
              ),
              itemCount: cubit.favoritesModel!.data.data.length,
            );
          },
          fallbackBuilder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }

  Widget buildFavView(
      BuildContext context, FavoritesModel? model, int index, ShopCubit cubit) {
    return InkWell(
      onTap: () {
        cubit.getProductItemData(model!.data.data[index].product.id);
        navigatorAndFinish(context, ProductsItemScreen());
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Image(
                          image: NetworkImage(
                              model!.data.data[index].product.image.toString()),
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (model.data.data[index].product.discount > 0)
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
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.data.data[index].product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1.4,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              model.data.data[index].product.price
                                  .round()
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: defaultColor,
                              ),
                            ),
                            Text(
                              model.data.data[index].product.discount! > 0
                                  ? '%${100 - ((model.data.data[index].product.price! / model.data.data[index].product.oldPrice!) * 100).round()}'
                                  : '',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              model.data.data[index].product.oldPrice! >
                                      model.data.data[index].product.price!
                                  ? '${model.data.data[index].product.oldPrice!} L.E.'
                                  : '',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    ShopCubit.get(context).favorite[model
                                                .data.data[index].product.id] ==
                                            false
                                        ? Colors.grey
                                        : Colors.red,
                                child: IconButton(
                                  onPressed: () {
                                    ShopCubit.get(context).changeFavorites(
                                        model.data.data[index].product.id);
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
