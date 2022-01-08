// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/layout/shop/cubit/cubit.dart';
import 'package:shop_app/layout/shop/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/shop_app/products_item/products_item.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  cubit.searchModel = null;
                },
                icon: Icon(Icons.arrow_back)),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  defaultFormField(
                    controller: searchController,
                    type: TextInputType.text,
                    validate: (String? val) {
                      if (val!.isEmpty) {
                        return 'enter text to search';
                      }
                      return null;
                    },
                    onChange: (String? val) {
                      cubit.getSearchData(val!);
                    },
                    label: 'Search',
                    prefix: Icons.search,
                    textInputAction: TextInputAction.search,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (state is ShopLoadingSearchDataState)
                    LinearProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Conditional.single(
                      context: context,
                      conditionBuilder: (context) => cubit.searchModel != null,
                      fallbackBuilder: (context) {
                        return Center(
                          child: null,
                        );
                      },
                      widgetBuilder: (context) => ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => buildSearchView(
                              context, cubit.searchModel, index, cubit),
                          separatorBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: Container(
                                  color: Colors.grey[300],
                                  height: 1,
                                ),
                              ),
                          itemCount: cubit.searchModel!.data.data.length),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget test(context) => Container();

  Widget buildSearchView(
      BuildContext context, SearchModel? model, int index, ShopCubit cubit) {
    return InkWell(
      onTap: () {
        cubit.getProductItemData(model!.data.data[index].id);
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
                              model!.data.data[index].image.toString()),
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
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
                          model.data.data[index].name,
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
                              model.data.data[index].price.round().toString(),
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: defaultColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    ShopCubit.get(context).favorite[
                                                model.data.data[index].id] ==
                                            false
                                        ? Colors.grey
                                        : Colors.red,
                                child: IconButton(
                                  onPressed: () {
                                    ShopCubit.get(context).changeFavorites(
                                        model.data.data[index].id);
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
