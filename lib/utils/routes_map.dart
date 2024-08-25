part of 'routes.dart';

class RoutesMap {
  static Map<String, WidgetBuilder> get map {
    return {
      Routes.appIndex: (_) => const Index(),
      Routes.welcome: (_) => const Welcome(),
      Routes.login: (_) => const Login(),
      Routes.signup: (_) => const SignUp(),
      Routes.profile: (_) => const ProfileEdit(),
      Routes.onboard: (_) => const Onboard(),
      Routes.freelancerCreate: (_) => const FreelancerSettings(),
      Routes.companyCreate: (_) => const CompanyCreate(),
      Routes.settings: (_) => const Settings(),
    };
  }
}
