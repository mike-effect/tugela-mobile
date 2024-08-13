import 'package:flutter/material.dart';
import 'package:tugela/models.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/forms/form_input.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerCreate extends StatefulWidget {
  const FreelancerCreate({super.key});

  @override
  State<FreelancerCreate> createState() => _FreelancerCreateState();
}

class _FreelancerCreateState extends State<FreelancerCreate> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  ApiError? apiError;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return FormScope(
      formKey: formKey,
      child: SliverScaffold(
        pageAppBar: const PageAppBar(
          largeTitle: Text("Freelancer Profile"),
        ),
        bodyPadding: ContentPadding,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormInput(
              title: const Text("Name"),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                autofillHints: const [AutofillHints.organizationName],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your company name",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Name is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
            FormInput(
              title: const Text("Name"),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                autofillHints: const [AutofillHints.organizationName],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Your company name",
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Name is required";
                  return null;
                },
                onChanged: (_) => setState(() {
                  errorMessage = null;
                }),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
            child: const Text("Continue"),
            onPressed: () {
              // Navigator.pushReplacementNamed(context, Routes.signup);
            },
          ),
        ),
      ),
    );
  }
}
