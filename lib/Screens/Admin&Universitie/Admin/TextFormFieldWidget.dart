import 'package:flutter/material.dart';

class TextFormFields extends StatefulWidget {
  TextFormFields(
      {this.hide,
      this.hint,
      this.onsave,
      this.suffix,
      this.toChange,
      this.f,
      this.prefix,
      this.labelText,
      this.icon,
      super.key});

  TextEditingController? toChange;

  String? hint;
  String? labelText;
  bool? suffix;
  bool? prefix;
  IconData? icon;
  String? onsave;
  bool? hide;
  String? Function(String?)? f;
  @override
  State<TextFormFields> createState() => _TextFormFieldsState();
}

class _TextFormFieldsState extends State<TextFormFields> {
  bool? validation;

  String? validationreturn;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.toChange,
      obscureText: widget.hide!,
      validator: widget.f,
      onSaved: (newValue) {},
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        suffixIcon: (widget.suffix!)
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.hide = !(widget.hide!);
                  });
                },
                icon: Icon(
                    widget.hide! ? Icons.visibility_off : Icons.visibility))
            : null,
        prefixIcon: (widget.prefix!) ? Icon(widget.icon) : null,
      ),
    );
  }
}
