import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/ui/app/pinput.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class PinSetupDialog extends StatefulWidget {
  const PinSetupDialog({
    Key? key,
    this.currentPin,
  }) : super(key: key);

  final String? currentPin;

  @override
  _PinSetupDialogState createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<PinSetupDialog> {
  String? _firstPin;
  String? _secondPin;
  bool _isConfirming = false;
  final _pinController = TextEditingController();

  void _onPinEntered(String pin) {
    if (!_isConfirming) {
      setState(() {
        _firstPin = pin;
        _isConfirming = true;
      });
      _pinController.clear();
    } else {
      if (pin == _firstPin) {
        Navigator.of(context).pop(pin);
      } else {
        setState(() {
          _isConfirming = false;
          _firstPin = null;
        });
        _pinController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalization.of(context)!.pinsDoNotMatch),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;

    return AlertDialog(
      title: Text(_isConfirming
          ? localization.confirmPin
          : widget.currentPin != null
              ? localization.enterNewPin
              : localization.enterPin),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppPinput(
            controller: _pinController,
            onCompleted: _onPinEntered,
          ),
          if (_isConfirming)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(localization.enterPinAgain),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localization.cancel),
        ),
      ],
    );
  }
} 