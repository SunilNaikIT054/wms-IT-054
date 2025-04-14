import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;
  final bool withText;
  
  const LoadingIndicator({
    Key? key,
    this.message,
    this.color,
    this.size = 40.0,
    this.withText = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: color ?? Theme.of(context).primaryColor,
            strokeWidth: 3,
          ),
        ),
        if (withText) ...[
          const SizedBox(height: 16),
          Text(
            message ?? 'Loading...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
