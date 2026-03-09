import 'package:flutter/material.dart';

class LocaleController extends ValueNotifier<Locale> {
  LocaleController() : super(const Locale('sq'));

  void setLocale(Locale locale) {
    value = locale;
  }
}

class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    required LocaleController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope not found in widget tree.');
    return scope!.notifier!;
  }
}
