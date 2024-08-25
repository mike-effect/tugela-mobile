import 'package:flutter/material.dart';
import 'package:tugela/models.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/forms/form_scope.dart';
import 'package:tugela/widgets/layout/menu_list_tile.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerSettings extends StatefulWidget {
  const FreelancerSettings({super.key});

  @override
  State<FreelancerSettings> createState() => _FreelancerSettingsState();
}

class _FreelancerSettingsState extends State<FreelancerSettings> {
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
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [MenuListTile(title: "title")],
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
