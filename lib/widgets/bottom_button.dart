import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  VoidCallback onNext;
  num padingHorzation;
  String text;

  NextButton(
      {@required this.onNext,
      @required this.padingHorzation,
      @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:10,bottom: 20),
      child: new Center(
        child: RaisedButton(
            shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: onNext,
            color: Colors.blue[400],
            child: Padding(
                padding:
                EdgeInsets.fromLTRB(padingHorzation, 20, padingHorzation, 20),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      color: Colors.white),
                ))),
      )
    );
  }
}
