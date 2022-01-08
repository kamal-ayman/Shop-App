// ignore_for_file: prefer_const_constructors, constant_identifier_names, sized_box_for_whitespace, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shared/styles/colors.dart';

Widget defaultTextButton({
  required var onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: defaultColor, fontWeight: FontWeight.w600),
      ),
    );

Widget defaultButton({
  required String text,
  Color color = defaultColor,
  double height = 50.0,
  bool toUpperCase = false,
  required onPressed,
}) =>
    Row(
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: onPressed,
            height: height,
            color: color,
            child: Text(
              toUpperCase ? text.toUpperCase() : text,
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  onSubmit,
  onChange,
  onTap,
  required validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  suffixPressed,
  icon,
  bool obscureText = false,
  textInputAction = TextInputAction.next
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
          icon: Icon(suffix),
          onPressed: suffixPressed,
        )
            : null,
        icon: icon,
        border: OutlineInputBorder(),
      ),
        textInputAction: textInputAction,
    );

Widget buildArticleItem(article, context) =>
    InkWell(
      onTap: () {
        // navigatorTo(context, WebViewScreen(article['url']));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage('${article["urlToImage"]}'),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Container(
                height: 120.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${article["title"]}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1,
                      ),
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

Widget myDivider() =>
    Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
        end: 20.0,
      ),
      child: Container(
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget articleBuilder(list, context, {isSearch = false}) =>
    Conditional.single(
      context: context,
      conditionBuilder: (BuildContext context) => list.length > 0,
      widgetBuilder: (BuildContext context) =>
          ListView.separated(
            itemBuilder: (BuildContext context, int index) =>
                buildArticleItem(list[index], context),
            separatorBuilder: (BuildContext context, int index) => myDivider(),
            physics: BouncingScrollPhysics(),
            itemCount: list.length,
          ),
      fallbackBuilder: (context) =>
      isSearch ? Container() : Center(child: CircularProgressIndicator()),
    );

void navigatorTo(context, widget) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigatorAndFinish(context, widget, {bool until = true}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (Route<dynamic> route) => until,
    );


Future<bool?> ToastShow({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0
    );

enum ToastStates { SUCCESS, ERROR, WARNING }

chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}