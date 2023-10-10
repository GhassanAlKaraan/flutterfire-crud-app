import 'package:firestore_crud_demo/service/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Utils {
  static void snackTopSuccess(context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(message: message),
    );
  }

  static void snackTopInfo(context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(message: message),
    );
  }

  static void snackTopError(context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
          message:
              // "Something went wrong. Please check your credentials and try again",
              "Error: $message"),
    );
  }

  static void showAlertDialog(context, VoidCallback callback, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("Cancel", style: kTxt0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("OK", style: kTxt0),
                  onPressed: () {
                    callback();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
