import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    required Key key,
    required this.title,
  }) : super(key: key);

  String title;

  @override
  State<StatefulWidget> createState() {
    return _CustomButtonState();
  }
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff6494aa),
            borderRadius: BorderRadius.circular(13.0),
            border: Border.all(width: 1.0, color: const Color(0xff707070)),
          ),
        ),
        Align(
          alignment: const Alignment(0.0, 0.037),
          child: SizedBox(
            // width: 460.0,
            // height: 23.0,
            child: Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Helvetica Neue',
                // fontSize: 20,
                color: Color(0xffffffff),
              ),
              textAlign: TextAlign.center,
              // softWrap: false,
            ),
          ),
        ),
      ],
    );
  }
}
