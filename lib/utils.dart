import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tugela/constants/config.dart';
import 'package:tugela/services/sl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

export 'utils/amount_input_formatter.dart';
export 'utils/spacing.dart';

final isAndroid = defaultTargetPlatform == TargetPlatform.android;
final isiOS = defaultTargetPlatform == TargetPlatform.iOS;

// part of 'utils.dart';
final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+");
bool isValidEmail(String? email) {
  if (email == null) return false;
  return emailRegex.hasMatch(email);
}

final phoneRegex = RegExp(r'^\+?1?\d{9,15}$');
final usernameRegex = RegExp(r'([A-Za-z0-9_])+');
final nameRegex = RegExp(r'([A-Za-z])+');
final mentionRegex = RegExp("@${usernameRegex.pattern}");
final hashTagRegex = RegExp("#${usernameRegex.pattern}");
RegExp get urlRegex => RegExp(
      r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=]{1,256}\.[a-z]{1,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=%;]*)",
      // r"(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?\/[a-zA-Z0-9]{2,}|((https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{1,}(\.[a-zA-Z]{1,})(\.[a-zA-Z]{1,})?)|(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{1,}\.[a-zA-Z0-9]{1,}\.[a-zA-Z0-9]{1,}(\.[a-zA-Z0-9]{1,})?",
      // r"(?<scheme>\w+):\/\/((?<user>\w+)(\:(?<password>[^\/:]+))?@)?(?<hostname>[\w\-.]+)(:(?<port>\d+))?\/(?<request>(?<path>[^#\s\?]+)(\?(?<query>[^#\s]+))?(#(?<fragment>[^#\s]+))?)?",
    );

String? validateString({
  required String? value,
  required String name,
  int minLength = 0,
  int? maxLength,
  bool requireUppercase = false,
  bool requireLowercase = false,
  bool requireDigit = false,
  bool requireSpecial = false,
  bool denyUppercase = false,
  bool denyLowercase = false,
  bool denyDigit = false,
  bool denySpecial = false,
  RegExp? allowSpecial,
}) {
  if (value == null || value.isEmpty) return "$name is required";

  if (denyUppercase && value.contains(RegExp(r'[A-Z]'))) {
    return "$name must not contain an uppercase letter";
  }
  if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
    return "$name must contain at least one uppercase letter";
  }

  if (denyLowercase && value.contains(RegExp(r'[a-z]'))) {
    return "$name must not contain a lowercase letter";
  }
  if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
    return "$name must contain at least one lowercase letter";
  }

  if (requireDigit && !value.contains(RegExp(r'(\d)'))) {
    return "$name must contain at least one digit";
  }

  if (allowSpecial != null && !value.contains(allowSpecial)) {
  } else if (requireSpecial && !value.contains(RegExp(r'(\W)'))) {
    return "$name must contain at least one special character (*&%!@#)";
  }

  if (value.length <= minLength) {
    return "$name must be more than $minLength characters";
  }

  if (maxLength != null && value.length > maxLength) {
    return "$name cannot be more than $maxLength characters";
  }
  return null;
}

String userInitials(String? name) {
  try {
    if (name == null || (name.isEmpty)) return "";
    String result = "";
    final chunks = name.split(" ");
    if (chunks.isEmpty) return name;
    result = chunks.first.split("").first;

    if (chunks.length > 1) {
      final next = chunks[1].split("");
      if (next.isNotEmpty) result += next.first;
    }
    return result;
  } catch (e) {
    return "";
  }
}

String osNameForPlatform(TargetPlatform platform) {
  switch (platform) {
    case TargetPlatform.android:
      return "Android";
    case TargetPlatform.iOS:
      return "iOS";
    default:
      return platform.name;
  }
}

double parseAmount(Object? value, {int? factor}) {
  if (value == null) return 0.0;
  // final f = factor ?? sl.get<AppConfig>().currencyFactor;
  return (double.tryParse(value.toString()) ?? 0.0);
}

String formatAmount(
  Object? value, {
  String? symbol,
  int? factor,
  int? precision,
  NumberFormat? customFormat,
  bool isCrypto = false,
  bool truncate = true,
}) {
  final f = factor ?? sl.get<AppConfig>().currencyFactor;
  final p = precision ?? sl.get<AppConfig>().currencyPrecision;
  final s = (symbol ?? sl.get<AppConfig>().currencyCode).toUpperCase();
  final v = (double.tryParse(value.toString()) ?? 0.0);
  if (isCrypto) return "$value $symbol";
  if (value == null) return "${s}0.00";

  final currency = customFormat ??
      NumberFormat.simpleCurrency(
        decimalDigits: p,
        name: "$s${s == 'USD' || s == '\$' ? '' : ' '}",
      );
  final r = currency.format(v / f);
  if (truncate) {
    return r.endsWith('.00') ? r.replaceAll('.00', '') : r;
  } else {
    return r;
  }
}

