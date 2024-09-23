import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';

class SettingsPayments extends StatefulWidget {
  final AccountType accountType;
  const SettingsPayments({
    super.key,
    required this.accountType,
  });

  @override
  State<SettingsPayments> createState() => _SettingsPaymentsState();
}

class _SettingsPaymentsState extends State<SettingsPayments> {
  final formKey = GlobalKey<FormState>();
  final xrpAddressController = TextEditingController();
  final xrpSeedController = TextEditingController();
  ApiError? apiError;
  String? errorMessage;
  bool obscure = true;

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.accountType == AccountType.freelancer) {
  //     final freelancer = context.read<UserProvider>().user?.freelancer;
  //     if (freelancer != null) {
  //       xrpAddressController.text = freelancer.xrpAddress ?? "";
  //       xrpSeedController.text = freelancer.xrpSeed ?? "";
  //     }
  //   } else if (widget.accountType == AccountType.company) {
  //     final company = context.read<UserProvider>().user?.company;
  //     if (company != null) {
  //       xrpAddressController.text = company.xrpAddress ?? "";
  //       xrpSeedController.text = company.xrpSeed ?? "";
  //     }
  //   }
  //   if (mounted) setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FreelancerProvider>();
    final address = provider.user?.xrpAddress ?? "";
    final userProvider = context.watch<UserProvider>();
    final balance = userProvider.balance?.xrpBalance;
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: AppColors.greyElevatedBackgroundColor(context),
    );

    return FormScope(
      formKey: formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tugela Wallet"),
        ),
        body: SingleChildScrollView(
          padding: ContentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: ContentPadding,
                decoration: boxDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VSizedBox16,
                    Text(
                      "Wallet Balance",
                      style: TextStyle(
                        color: context.textTheme.bodySmall?.color,
                      ),
                    ),
                    VSizedBox12,
                    Text(
                      formatAmount(
                        (balance ?? 0),
                        symbol: "XRP",
                        isCrypto: true,
                        truncate: true,
                      ),
                      textScaler: maxTextScale(context, 1),
                      style: const TextStyle(
                        height: 1,
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    VSizedBox16,
                  ],
                ),
              ),
              VSizedBox12,

              // Text(
              //   "Below is your XRP information to receive payments on Tugela.",
              //   style: context.textTheme.bodyMedium,
              // ),
              const SizedBox(height: 32),
              FormInput(
                title: const Text("Address"),
                child: TextFormField(
                  readOnly: false,
                  canRequestFocus: false,
                  controller: TextEditingController(
                    text: userProvider.user?.xrpAddress,
                  ),
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Your XRP Address",
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return "XRP Address is required";
                    return null;
                  },
                  onChanged: (_) => setState(() {
                    errorMessage = null;
                  }),
                ),
              ),
              // FormInput(
              //   title: const Text("Secret Seed"),
              //   child: TextFormField(
              //     controller: xrpSeedController,
              //     keyboardType: TextInputType.text,
              //     autocorrect: false,
              //     obscureText: obscure,
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     decoration: InputDecoration(
              //       hintText: "Your XRP Secret Seed",
              //       suffixIcon: IconButton(
              //         onPressed: () {
              //           setState(() {
              //             obscure = !obscure;
              //           });
              //         },
              //         icon: Icon(
              //           obscure
              //               ? PhosphorIconsRegular.eyeClosed
              //               : PhosphorIconsRegular.eye,
              //         ),
              //       ),
              //     ),
              //     validator: (v) {
              //       if (v!.isEmpty) return "XRP Secret Seed is required";
              //       return null;
              //     },
              //     onChanged: (_) => setState(() {
              //       errorMessage = null;
              //     }),
              //   ),
              // ),
              // VSizedBox24,
              // Container(
              //   padding: ContentPadding,
              //   decoration: BoxDecoration(
              //     borderRadius: AppTheme.cardBorderRadius,
              //     color: AppColors.dynamic(
              //       context: context,
              //       light: Colors.amber.withOpacity(0.15),
              //     ),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Icon(
              //         PhosphorIconsRegular.warningCircle,
              //         color: context.textTheme.bodyMedium?.color,
              //       ),
              //       VSizedBox12,
              //       const Text(
              //         "Store your secret seed securely. Losing it means losing access to your funds. Tugela does not store your secret seed.",
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    copyToClipboard(address);
                    ScaffoldMessenger.maybeOf(context)
                        ?.showSnackBar(const SnackBar(
                      content: Text("Copied to clipboard"),
                    ));
                  },
                  child: const Text("Copy Address"),
                ),
              ),
              HSizedBox12,
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    pushNamed(
                      context,
                      widget.accountType == AccountType.freelancer
                          ? Routes.xrpWithdrawal
                          : Routes.xrpTopup,
                      rootNavigator: true,
                    );
                  },
                  child: Text(
                    widget.accountType == AccountType.freelancer
                        ? "Withdraw"
                        : "Top up",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void submit() async {
  //   errorMessage = null;
  //   apiError = null;
  //   if (mounted) setState(() {});
  //   if (!formKey.currentState!.validate()) return;

  //   if (widget.accountType == AccountType.freelancer) {
  //     final provider = context.read<FreelancerProvider>();
  //     final freelancer = context.read<UserProvider>().user?.freelancer;
  //     if (freelancer != null) {
  //       final input = Freelancer(
  //         id: freelancer.id,
  //         user: freelancer.user,
  //         xrpAddress: xrpAddressController.text,
  //         xrpSeed: xrpSeedController.text,
  //       );
  //       await ProviderRequest.api(
  //         context: context,
  //         loadingMessage: "Saving",
  //         request: provider.updateFreelancer(freelancer.id!, input),
  //         onError: (context) {
  //           setState(() => errorMessage = 'An error occurred');
  //         },
  //         onApiError: (context, error) {
  //           setState(() => apiError = error);
  //           formKey.currentState!.validate();
  //         },
  //         onSuccess: (context, res) async {
  //           ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
  //             content: Text("Saved"),
  //           ));
  //           context.read<UserProvider>().getUserMe();
  //           Navigator.pop(context);
  //         },
  //       );
  //     }
  //   } else if (widget.accountType == AccountType.company) {
  //     final provider = context.read<CompanyProvider>();
  //     final company = context.read<UserProvider>().user?.company;
  //     if (company != null) {
  //       final input = Company(
  //         id: company.id,
  //         xrpAddress: xrpAddressController.text,
  //         xrpSeed: xrpSeedController.text,
  //       );
  //       await ProviderRequest.api(
  //         context: context,
  //         loadingMessage: "Saving",
  //         request: provider.updateCompany(company.id!, input),
  //         onError: (context) {
  //           setState(() => errorMessage = 'An error occurred');
  //         },
  //         onApiError: (context, error) {
  //           setState(() => apiError = error);
  //           formKey.currentState!.validate();
  //         },
  //         onSuccess: (context, res) async {
  //           ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
  //             content: Text("Saved"),
  //           ));
  //           context.read<UserProvider>().getUserMe();
  //           Navigator.pop(context);
  //         },
  //       );
  //     }
  //   }
  // }
}
