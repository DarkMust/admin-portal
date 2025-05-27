import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/ui/app/pinput.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PinLockScreen extends StatelessWidget {
  const PinLockScreen({
    Key? key,
    required this.onPinEntered,
    required this.onCancel,
  }) : super(key: key);

  final Function(String) onPinEntered;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  MdiIcons.lock,
                  size: 24.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(width: 12.0),
                Text(
                  localization.appLocked,
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            AppPinput(
              onCompleted: onPinEntered,
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: onCancel,
              child: Text(localization.cancel),
            ),
          ],
        ),
      ),
    );
  }
} 