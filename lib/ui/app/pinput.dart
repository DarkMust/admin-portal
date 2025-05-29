import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:pinput/pinput.dart';

class AppPinput extends StatelessWidget {
  const AppPinput({Key? key, this.onCompleted, this.controller}) : super(key: key);

  final void Function(String)? onCompleted;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;

    return Pinput(
      onCompleted: onCompleted,
      controller: controller,
      autofocus: true,
      length: 6,
      showCursor: true,
      validator: (value) =>
          value!.isEmpty ? localization.pleaseEnterACode : null,
    );
  }
}
