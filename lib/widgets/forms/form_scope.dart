import 'package:flutter/material.dart';

class FormScope extends StatelessWidget {
  final Widget child;
  final GlobalKey<FormState>? formKey;
  final bool canPop;
  final void Function(bool didPop)? onPopInvoked;
  final VoidCallback? onTap;
  final bool canUnfocus;

  const FormScope({
    super.key,
    required this.child,
    this.formKey,
    this.canPop = true,
    this.onTap,
    this.onPopInvoked,
    this.canUnfocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!canUnfocus) FocusScope.of(context).unfocus();
        onTap?.call();
      },
      child: Form(
        key: formKey,
        canPop: canPop,
        onPopInvoked: onPopInvoked,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AutofillGroup(child: child),
      ),
    );
  }
}
