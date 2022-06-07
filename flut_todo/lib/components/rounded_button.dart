
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    required this.color,
    this.textColor = Colors.white,
  }) : super(key: key);

  final String text;
  final Function() press;
  final Color? color, textColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            primary: color,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
        onPressed: press,
        child: Text(text, style: TextStyle(fontSize: 18, color: textColor)),
      ),
    );
  }
}
