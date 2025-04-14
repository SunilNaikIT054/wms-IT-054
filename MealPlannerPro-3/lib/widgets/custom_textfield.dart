import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool isPassword;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? minLines;
  final bool readOnly;
  final bool autofocus;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? initialValue;
  final bool enabled;
  
  const CustomTextField({
    Key? key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.isPassword = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.initialValue,
    this.enabled = true,
  }) : super(key: key);
  
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.controller.text.isEmpty) {
      widget.controller.text = widget.initialValue!;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      style: TextStyle(
        color: widget.readOnly ? Colors.grey[700] : null,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffix,
        filled: true,
        fillColor: widget.readOnly ? Colors.grey[100] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
