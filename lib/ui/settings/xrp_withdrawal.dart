import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/layout/page_header.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

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
            PageHeader(
              subtitle: "Your wallet is balance is ${formatAmount(
                (balance),
                symbol: "XRP",
                isCrypto: true,
                truncate: true,
              )}",
            ),
            FormInput(
              title: const Text("Recipient"),
              child: TextFormField(
                controller: addressController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Recipient XRP Address",
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
