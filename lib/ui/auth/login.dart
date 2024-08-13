import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/token.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/utils/routes.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class Login extends StatefulWidget {
  final bool biometric;
  const Login({super.key, this.biometric = true});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordNode = FocusNode();
  bool biometricLogin = false;
  bool hidePassword = true;
  String? errorMessage;

  UserProvider get provider => context.read<UserProvider>();

  void login({bool autoLogin = false}) async {
    setState(() => errorMessage = null);
    if (!autoLogin && !formKey.currentState!.validate()) return;
    String email = emailController.text;
    String password = passwordController.text;
    // if (autoLogin) {
    // final bioAuth = false;
    //await provider.authenticateBio();
    // if (!bioAuth && mounted) {
    //   await showAppDialog(
    //     context,
    //     title: "Error",
    //     message: "The automatic attempt to sign you in was not successful. "
    //         "Please try again or manually log in with your email and password to continue.",
    // footer: (context) {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       ElevatedButton(
    //         child: const Text("Try again"),
    //         onPressed: () async {
    //           Navigator.pop(context);
    //           login(autoLogin: true);
    //         },
    //       ),
    //       VSizedBox12,
    //       OutlinedButton(
    //         child: const Text("Cancel"),
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //       ),
    //     ],
    //   );
    // },
    //   );
    //   return;
    // } else {
    // final savedEmail = (await provider.getEmail()) ?? "";
    // final savedPassword = (await provider.getPassword()) ?? "";
    // if (savedEmail.isNotEmpty && savedPassword.isNotEmpty) {
    //   email = savedEmail;
    //   password = savedPassword;
    // }
    // }
    // }
    if (!mounted) return;
    await ProviderRequest.api(
      context: context,
      request: provider.login(TokenObtainPairRequest(
        email: email,
        password: password,
      )),
      loadingMessage: "Signing in",
      onError: (context) {
        setState(() => errorMessage = 'An error occurred');
      },
      onApiError: (context, error) {
        setState(() {
          errorMessage = (error?.details?['detail']) ??
              (error?.details?['non_field_errors']?.join('\n')) ??
              error?.message;
        });
      },
      postRequest: (context) {
        return Future.wait<dynamic>([
          // context.read<UserProvider>().getProfile(),
          context.read<AppProvider>().initialize(),
        ]);
      },
      onSuccess: (context, res) async {
        if (res.data == null) return;
        final state = provider.getRouteForUser(provider.user);
        final navigator = rootNavigator(context);
        navigator.pushNamedAndRemoveUntil(state, (_) => false);

        // if (state == Routes.appIndex || state == Routes.profile) {
        //   navigator.pushNamedAndRemoveUntil(state, (_) => false);
        // } else {
        //   navigator.pushNamed(state);
        // }
      },
    );
  }

  void autoLoginChecks() async {
    // final provider = context.read<UserProvider>();
    // final bioAuth = await provider.getBioAuth();
    // final canAutoLogin = await provider.canAutoLogin();
    // biometricLogin = bioAuth && widget.biometric && canAutoLogin;
    // if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    autoLoginChecks();
    provider.getEmail().then((e) {
      return emailController.text = e ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        pageAppBar: const PageAppBar(
          largeTitle: Text("Log in to your account"),
        ),
        bodyPadding: ContentPadding,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VSizedBox16,
            FormInput(
              title: const Text("Email address"),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                autofillHints: const [AutofillHints.email],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your email address",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Email is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                  biometricLogin = false;
                }),
              ),
            ),
            FormInput(
              title: const Text("Password"),
              margin: const EdgeInsets.only(bottom: 24),
              child: TextFormField(
                obscureText: hidePassword,
                focusNode: passwordNode,
                controller: passwordController,
                autofillHints: const [AutofillHints.password],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? PhosphorIconsRegular.eyeClosed
                          : PhosphorIconsRegular.eye,
                    ),
                  ),
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Password is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                  biometricLogin = false;
                }),
                onFieldSubmitted: (_) {
                  login();
                },
              ),
            ),
            if (errorMessage != null)
              Container(
                padding: ContentPadding * 0.7,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.dynamic(
                    context: context,
                    light: AppColors.red.shade50.withOpacity(0.5),
                    dark: AppColors.red.shade900,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: context.theme.colorScheme.error,
                    ),
                    HSizedBox4,
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //     style: TextButton.styleFrom(padding: EdgeInsets.zero),
            //     child: const Text(
            //       "Forgot Password?",
            //       style: TextStyle(
            //         fontSize: 15,
            //       ),
            //     ),
            //     onPressed: () {
            //       // Navigator.pushNamed(context, Routes.resetPassword);
            //     },
            //   ),
            // ),
            VSizedBox40,
            const Spacer(),
            ElevatedButton(
              child: const Text("Continue"),
              onPressed: () {
                login();
              },
            ),
            // if (biometricLogin) ...[
            //   VSizedBox16,
            //   OutlinedButton.icon(
            //     label: const Text("Log in with FaceID"),
            //     icon: Image.asset(
            //       AppAssets.images.iconsFaceidPng,
            //       height: 16,
            //       width: 16,
            //       color: context.textTheme.bodyLarge?.color,
            //     ),
            //     onPressed: () {
            //       login(autoLogin: true);
            //     },
            //   ),
            // ],
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: TextButton(
            child: const Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.signup);
            },
          ),
        ),
      ),
    );
  }
}
