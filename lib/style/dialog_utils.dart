import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoadingDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 40,
              width: 40,
              child: Center(
            child: CircularProgressIndicator(),
          )),
        );
      },
    );
  }

  static void showMessageDialog({required BuildContext context, required String message,required void Function() onPress}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          content: Text(message,),
          actions: [
            TextButton(onPressed: onPress, child: Text("Ok"))
          ],
        );
      },
    );
  }

  static void showConfirmationDialog({
    required BuildContext context,
    required String message,
    required void Function() onPositivePress,
    required void Function() onNegativePress,

  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          content: Text(message,),
          actions: [
            TextButton(

              onPressed: onPositivePress, child: Text("yes"),),
            TextButton(
              onPressed: onNegativePress, child: Text("no"),),
          ],
        );
      },
    );
  }

}
