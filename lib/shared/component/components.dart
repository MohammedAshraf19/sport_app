import 'package:flutter/material.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required String hintText,
  IconData? prefixIcon,
  IconData? suffixIcon,
  required TextInputType keyboard,
  bool security = false,
  required Function validator,
  Function? suffixPressed,
}) {
  return TextFormField(
    style: const TextStyle(
      color: Colors.black,
    ),
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.blue,
      )),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.red,
      )),
      suffixIcon: IconButton(
        onPressed: () {
          suffixPressed!();
        },
        icon: Icon(
          suffixIcon,
          color: Colors.blue,
        ),
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: Colors.blue,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.only(),
        borderSide: BorderSide(color: Colors.grey),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
    ),
    obscureText: security,
    controller: controller,
    cursorColor: Colors.grey,
    validator: (value) => validator(value),
    keyboardType: keyboard,
  );
}

void showSnackbar(context, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: message,
    backgroundColor: Theme.of(context).primaryColor,
    duration: const Duration(seconds: 5),
    action: SnackBarAction(label: "ok", onPressed: (() {})),
  ));
}
