import 'package:flutter/material.dart';
import 'package:todoapp/constant.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: kDefaultPadding, bottom: kDefaultPadding),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontFamily: 'Salsa', fontSize: 32),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
