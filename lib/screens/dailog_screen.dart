
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FutureDialog {
  
  static Future<void> showFutureDialogue(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0),
            ),
            content: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 10),
                Text('Search option and live channel broadcasting will be available soon',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 25.0,
                ),
                Container(
                    width: double.maxFinite,
                    height: 50.0,
                    child: new Builder(builder: (BuildContext context) {
                      return new RaisedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text("OK")],
                          ),
                          textColor: Colors.white,
                          color: Colors.black54,
                          shape:  new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)));
                    }))
              ],
            )),
          );
        });
  }

  static Future<bool> showToast(){
    return Fluttertoast.showToast(
                      msg: "Search option and live broadcasting will be available soon",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      textColor: Colors.black.withOpacity(0.8),
                      fontSize: 16.0);
  }
}
