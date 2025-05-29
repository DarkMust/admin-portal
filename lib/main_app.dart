// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:invoiceninja_flutter/ui/app/important_message_banner.dart';
import 'package:invoiceninja_flutter/ui/app/window_manager.dart';
import 'package:invoiceninja_flutter/ui/auth/pin_lock_screen.dart';
import 'package:invoiceninja_flutter/ui/bank_account/edit/bank_account_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/purchase_order/purchase_order_email_vm.dart';
import 'package:invoiceninja_flutter/ui/purchase_order/purchase_order_pdf_vm.dart';
import 'package:invoiceninja_flutter/ui/settings/e_invoice_settings_vm.dart';
import 'package:invoiceninja_flutter/ui/settings/payment_settings_vm.dart';
import 'package:local_auth/local_auth.dart';
import 'package:redux/redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/redux/company/company_selectors.dart';
import 'package:invoiceninja_flutter/redux/ui/pref_state.dart';
import 'package:invoiceninja_flutter/ui/app/app_builder.dart';
import 'package:invoiceninja_flutter/ui/app/main_screen.dart';
import 'package:invoiceninja_flutter/ui/app/screen_imports.dart';
import 'package:invoiceninja_flutter/ui/app/web_session_timeout.dart';
import 'package:invoiceninja_flutter/ui/app/web_socket_refresh.dart';
import 'package:invoiceninja_flutter/ui/auth/init_screen.dart';
import 'package:invoiceninja_flutter/ui/auth/lock_screen.dart';
import 'package:invoiceninja_flutter/ui/auth/login_vm.dart';
import 'package:invoiceninja_flutter/ui/client/client_pdf_vm.dart';
import 'package:invoiceninja_flutter/ui/company_gateway/company_gateway_screen.dart';
import 'package:invoiceninja_flutter/ui/credit/credit_email_vm.dart';
import 'package:invoiceninja_flutter/ui/credit/credit_pdf_vm.dart';
import 'package:invoiceninja_flutter/ui/credit/credit_screen.dart';
import 'package:invoiceninja_flutter/ui/credit/credit_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/credit/edit/credit_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/credit/view/credit_view_vm.dart';
import 'package:invoiceninja_flutter/ui/design/design_screen.dart';
import 'package:invoiceninja_flutter/ui/design/design_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/design/edit/design_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/design/view/design_view_vm.dart';
import 'package:invoiceninja_flutter/ui/expense_category/edit/expense_category_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/expense_category/expense_category_screen.dart';
import 'package:invoiceninja_flutter/ui/expense_category/expense_category_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/expense_category/view/expense_category_view_vm.dart';
import 'package:invoiceninja_flutter/ui/invoice/invoice_pdf_vm.dart';
import 'package:invoiceninja_flutter/ui/payment/refund/payment_refund_vm.dart';
import 'package:invoiceninja_flutter/ui/payment_term/edit/payment_term_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/payment_term/payment_term_screen.dart';
import 'package:invoiceninja_flutter/ui/payment_term/payment_term_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/payment_term/view/payment_term_view_vm.dart';
import 'package:invoiceninja_flutter/ui/quote/quote_pdf_vm.dart';
import 'package:invoiceninja_flutter/ui/recurring_expense/edit/recurring_expense_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/recurring_expense/recurring_expense_screen.dart';
import 'package:invoiceninja_flutter/ui/recurring_expense/recurring_expense_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/recurring_expense/view/recurring_expense_view_vm.dart';
import 'package:invoiceninja_flutter/ui/recurring_invoice/edit/recurring_invoice_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/recurring_invoice/recurring_invoice_pdf_vm.dart';
import 'package:invoiceninja_flutter/ui/recurring_invoice/recurring_invoice_screen.dart';
import 'package:invoiceninja_flutter/ui/recurring_invoice/recurring_invoice_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/recurring_invoice/view/recurring_invoice_view_vm.dart';
import 'package:invoiceninja_flutter/ui/reports/reports_screen.dart';
import 'package:invoiceninja_flutter/ui/reports/reports_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/settings/account_management_vm.dart';
import 'package:invoiceninja_flutter/ui/settings/device_settings_vm.dart';
import 'package:invoiceninja_flutter/ui/settings/expense_settings_vm.dart';
import 'package:invoiceninja_flutter/ui/settings/settings_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/settings/task_settings_vm.dart';
import 'package:invoiceninja_flutter/ui/settings/tax_settings_vm.dart';
import 'package:invoiceninja_flutter/ui/subscription/edit/subscription_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/subscription/subscription_screen.dart';
import 'package:invoiceninja_flutter/ui/subscription/subscription_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/subscription/view/subscription_view_vm.dart';
import 'package:invoiceninja_flutter/ui/task_status/edit/task_status_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/task_status/task_status_screen.dart';
import 'package:invoiceninja_flutter/ui/task_status/task_status_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/task_status/view/task_status_view_vm.dart';
import 'package:invoiceninja_flutter/ui/tax_rate/tax_rate_screen.dart';
import 'package:invoiceninja_flutter/ui/token/edit/token_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/token/token_screen.dart';
import 'package:invoiceninja_flutter/ui/token/token_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/token/view/token_view_vm.dart';
import 'package:invoiceninja_flutter/ui/user/user_screen.dart';
import 'package:invoiceninja_flutter/ui/webhook/edit/webhook_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/webhook/view/webhook_view_vm.dart';
import 'package:invoiceninja_flutter/ui/webhook/webhook_screen.dart';
import 'package:invoiceninja_flutter/ui/webhook/webhook_screen_vm.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';

