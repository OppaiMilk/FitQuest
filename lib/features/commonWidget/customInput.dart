import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomInput extends StatefulWidget {
  final String inputName;
  final String hintText;
  final String inputType;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool readOnly;
  final Function(String?)? onChanged;

  const CustomInput({
    super.key,
    required this.inputName,
    this.hintText = "",
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.inputType = "text",
    this.onChanged,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _hidePassword = false;

  @override
  void initState() {
    super.initState();
    _hidePassword = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showCalanderView() async {
      DateTime? _picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1924),
          lastDate: DateTime(3024));
      if (_picked != null) {
        setState(() {
          widget.controller.text = "${_picked.day}/${_picked.month}/${_picked.year}";
        });
      }
    }

    Widget? showSuffixIcon() {
      final isPasswordField = widget.inputType == "password";
      if (isPasswordField) {
        return IconButton(
          icon: Icon(_hidePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
        );
      } else if (widget.inputType == "date") {
        return const Icon(Icons.calendar_month);
      }
      return null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.inputName,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          style: Theme.of(context).textTheme.labelSmall,
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _hidePassword,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIconColor: Colors.white,
            suffixIcon: showSuffixIcon(),
          ),
          onTap: () {
            widget.inputType == "date" ? showCalanderView() : null;
          },
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
