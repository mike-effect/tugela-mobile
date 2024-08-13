import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugela/extensions/build_context.extension.dart';

Future<T?> showAppDialog<T>(
  BuildContext context, {
  String? title,
  String? message,
  Text? customTitle,
  Text? customMessage,
  Text? dimissiveText,
  Text? confirmationText,
  Text? alternateText,
  void Function(BuildContext context)? onDismiss,
  void Function(BuildContext context)? onConfirm,
  void Function(BuildContext context)? onAlternate,
  bool pushReplacement = false,
  T? replacementResult,
}) async {
  final dialog = AppDialog<T>(
    title: title,
    message: message,
    customTitle: customTitle,
    customMessage: customMessage,
    dismissiveText: dimissiveText,
    confirmationText: confirmationText,
    onDismiss: onDismiss,
    onConfirm: onConfirm,
    alternateText: alternateText,
    onAlternate: onAlternate,
  );
  final navigator = Navigator.of(context, rootNavigator: true);
  return pushReplacement
      ? await navigator.pushReplacement(dialog, result: replacementResult)
      : await navigator.push(dialog);
}

class AppDialog<T> extends ModalRoute<T> {
  final String? title;
  final String? message;
  final Text? customTitle;
  final Text? customMessage;
  final Text? dismissiveText;
  final Text? alternateText;
  final Text? confirmationText;
  final void Function(BuildContext context)? onDismiss;
  final void Function(BuildContext context)? onConfirm;
  final void Function(BuildContext context)? onAlternate;

  AppDialog({
    required this.title,
    required this.message,
    this.customTitle,
    this.customMessage,
    this.dismissiveText,
    this.confirmationText,
    this.onDismiss,
    this.onConfirm,
    this.alternateText,
    this.onAlternate,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String get barrierLabel => "Close";

  @override
  bool get maintainState => true;

  @override
  RouteSettings get settings {
    if (title?.toLowerCase() == "session expired") {
      return const RouteSettings(name: "/app-dialog/session");
    }
    return const RouteSettings(name: "/app-dialog");
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final theme = context.theme;
    const titleTextStyle = TextStyle(
      fontSize: 18,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w600,
    );
    final messageTextStyle = TextStyle(
      fontSize: 15,
      letterSpacing: 0.2,
      color: context.textTheme.bodySmall?.color,
    );
    const buttonPadding = EdgeInsets.fromLTRB(30, 15, 30, 15);

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          margin: const EdgeInsets.all(60),
          decoration: BoxDecoration(
            color: theme.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                child: DefaultTextStyle(
                  style: context.textTheme.bodyLarge!.merge(titleTextStyle),
                  child: customTitle ??
                      Text(
                        title ?? "",
                        textAlign: TextAlign.center,
                        style: titleTextStyle,
                      ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                    child: customMessage ??
                        DefaultTextStyle(
                          style: context.textTheme.bodySmall!
                              .merge(messageTextStyle),
                          child: Text(
                            message ?? "",
                            textAlign: TextAlign.center,
                            style: messageTextStyle,
                          ),
                        ),
                  ),
                ),
              ),
              if (confirmationText != null && onConfirm != null) ...[
                const Divider(height: 1),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: buttonPadding,
                    foregroundColor: confirmationText?.style?.color,
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    onConfirm!(context);
                  },
                  child: Text(
                    confirmationText!.data!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.theme.colorScheme.onSecondary,
                    ).merge(confirmationText?.style),
                  ),
                ),
              ],
              if (alternateText != null && onAlternate != null) ...[
                const Divider(height: 1),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: buttonPadding,
                    foregroundColor: alternateText?.style?.color,
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    onAlternate!(context);
                  },
                  child: Text(
                    alternateText!.data!,
                    textAlign: TextAlign.center,
                    style: const TextStyle().merge(alternateText?.style),
                  ),
                ),
              ],
              const Divider(height: 1),
              TextButton(
                style: TextButton.styleFrom(
                  padding: buttonPadding,
                  foregroundColor: context.textTheme.bodySmall?.color,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (onDismiss != null) {
                    onDismiss!(context);
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Text(
                  dismissiveText?.data ?? "Close",
                  textAlign: TextAlign.center,
                  style: const TextStyle().merge(dismissiveText?.style),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