// STARTER: import - do not remove comment
import 'package:invoiceninja_flutter/ui/schedule/schedule_screen.dart';
import 'package:invoiceninja_flutter/ui/schedule/edit/schedule_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/schedule/view/schedule_view_vm.dart';
import 'package:invoiceninja_flutter/ui/schedule/schedule_screen_vm.dart';

import 'package:invoiceninja_flutter/ui/transaction_rule/transaction_rule_screen.dart';
import 'package:invoiceninja_flutter/ui/transaction_rule/edit/transaction_rule_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/transaction_rule/view/transaction_rule_view_vm.dart';
import 'package:invoiceninja_flutter/ui/transaction_rule/transaction_rule_screen_vm.dart';

import 'package:invoiceninja_flutter/ui/transaction/transaction_screen.dart';
import 'package:invoiceninja_flutter/ui/transaction/edit/transaction_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/transaction/view/transaction_view_vm.dart';
import 'package:invoiceninja_flutter/ui/transaction/transaction_screen_vm.dart';

import 'package:invoiceninja_flutter/ui/bank_account/bank_account_screen.dart';
import 'package:invoiceninja_flutter/ui/bank_account/view/bank_account_view_vm.dart';
import 'package:invoiceninja_flutter/ui/bank_account/bank_account_screen_vm.dart';
import 'package:invoiceninja_flutter/ui/purchase_order/purchase_order_screen.dart';
import 'package:invoiceninja_flutter/ui/purchase_order/edit/purchase_order_edit_vm.dart';
import 'package:invoiceninja_flutter/ui/purchase_order/view/purchase_order_view_vm.dart';
import 'package:invoiceninja_flutter/ui/purchase_order/purchase_order_screen_vm.dart';

import 'package:invoiceninja_flutter/utils/web_stub.dart'
    if (dart.library.html) 'package:invoiceninja_flutter/utils/web.dart';

final navigatorKey = GlobalKey<NavigatorState>();

extension NavigatorKeyUtils on GlobalKey<NavigatorState> {
  AppLocalization? get localization {
    return AppLocalization.of(currentContext!);
  }

  Store<AppState> get store {
    return StoreProvider.of<AppState>(currentContext!);
  }
}

class InvoiceNinjaApp extends StatefulWidget {
  const InvoiceNinjaApp({Key? key, this.store}) : super(key: key);
  final Store<AppState>? store;

  @override
  InvoiceNinjaAppState createState() => InvoiceNinjaAppState();
}

class InvoiceNinjaAppState extends State<InvoiceNinjaApp> with WidgetsBindingObserver {
  bool _authenticated = false;
  Timer? _pinLockTimer;
  DateTime? _lastUserActivity;
  bool _isPinLockVisible = false;

  // Method to be called by child widgets to signal user activity
  void userActivityDetected() {
    print('InvoiceNinjaAppState: userActivityDetected called.');
    _resetPinLockTimer();
  }

