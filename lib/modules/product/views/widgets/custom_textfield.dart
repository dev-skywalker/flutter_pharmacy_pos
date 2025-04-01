import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool isNumber;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      this.validator,
      required this.isRequired,
      required this.isNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label),
            isRequired
                ? const Text(
                    " *",
                    style: TextStyle(color: Colors.red),
                  )
                : const Text("")
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        TextFormField(
          keyboardType: isNumber ? TextInputType.number : null,
          inputFormatters:
              isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
              //isDense: true,
              border: const OutlineInputBorder(),
              hintText: hint),
        ),
      ],
    );
  }
}