String formatDate(DateTime? dateTime, {String? format}) {
  if (dateTime == null) return "";
  return DateFormat(
    format ?? "MMM d${dateTime.year == DateTime.now().year ? '' : ', y'}",
  ).format(dateTime);
}

String formatTime(Duration? duration) {
  if (duration == null) return "";
  List<String> text = [];
  if (duration.inMinutes > 59) {
    text.add("${duration.inHours}h");
  }
  if ((duration.inMinutes % 60) > 0) {
    text.add(
      "${duration.inMinutes % 60} min${duration.inMinutes == 1 ? '' : 's'}",
    );
  }
  if (duration.inSeconds < 60) {
    text.add("${duration.inSeconds} sec${duration.inSeconds == 1 ? '' : 's'}");
  }
  return text.join(' ');
}

String formatTimeStamp(Duration? duration) {
  if (duration == null) return "";
  int microseconds = duration.inMicroseconds;
  String sign = "";
  final negative = microseconds < 0;
  int hours = microseconds ~/ Duration.microsecondsPerHour;
  microseconds = microseconds.remainder(Duration.microsecondsPerHour);
  if (negative) {
    hours = 0 - hours;
    microseconds = 0 - microseconds;
    sign = "-";
  }
  int minutes = microseconds ~/ Duration.microsecondsPerMinute;
  microseconds = microseconds.remainder(Duration.microsecondsPerMinute);
  String minutesPadding = minutes < 10 ? "0" : "";
  int seconds = microseconds ~/ Duration.microsecondsPerSecond;
  if (seconds == 0) sign = "";
  microseconds = microseconds.remainder(Duration.microsecondsPerSecond);
  String secondsPadding = seconds < 10 ? "0" : "";
  final res = [
    if (hours > 0) "$hours",
    "$minutesPadding$minutes",
    "$secondsPadding$seconds",
  ].join(':');
  return "$sign$res";
}

String pluralFor(String? noun, {int? count = 0}) {
  if (noun == null || noun == "") return "";
  if (count == null) return "${noun}s";
  if (count == 1) {
    return noun;
  } else {
    return "${noun}s";
  }
}

TextScaler? maxTextScale(BuildContext context, double value) {
  return MediaQuery.maybeTextScalerOf(context)?.clamp(maxScaleFactor: value);
}

Future<void> copyToClipboard(String value) async {
  HapticFeedback.mediumImpact();
  await Clipboard.setData(ClipboardData(text: value));
}

Future<ClipboardData?> pasteFromClipboard() async {
  HapticFeedback.mediumImpact();
  return await Clipboard.getData(Clipboard.kTextPlain);
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}

typedef IndexedDividedBuilder<T> = Widget Function(int index, T child);

bool isFirstRoute(BuildContext context) {
  return (ModalRoute.of(context)?.isFirst ?? false);
}

NavigatorState rootNavigator(BuildContext context) {
  return Navigator.of(context, rootNavigator: true);
}

Future<T?> push<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  String? title,
  RouteSettings? settings,
  bool maintainState = true,
  bool fullscreenDialog = false,
  bool allowSnapshotting = true,
  bool rootNavigator = false,
}) {
  return Navigator.of(context, rootNavigator: rootNavigator).push<T>(
    CupertinoPageRoute(
      builder: builder,
      title: title,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      allowSnapshotting: allowSnapshotting,
    ),
  );
}

Future<T?> pushNamed<T>(
  BuildContext context,
  String routeName, {
  bool rootNavigator = false,
}) {
  return Navigator.of(
    context,
    rootNavigator: rootNavigator,
  ).pushNamed<T>(routeName);
}

Future<T?> pushReplacement<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  String? title,
  RouteSettings? settings,
  bool maintainState = true,
  bool fullscreenDialog = false,
  bool allowSnapshotting = true,
  bool rootNavigator = false,
}) {
  return Navigator.of(context, rootNavigator: rootNavigator).pushReplacement(
    CupertinoPageRoute<T>(
      builder: builder,
      title: title,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      allowSnapshotting: allowSnapshotting,
    ),
  );
}

Future<T?> pushReplacementNamed<T>(
  BuildContext context,
  String routeName, {
  bool useRootNavigator = false,
}) {
  return Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  ).pushReplacementNamed(routeName);
}

