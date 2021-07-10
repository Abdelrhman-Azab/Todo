import 'package:flutter/material.dart';

Widget myTextFormField(
        {required TextEditingController controller,
        required BuildContext context,
        required String label,
        required IconData icon,
        required Function()? onTap,
        required String validateMessage}) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return validateMessage;
            }
          },
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            prefixIcon: Icon(icon),
          ),
          onTap: onTap),
    );
