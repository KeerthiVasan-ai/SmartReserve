import "package:flutter/material.dart";

class BuildTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool readOnly;
  final Icon prefixIcon;
  final Function()? onTap;
  final String? errorText;

  const BuildTextForm({
    super.key,
    required this.controller,
    required this.label,
    required this.readOnly,
    required this.prefixIcon,
    this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
      child: TextFormField(
        // validator: (value){
        //   if (errorText != null) return errorText;
        //   if(value == null || value.isEmpty){
        //     return "Enter $label";
        //   }
        //   return null;
        // },
        // Use manual errorText instead of validator for explicit control
        controller: controller,
        onTap: onTap,
        autofocus: false,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon,
          errorText: errorText, // Pass error text directly
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF124076)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          labelStyle: const TextStyle(color: Color(0xFF124076)),
        ),
      ),
    );
  }
}
