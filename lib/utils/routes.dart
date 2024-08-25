import 'package:flutter/widgets.dart';
import 'package:tugela/ui/auth/login.dart';
import 'package:tugela/ui/auth/signup.dart';
import 'package:tugela/ui/company/company_create.dart';
import 'package:tugela/ui/freelancer/freelancer_settings.dart';
import 'package:tugela/ui/index/index.dart';
import 'package:tugela/ui/onboarding/onboard.dart';
import 'package:tugela/ui/onboarding/profile_edit.dart';
import 'package:tugela/ui/onboarding/welcome.dart';
import 'package:tugela/ui/settings/settings.dart';

part 'routes_map.dart';

class Routes {
  Routes._();

  static const welcome = "/welcome";

  static const splash = "/splash";
  static const appIndex = "/index";
  static const tabIndex = "/";

  static const login = "/auth/login";
  static const signup = "/auth/signup";
  static const profile = "/auth/profile";
  static const onboard = "/auth/onboard";
  static const freelancerCreate = "/freelancer/create";
  static const companyCreate = "/company/create";
  // static const forgotPassword = "/auth/forgot-password";
  // static const resetPasswordToken = "/auth/verify-email/password-reset";
  // static const accountPersonalInfo = "/auth/account/personal";

  // settings
  static const settings = "/profile/settings";
}
