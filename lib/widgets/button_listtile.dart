import 'package:flutter/material.dart';

class ButtonListTile extends StatelessWidget {
  final Widget? title;
  final Icon? icon;
  final Icon? iconRight;
  final double borderRadius;
  final BoxDecoration? boxDecoration;
  final EdgeInsets? padding;
  final Function()? onTap;
  ButtonListTile({
    this.title,
    this.icon,
    this.iconRight,
    this.boxDecoration,
    this.padding,
    this.borderRadius = 16,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: (boxDecoration == null)
            ? BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
                color: Color.fromARGB(160, 127, 144, 155),
              )
            : boxDecoration,
        child: ListTile(
          leading: icon,
          title: title,
          trailing: iconRight,
        ),
      ),
    );
  }
}
