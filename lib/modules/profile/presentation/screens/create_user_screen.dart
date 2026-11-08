import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/theme/app_theme.dart';
import '../constants/profile_constants.dart';
import '../controllers/profile_controller.dart';
import '../widgets/user_form.dart';

class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileController>(
      create: (_) => sl<ProfileController>(),
      child: Scaffold(
        backgroundColor: surfaceBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: kProfileLayoutDimensions.screenHorizontalPadding,
              vertical: kProfileLayoutDimensions.screenVerticalPadding,
            ),
            child: Consumer<ProfileController>(
              builder: (context, controller, _) =>
                  UserForm(controller: controller),
            ),
          ),
        ),
      ),
    );
  }
}
