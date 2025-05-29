// Dart imports:
import 'dart:async';
import 'dart:html' as html;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/redux/auth/auth_actions.dart';

// ignore: unused_import
import 'package:invoiceninja_flutter/utils/web_stub.dart'
    if (dart.library.html) 'package:invoiceninja_flutter/utils/web.dart';

class WebSessionTimeout extends StatefulWidget {
  const WebSessionTimeout({this.child, this.onUserActivity});

  final Widget? child;
  final VoidCallback? onUserActivity;

  @override
  _WebSessionTimeoutState createState() => _WebSessionTimeoutState();
}

class _WebSessionTimeoutState extends State<WebSessionTimeout> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      return;
    }

    // Add event listeners for user activity on web
    html.window.document.addEventListener('mousemove', _handleUserActivity);
    html.window.document.addEventListener('mousedown', _handleUserActivity);
    html.window.document.addEventListener('keydown', _handleUserActivity);
    html.window.document.addEventListener('scroll', _handleUserActivity);

    _timer = Timer.periodic(
      Duration(minutes: 1),
      (Timer timer) {
        final store = StoreProvider.of<AppState>(context);
        final state = store.state;
        final sessionTimeout = state.company.sessionTimeout;

        if (sessionTimeout == 0) {
          return;
        }

        final sessionLength = DateTime.now().millisecondsSinceEpoch -
            state.userCompanyState.lastUpdated;

        if (sessionLength > sessionTimeout) {
          store.dispatch(UserLogout());
        }
      },
    );
  }

  void _handleUserActivity(html.Event event) {
    // Call the provided callback to reset the pin lock timer
    print('WebSessionTimeout: User activity detected - ${event.type}');
    widget.onUserActivity?.call();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;

    // Remove event listeners
    if (kIsWeb) {
      html.window.document.removeEventListener('mousemove', _handleUserActivity);
      html.window.document.removeEventListener('mousedown', _handleUserActivity);
      html.window.document.removeEventListener('keydown', _handleUserActivity);
      html.window.document.removeEventListener('scroll', _handleUserActivity);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
