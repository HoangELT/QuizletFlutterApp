import 'package:flutter/material.dart';
import 'package:quizletapp/enums/text_style_enum.dart';

class CustomText extends StatelessWidget {
  final String text;
  TextStyleEnum type;
  TextStyle? style;

  CustomText({
    required this.text,
    this.style,
    this.type = TextStyleEnum.normal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getStyle(),
      textDirection: TextDirection.ltr,
    );
  }

  // function
  TextStyle getStyle() {
    late TextStyle myTextStyle;
    if (type == TextStyleEnum.normal) {
      myTextStyle = const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );
    } else if (type == TextStyleEnum.large) {
      myTextStyle = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );
    } else if (type == TextStyleEnum.xl) {
      myTextStyle = const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      );
    }
    else {
      myTextStyle = const TextStyle(
        color: Colors.white,
        fontSize: 16,
      );
    }
    return (style == null) ? myTextStyle : myTextStyle.merge(style);
  }
}
