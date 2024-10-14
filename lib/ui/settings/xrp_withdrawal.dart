import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tugela/constants/config.dart';
import 'package:tugela/extensions/build_context.extension.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';
import 'package:url_launcher/url_launcher_string.dart';

class XRPWithdrawal extends StatefulWidget {
  const XRPWithdrawal({super.key});

  @override
  State<XRPWithdrawal> createState() => _XRPWithdrawalState();
}

class _XRPWithdrawalState extends State<XRPWithdrawal> {
  final formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final balance = userProvider.balance?.xrpBalance ?? 0;
    final amount = double.tryParse(amountController.text) ?? 0;
    final transakUrl = AppConfig.transakUrl(
      action: "withdrawal",
      walletAddress: userProvider.user?.xrpAddress ?? "",
      email: userProvider.user?.email ?? "",
      userData: {
        "mobileNumber": userProvider.user?.freelancer?.phoneNumber ?? "",
      },
    );

    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        pageAppBar: const PageAppBar(
          largeTitle: Text("Make Withdrawal"),
        ),
        bodyPadding: ContentPaddingZeroTop,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Wallet balance is ${formatAmount(
                (balance),
                symbol: "XRP",
                isCrypto: true,
                truncate: true,
              )}",
              style: const TextStyle(fontSize: 15),
            ),
            VSizedBox24,
            Container(
              margin: ContentPaddingV,
              padding: ContentPadding,
              decoration: BoxDecoration(
                color: context.theme.dividerColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.theme.dividerColor.withOpacity(0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ready to withdraw your XRP?",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  VSizedBox8,
                  Text.rich(
                    TextSpan(children: [
                      const TextSpan(
                        text:
                            "1.\tInitiate the process on your preferred provider to "
                            "SELL the XRP cryptocurrency. We recommend a platform for you if you do not have one already.\n",
                      ),
                      TextSpan(
                        text: "Tap here to use our provider.\n\n",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            openLink(transakUrl,
                                mode: LaunchMode.externalApplication);
                          },
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const TextSpan(
                        text: "2. Copy the XRP address you're given by the "
                            "provider to make the transfer to.\n\n",
                      ),
                      const TextSpan(
                        text: "3. Complete the process by pasting the XRP "
                            "address and entering your amount in the form below.",
                      ),
                    ]),
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ],
              ),
            ),
            VSizedBox24,
            FormInput(
              title: const Text("Recipient Address"),
              child: TextFormField(
                controller: addressController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: "Recipient XRP Address",
                  suffixIcon: TextButton(
                    child: const Text("Paste"),
                    onPressed: () async {
                      final res = await pasteFromClipboard();
                      if (res?.text != null) {
                        addressController.text = res?.text ?? "";
                        setState(() {});
                      }
                    },
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                    r'\br[1-9A-HJ-NP-Za-km-z]{25,33}\b',
                  )),
                ],
                validator: (v) {
                  if (v!.isEmpty) return "XRP Address is required";
                  // if (!(RegExp(r'[1-9A-HJ-NP-Za-km-z]{25,33}').hasMatch(v))) {
                  //   return "Enter a valid XRP address";
                  // }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
            ),
            FormInput(
              title: const Text("Amount"),
              child: TextFormField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [AmountInputFormatter.crypto()],
                decoration: const InputDecoration(
                  hintText: "XRP Amount",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "XRP amount is required";
                  if (amount == 0) return "Amount must be greater than zero";
                  if (amount > balance) {
                    return "Your balance is insufficient for this amount";
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
            ),
            VSizedBox16,
            Space,
            ElevatedButton(
              onPressed: submit,
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }

  void submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final provider = context.read<UserProvider>();
    ProviderRequest.api(
      context: context,
      request: provider.withdrawXrp(
        address: addressController.text,
        amount: amountController.text,
      ),
      onSuccess: (context, res) {
        if (res.data ?? false) {
          Navigator.pop(context);
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
            content: Text("Withdrawal successful"),
          ));
        }
      },
    );
  }
}
