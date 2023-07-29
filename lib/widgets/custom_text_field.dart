import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String _label;
  final TextEditingController _controller;

  const CustomTextField(this._label, this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.25.sw,
      height: 140.h,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(30.h),
          label: Text(_label),
        ),
      ),
    );
  }
}
