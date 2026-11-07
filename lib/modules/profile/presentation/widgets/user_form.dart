import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../domain/dtos/in/create_user_dto.dart';
import '../constants/profile_constants.dart';
import '../controllers/profile_controller.dart';
import 'pet_carousel_banner.dart';

class UserForm extends StatefulWidget {
  final ProfileController controller;
  final VoidCallback? onSuccess;

  const UserForm({super.key, required this.controller, this.onSuccess});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  static final BorderRadius _cardRadius = BorderRadius.all(
    Radius.circular(kUserFormDimensions.cardRadius),
  );

  static final List<BoxShadow> _cardShadow = [
    BoxShadow(
      color: cardShadowColor,
      blurRadius: kDailyMissionCardDimensions.shadowBlurRadius,
      offset: Offset(0, kDailyMissionCardDimensions.shadowOffsetY),
    ),
  ];

  static final BoxDecoration _cardDecoration = BoxDecoration(
    color: cardBackgroundColor,
    borderRadius: _cardRadius,
    boxShadow: _cardShadow,
    border: const Border.fromBorderSide(BorderSide(color: navBorderColor)),
  );

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  String _selectedPetImage = kAvailablePets.first.imagePath;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Container(
      padding: EdgeInsets.all(kUserFormDimensions.cardPadding),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _FormHeader(),
          SizedBox(height: kProfileLayoutDimensions.spacingDefault),
          PetCarouselBanner(
            selectedPetImage: _selectedPetImage,
            onPetSelected: _onPetSelected,
          ),
          SizedBox(height: kProfileLayoutDimensions.spacingMedium),
          if (controller.errorMessage != null) ...[
            Text(
              controller.errorMessage!,
              style: const TextStyle(
                color: inputErrorColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: kProfileLayoutDimensions.spacingTiny),
          ],
          _NameInputField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            errorText: controller.validationErrors[CreateUserDto.nameKey],
            onChanged: (_) => controller.clearFieldError(CreateUserDto.nameKey),
          ),
          SizedBox(height: kProfileLayoutDimensions.spacingMedium),
          _SubmitButton(
            isLoading: controller.isLoading,
            onPressed: controller.isLoading ? null : _onSubmit,
          ),
        ],
      ),
    );
  }

  void _onPetSelected(String petImagePath) {
    setState(() {
      _selectedPetImage = petImagePath;
    });
  }

  Future<void> _onSubmit() async {
    _nameFocusNode.unfocus();
    widget.controller.choosePet(_selectedPetImage);

    await widget.controller.createUser({
      CreateUserDto.nameKey: _nameController.text.trim(),
    });

    if (widget.controller.data != null && mounted) {
      widget.onSuccess?.call();
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class _FormHeader extends StatelessWidget {
  static const TextStyle _titleStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle _subtitleStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
  );

  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(kUserFormStrings.formTitle, style: _titleStyle),
        SizedBox(height: kProfileLayoutDimensions.spacingMicro),
        Text(kUserFormStrings.formSubtitle, style: _subtitleStyle),
      ],
    );
  }
}

class _NameInputField extends StatelessWidget {
  static final BorderRadius _inputRadius = BorderRadius.all(
    Radius.circular(kUserFormDimensions.inputBorderRadius),
  );

  static final OutlineInputBorder _enabledBorder = OutlineInputBorder(
    borderRadius: _inputRadius,
    borderSide: BorderSide(
      color: inputBorderColor,
      width: kUserFormDimensions.inputBorderWidth,
    ),
  );

  static final OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: _inputRadius,
    borderSide: BorderSide(
      color: primaryColor,
      width: kUserFormDimensions.inputBorderWidth,
    ),
  );

  static final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: _inputRadius,
    borderSide: BorderSide(
      color: inputErrorColor,
      width: kUserFormDimensions.inputBorderWidth,
    ),
  );

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle _hintStyle = TextStyle(
    fontSize: 14.0,
    color: navInactiveColor,
  );

  static const TextStyle _helperStyle = TextStyle(
    fontSize: 12.0,
    color: textSecondaryColor,
  );

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _NameInputField({
    required this.controller,
    required this.focusNode,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(kUserFormStrings.nameLabel, style: _labelStyle),
        SizedBox(height: kProfileLayoutDimensions.spacingTiny),
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 15.0,
            color: textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: kUserFormStrings.nameHint,
            hintStyle: _hintStyle,
            helperText: errorText == null ? kUserFormStrings.nameHelper : null,
            helperStyle: _helperStyle,
            errorText: errorText,
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              color: primaryColor,
              size: kUserFormDimensions.inputIconSize,
            ),
            filled: true,
            fillColor: whiteColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: kUserFormDimensions.inputContentPaddingHorizontal,
              vertical: kUserFormDimensions.inputContentPaddingVertical,
            ),
            enabledBorder: _enabledBorder,
            focusedBorder: _focusedBorder,
            errorBorder: _errorBorder,
            focusedErrorBorder: _errorBorder,
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  static final BorderRadius _buttonRadius = BorderRadius.all(
    Radius.circular(kUserFormDimensions.submitButtonRadius),
  );

  static const TextStyle _buttonTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );

  final bool isLoading;
  final VoidCallback? onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kUserFormDimensions.submitButtonHeight,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: _buttonRadius),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                ),
              )
            : Text(kUserFormStrings.submitButtonText, style: _buttonTextStyle),
      ),
    );
  }
}
