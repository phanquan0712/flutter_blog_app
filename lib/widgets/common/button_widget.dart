import 'package:blog_app/constants/dimension_constants.dart';
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key, required this.title, required this.onPressed, this.color});

  final String? title;
  final Function()? onPressed;
  final Color? color;


  @override
  Widget build(BuildContext context) {
    if(color != null) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kMediumPadding),
            color: color,
          ),
          child: Text(title!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      );
    } 
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kMediumPadding),
          gradient: Gradients.defaultGradientBackground,
        ),
        child: Text(title!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}