Future<T?> pushAndRemoveUntil<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  required bool Function(Route<dynamic> route) predicate,
  String? title,
  RouteSettings? settings,
  bool maintainState = true,
  bool fullscreenDialog = false,
  bool allowSnapshotting = true,
  bool rootNavigator = false,
}) {
  return Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil(
    CupertinoPageRoute<T>(
      builder: builder,
      title: title,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      allowSnapshotting: allowSnapshotting,
    ),
    predicate,
  );
}

Future<T?> pushNamedAndRemoveUntil<T>(
  BuildContext context,
  String routeName,
  bool Function(Route<dynamic> route) predicate, {
  bool rootNavigator = false,
}) {
  return Navigator.of(context, rootNavigator: rootNavigator)
      .pushNamedAndRemoveUntil<T>(routeName, predicate);
}

Iterable<Widget> divideWidgets<T>({
  required Widget divider,
  required Iterable<T> list,
  required IndexedDividedBuilder<T> builder,
}) sync* {
  if (list.isEmpty) return;

  final Iterator<T> iterator = list.iterator;
  final bool isNotEmpty = iterator.moveNext();

  T tile = iterator.current;
  int index = 0;
  while (iterator.moveNext()) {
    yield builder(index, tile);
    yield divider;
    tile = iterator.current;
    index++;
  }
  if (isNotEmpty) yield builder(index, tile);
}

Duration dateDifference(DateTime? first, DateTime? second) {
  if (first == null || second == null) return const Duration();
  return DateUtils.dateOnly(first).difference(DateUtils.dateOnly(second));
}

num percentage(double? smaller, double? larger) {
  if ((smaller ?? 0.0) == 0.0 || (larger ?? 0.0) == 0.0) return 0.0;
  final percentage = math
      .min(
        100,
        math.max(0, (smaller ?? 0) / (larger ?? 0) * 100),
      )
      .toDouble();
  return (percentage % 1 != 0)
      ? double.parse(percentage.toStringAsFixed(1))
      : percentage.toInt();
}

void handleError(dynamic e, {StackTrace? stackTrace, bool fatal = true}) {
  if (kDebugMode) {
    log(
      ">>>>>>>>> $e",
      stackTrace: stackTrace ?? StackTrace.current,
      name: 'handleError',
      time: DateTime.now(),
    );
  } else {
    try {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace ?? StackTrace.current,
        fatal: fatal,
      );
    } catch (e) {
      log(
        ">>>>>>>>> $e",
        stackTrace: stackTrace ?? StackTrace.current,
        name: 'handleError',
        time: DateTime.now(),
      );
    }
  }
}

bool isTabletView(BuildContext context) {
  final media = MediaQuery.of(context);
  return media.size.width >= 768;
}

final regexEmoji = RegExp(
  r'[\u{1f300}-\u{1f5ff}\u{1f900}-\u{1f9ff}\u{1f600}-\u{1f64f}'
  r'\u{1f680}-\u{1f6ff}\u{2600}-\u{26ff}\u{2700}'
  r'-\u{27bf}\u{1f1e6}-\u{1f1ff}\u{1f191}-\u{1f251}'
  r'\u{1f004}\u{1f0cf}\u{1f170}-\u{1f171}\u{1f17e}'
  r'-\u{1f17f}\u{1f18e}\u{3030}\u{2b50}\u{2b55}'
  r'\u{2934}-\u{2935}\u{2b05}-\u{2b07}\u{2b1b}'
  r'-\u{2b1c}\u{3297}\u{3299}\u{303d}\u{00a9}'
  r'\u{00ae}\u{2122}\u{23f3}\u{24c2}\u{23e9}'
  r'-\u{23ef}\u{25b6}\u{23f8}-\u{23fa}\u{200d}]+',
  unicode: true,
);

bool hasOnlyEmojis(String text, {bool ignoreWhitespace = false}) {
  if (text.isEmpty) return false;
  if (ignoreWhitespace) text = text.replaceAll(' ', '');
  int emojiCount = 0;
  for (final c in Characters(text)) {
    if (!regexEmoji.hasMatch(c)) return false;
    emojiCount++;
  }
  if (emojiCount > 3) return false;
  return true;
}

Future<bool> openLink(
  String url, {
  LaunchMode mode = LaunchMode.externalApplication,
}) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  final hasScheme = uri.hasScheme;
  if (await canLaunchUrl(uri)) {
    return launchUrlString(hasScheme ? url : "https://$url", mode: mode);
  }
  return false;
}
