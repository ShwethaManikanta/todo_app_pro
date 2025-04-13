import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String id;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: ValueKey(id),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