  Future<Null> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await LocalAuthentication().authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: false,
        ),
      );
    } catch (e) {
      print(e);
    }

    if (authenticated) {
      setState(() => _authenticated = true);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    if (kIsWeb) {
      WebUtils.warnChanges(widget.store);
    }

    Timer.periodic(Duration(milliseconds: kMillisecondsToTimerRefreshData),
        (_) {
      final store = widget.store!;
      final state = store.state;

      if (!state.authState.isAuthenticated) {
        return;
      }

      if (!state.uiState.hasRecentActivity) {
        return;
      }

      final millisecondsSinceLastUpdate =
          DateTime.now().millisecondsSinceEpoch -
              state.userCompanyState.lastUpdated;

      if (millisecondsSinceLastUpdate > kMillisecondsToTimerRefreshData) {
        store.dispatch(RefreshData());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pinLockTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPinLock();
    }
  }

  void _resetPinLockTimer() {
    print('_resetPinLockTimer called. Updating _lastUserActivity.');
    _pinLockTimer?.cancel();
    _lastUserActivity = DateTime.now();

    if (mounted) {
      if (widget.store?.state.prefState.pinLockEnabled ?? false) {
        final timeout = widget.store?.state.prefState.pinLockTimeout ?? 0;
        print('Setting up pin lock timer with timeout: ${timeout} minutes');
        _pinLockTimer = Timer.periodic(
          Duration(seconds: 1),
          (timer) {
            final now = DateTime.now();
            if (now.difference(_lastUserActivity!).inSeconds >= timeout * 60) {
              print('Pin lock timeout reached. Showing pin lock screen.');
              _showPinLockScreen();
            }
          },
        );
      } else {
        print('Pin lock is not enabled in settings');
      }
    }
  }

  void _checkPinLock() {
    if (mounted) {
      final store = StoreProvider.of<AppState>(context);
      if (store.state.prefState.pinLockEnabled) {
        final now = DateTime.now();
        final timeout = store.state.prefState.pinLockTimeout * 60;
        if (now.difference(_lastUserActivity!).inSeconds >= timeout) {
          _showPinLockScreen();
        }
      }
    }
  }

  void _showPinLockScreen() {
    if (mounted && !_isPinLockVisible) {
      print('Attempting to show pin lock screen by updating state.');
      setState(() {
        _isPinLockVisible = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize pin lock timer after dependencies are available
    _resetPinLockTimer();
    
    final state = widget.store!.state;
    if (state.prefState.requireAuthentication && !_authenticated) {
      _authenticate();
    }

    final brightness = MediaQuery.of(context).platformBrightness;
    final enableDarkModeSystem = brightness == Brightness.dark;
    final store = widget.store!;
    final prefState = store.state.prefState;

    if (prefState.enableDarkModeSystem != enableDarkModeSystem) {
      store.dispatch(
          UpdateUserPreferences(enableDarkModeSystem: enableDarkModeSystem));
    }
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    /*
    print('## generateRoute: ${settings.name}, isInitial: ${settings.isInitialRoute}');
    print('## pathname: ${html5.window.location.pathname} hash: ${html5.window.location.hash}, href: ${html5.window.location.href}');
    html5.window.history.replaceState(null, settings.name, '/#${settings.name}');
    widget.store.dispatch(UpdateCurrentRoute(settings.name));
    */
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute<dynamic>(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute<dynamic>(builder: (_) => MainScreen());
    }
  }

  void _initTimeago() {
    final locale = localeSelector(widget.store!.state, twoLetter: true);
    if (locale == 'ar') {
      timeago.setLocaleMessages('ar', timeago.ArMessages());
      timeago.setLocaleMessages('ar_short', timeago.ArMessages());
    } else if (locale == 'ca') {
      timeago.setLocaleMessages('ca', timeago.CaMessages());
      timeago.setLocaleMessages('ca_short', timeago.CaMessages());
    } else if (locale == 'cs') {
      timeago.setLocaleMessages('cs', timeago.CsMessages());
      timeago.setLocaleMessages('cs_short', timeago.CsMessages());
    } else if (locale == 'da') {
      timeago.setLocaleMessages('da', timeago.DaMessages());
      timeago.setLocaleMessages('da_short', timeago.DaMessages());
    } else if (locale == 'de') {
      timeago.setLocaleMessages('de', timeago.DeMessages());
      timeago.setLocaleMessages('de_short', timeago.DeMessages());
    } else if (locale == 'en') {
      timeago.setLocaleMessages('en', timeago.EnMessages());
      timeago.setLocaleMessages('en_short', timeago.EnMessages());
    } else if (locale == 'es') {
      timeago.setLocaleMessages('es', timeago.EsMessages());
      timeago.setLocaleMessages('es_short', timeago.EsMessages());
    } else if (locale == 'fa') {
      timeago.setLocaleMessages('fa', timeago.FaMessages());
    } else if (locale == 'fr') {
      timeago.setLocaleMessages('fr', timeago.FrMessages());
      timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
    } else if (locale == 'hu') {
      timeago.setLocaleMessages('hu', timeago.HuMessages());
      timeago.setLocaleMessages('hu_short', timeago.HuShortMessages());
    } else if (locale == 'it') {
      timeago.setLocaleMessages('it', timeago.ItMessages());
      timeago.setLocaleMessages('it_short', timeago.ItShortMessages());
    } else if (locale == 'ja') {
      timeago.setLocaleMessages('ja', timeago.JaMessages());
    } else if (locale == 'nb') {
      timeago.setLocaleMessages('nb', timeago.NbNoMessages());
      timeago.setLocaleMessages('nb_short', timeago.NbNoShortMessages());
    } else if (locale == 'nl') {
      timeago.setLocaleMessages('nl', timeago.NlMessages());
      timeago.setLocaleMessages('nl_short', timeago.NlShortMessages());
    } else if (locale == 'pl') {
      timeago.setLocaleMessages('pl', timeago.PlMessages());
    } else if (locale == 'pt') {
      timeago.setLocaleMessages('pt', timeago.PtBrMessages());
      timeago.setLocaleMessages('pt_short', timeago.PtBrShortMessages());
    } else if (locale == 'ro') {
      timeago.setLocaleMessages('ro', timeago.RoMessages());
      timeago.setLocaleMessages('ro_short', timeago.RoShortMessages());
    } else if (locale == 'ru') {
      timeago.setLocaleMessages('ru', timeago.RuMessages());
      timeago.setLocaleMessages('ru_short', timeago.RuShortMessages());
    } else if (locale == 'sv') {
      timeago.setLocaleMessages('sv', timeago.SvMessages());
      timeago.setLocaleMessages('sv_short', timeago.SvShortMessages());
    } else if (locale == 'th') {
      timeago.setLocaleMessages('th', timeago.ThMessages());
      timeago.setLocaleMessages('th_short', timeago.ThShortMessages());
    } else if (locale == 'zh') {
      timeago.setLocaleMessages('zh', timeago.ZhMessages());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.store == null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: StoreProvider<AppState>(
        store: widget.store!,
        child: Builder(
          builder: (context) {
            final store = StoreProvider.of<AppState>(context);
            final state = store.state;
            final hasAccentColor = state.hasAccentColor;
            final accentColor = state.accentColor;
            const fontFamily = kIsWeb ? 'Roboto' : null;
            final pageTransitionsTheme = PageTransitionsTheme(builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            });

            Intl.defaultLocale = localeSelector(state);
            final locale = AppLocalization.createLocale(localeSelector(state));
            _initTimeago();

            final textButtonTheme = TextButton.styleFrom(
              minimumSize: Size(88, 36),
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
              ),
            );

            final outlinedButtonTheme = OutlinedButton.styleFrom(
              foregroundColor: state.prefState.enableDarkMode ? Colors.white : Colors.black87,
            );

            Widget appContent = StyledToast(
              locale: locale,
              duration: Duration(seconds: 4),
              backgroundColor: state.prefState.enableDarkMode ? Colors.white : Colors.black,
              textStyle: TextStyle(
                color: state.prefState.enableDarkMode ? Colors.black87 : Colors.white,
              ),
              child: WebSessionTimeout(
                onUserActivity: () => userActivityDetected(),
                child: WebSocketRefresh(
                  companyId: state.company.id,
                  child: WindowManager(
                    child: MaterialApp(
                      builder: (BuildContext context, Widget? child) {
                        final MediaQueryData data = MediaQuery.of(context);
                        return MediaQuery(
                          data: data.copyWith(
                            textScaler: TextScaler.linear(state.prefState.textScaleFactor),
                            alwaysUse24HourFormat: state.company.settings.enableMilitaryTime ?? false,
                          ),
                          child: child!,
                        );
                      },
                      scrollBehavior: state.prefState.enableTouchEvents && state.prefState.isDesktop
                          ? MyCustomScrollBehavior()
                          : null,
                      navigatorKey: navigatorKey,
                      supportedLocales: kLanguages
                          .map((String locale) => AppLocalization.createLocale(locale))
                          .toList(),
                      debugShowCheckedModeBanner: false,
                      navigatorObservers: [
                        SentryNavigatorObserver(),
                      ],
                      localizationsDelegates: [
                        const AppLocalizationsDelegate(),
                        GlobalCupertinoLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate
                      ],
                      home: state.prefState.requireAuthentication && !_authenticated
                          ? LockScreen(onAuthenticatePressed: _authenticate)
                          : InitScreen(),
                      locale: locale,
                      theme: state.prefState.enableDarkMode
                          ? ThemeData(
                              useMaterial3: false,
                              tooltipTheme: TooltipThemeData(
                                waitDuration: Duration(milliseconds: 500),
                              ),
                              pageTransitionsTheme: pageTransitionsTheme,
                              indicatorColor: accentColor,
                              textSelectionTheme: TextSelectionThemeData(
                                selectionHandleColor: accentColor,
                              ),
                              fontFamily: fontFamily,
                              canvasColor: Colors.black,
                              cardColor: const Color(0xFF1B1C1E),
                              primaryColorDark: Colors.black,
                              textButtonTheme: TextButtonThemeData(style: textButtonTheme),
                              outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonTheme),
                              colorScheme: ColorScheme.dark().copyWith(
                                secondary: accentColor,
                                primary: accentColor,
                                background: Colors.black,
                              ),
                              bottomAppBarTheme: BottomAppBarTheme(color: const Color(0xFF1B1C1E)),
                            )
                          : ThemeData(
                              useMaterial3: false,
                              tooltipTheme: TooltipThemeData(
                                waitDuration: Duration(milliseconds: 500),
                              ),
                              pageTransitionsTheme: pageTransitionsTheme,
                              primaryColor: accentColor,
                              indicatorColor: accentColor,
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: accentColor,
                              ),
                              fontFamily: fontFamily,
                              canvasColor: Colors.white,
                              cardColor: Colors.white,
                              primaryColorDark: hasAccentColor ? accentColor : const Color(0xFF0D5D91),
                              primaryColorLight: hasAccentColor ? accentColor : const Color(0xFF5dabf4),
                              scaffoldBackgroundColor: const Color(0xFFF3F4F6),
                              tabBarTheme: TabBarTheme(
                                labelColor: hasAccentColor ? Colors.white : Colors.black,
                                unselectedLabelColor: hasAccentColor
                                    ? Colors.white.withOpacity(.65)
                                    : Colors.black.withOpacity(.65),
                              ),
                              iconTheme: IconThemeData(
                                color: hasAccentColor ? null : accentColor,
                              ),
                              appBarTheme: AppBarTheme(
                                color: hasAccentColor ? accentColor : Colors.white,
                                iconTheme: IconThemeData(
                                  color: hasAccentColor ? Colors.white : accentColor,
                                ),
                                titleTextStyle: TextStyle(
                                  fontSize: 20,
                                  color: hasAccentColor ? Colors.white : Colors.black,
                                ),
                              ),
                              textButtonTheme: TextButtonThemeData(style: textButtonTheme),
                              outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonTheme),
                              colorScheme: ColorScheme.fromSwatch().copyWith(
                                secondary: accentColor,
                                background: Colors.white,
                              ),
                              bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
                            ),
                      title: kAppName,
                      onGenerateRoute: isMobile(context) ? null : generateRoute,
                      routes: isMobile(context) ? {
                        LoginScreen.route: (context) => LoginScreen(),
                        MainScreen.route: (context) => MainScreen(),
                      } : {},
                    ),
                  ),
                ),
              ),
            );

            if (_isPinLockVisible) {
              appContent = Material(
                color: Colors.black.withOpacity(0.5),
                child: Builder(
                  builder: (context) {
                    // Access the MaterialApp context from the builder
                    final theme = Theme.of(context);
                    final localization = AppLocalization.of(context)!;

                    return Stack(
                      children: [
                        appContent,
                        PinLockScreen(
                          onPinEntered: (pin) {
                            print('PinLockScreen: PIN entered: $pin');
                            final store = widget.store;
                            print('PinLockScreen: Stored PIN: ${store?.state.prefState.pinCode}');
                            if (pin == store?.state.prefState.pinCode) {
                              print('PinLockScreen: Correct PIN entered. Hiding pin lock screen by updating state.');
                              setState(() {
                                _isPinLockVisible = false;
                              });
                              _resetPinLockTimer();
                            } else {
                              print('PinLockScreen: Incorrect PIN entered.');
                              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalization.of(navigatorKey.currentContext!)!.incorrectPin,
                                    textDirection: ui.TextDirection.ltr,
                                  ),
                                ),
                              );
                            }
                          },
                          onCancel: () {
                            print('PinLockScreen: Cancel button pressed. Hiding pin lock screen.');
                            setState(() {
                              _isPinLockVisible = false;
                            });
                            _resetPinLockTimer();
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
            }

            return appContent;
          },
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
