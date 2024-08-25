import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/utils/routes.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  bool hidePassword = true;
  ApiError? apiError;
  String? errorMessage;

  UserProvider get provider => context.read<UserProvider>();

  @override
  Widget build(BuildContext context) {
    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        pageAppBar: const PageAppBar(
          largeTitle: Text("Let's get started"),
        ),
        bodyPadding: ContentPadding,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VSizedBox16,
            FormInput(
              title: const Text("Username"),
              child: TextFormField(
                autocorrect: false,
                controller: usernameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newUsername],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(usernameRegex),
                ],
                decoration: const InputDecoration(
                  hintText: "Choose a username",
                ),
                onChanged: (value) {
                  setState(() => errorMessage = null);
                  apiError?.details?.remove('username');
                  if (mounted) setState(() {});
                },
                validator: (v) {
                  if (v!.isEmpty) return "Username is required";
                  if (!(v.contains(usernameRegex))) {
                    return "Your username can only contain letters, numbers and '_'";
                  }
                  return apiError?.forKey("username");
                },
              ),
            ),
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
                  if (!isValidEmail(v)) return "Enter a valid email address";
                  if (v!.isEmpty) return "Email is required";
                  return apiError?.forKey('email')?.sentenceCase;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                  apiError?.details?.remove('email');
                  if (mounted) setState(() {});
                }),
              ),
            ),
            FormInput(
              title: const Text("Password"),
              child: TextFormField(
                obscureText: hidePassword,
                controller: passwordController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
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
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Password is required";
                  return apiError?.forKey('password')?.sentenceCase ??
                      validateString(
                        value: v,
                        name: "Password",
                        minLength: 8,
                        requireDigit: true,
                        requireLowercase: true,
                        requireSpecial: true,
                        requireUppercase: true,
                      );
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                  apiError?.details?.remove('password');
                  if (mounted) setState(() {});
                }),
                onFieldSubmitted: (_) {},
              ),
            ),
            FormInput(
              title: const Text("Confirm Password"),
              child: TextFormField(
                obscureText: true,
                controller: rePasswordController,
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Confirm Password",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Repeat your password";
                  if (v != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return apiError?.forKey('password2');
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                  apiError?.details?.remove('password2');
                  if (mounted) setState(() {});
                }),
                onFieldSubmitted: (_) {},
              ),
            ),
            const Spacer(),
            VSizedBox20,
            ElevatedButton(
              child: const Text("Continue"),
              onPressed: () {
                signup();
              },
            ),
            VSizedBox12,
            TextButton(
              child: const Text.rich(
                TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                      text: "Log in",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.signup);
              },
            ),
          ],
        ),
      ),
    );
  }

  void signup() async {
    errorMessage = null;
    apiError = null;
    if (mounted) setState(() {});
    if (!formKey.currentState!.validate()) return;
    await ProviderRequest.api(
      context: context,
      loadingMessage: "Creating account",
      request: provider.signUp(SignUpRequest(
        email: emailController.text,
        password: passwordController.text,
        password2: rePasswordController.text,
        username: usernameController.text,
      )),
      onError: (context) {
        setState(() => errorMessage = 'An error occurred');
      },
      onApiError: (context, error) {
        setState(() => apiError = error);
        formKey.currentState!.validate();
      },
      onSuccess: (context, res) async {
        ProviderRequest.api(
          context: context,
          request: provider.login(TokenObtainPairRequest(
            email: emailController.text,
            password: rePasswordController.text,
          )),
          onSuccess: (context, res) {
            if (res.data == null) return;
            rootNavigator(context).pushNamedAndRemoveUntil(
                provider.getRouteForUser(), (_) => false);
          },
        );
      },
    );
  }
}
