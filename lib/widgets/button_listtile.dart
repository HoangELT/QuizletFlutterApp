import 'package:flutter/material.dart';

class ButtonListTile extends StatelessWidget {
  final Widget? title;
  final Icon? icon;
  final double borderRadius;
  final Function()? onTap;
  ButtonListTile({
    this.title,
    this.icon,
    this.borderRadius = 16,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          color: Color.fromARGB(160, 127, 144, 155),
        ),
        child: ListTile(
          leading: (icon != null) ? icon : null,
          title: title,
        ),
      ),
    );
  }
}
