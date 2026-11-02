import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../constants/profile_constants.dart';
import 'pet_carousel_banner.dart';

class UserForm extends StatefulWidget {
  final ValueChanged<String>? onUserCreated;
  final ValueChanged<String>? onPetChosen;

  const UserForm({super.key, this.onUserCreated, this.onPetChosen});

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  // Selected pet image stored in class state as requested
  String _selectedPetImage = kAvailablePets.first.imagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kUserFormDimensions.cardPadding),
      decoration: _cardDecoration,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Evita que el formulario se estire infinitamente dentro del modal.
          mainAxisSize: MainAxisSize.min,
          children: [
            const _FormHeader(),
            SizedBox(height: kProfileLayoutDimensions.spacingDefault),
            PetCarouselBanner(
              selectedPetImage: _selectedPetImage,
              onPetSelected: _onPetSelected,
            ),
            SizedBox(height: kProfileLayoutDimensions.spacingMedium),
            _NameInputField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              validator: _validateName,
            ),
            SizedBox(height: kProfileLayoutDimensions.spacingMedium),
            _SubmitButton(onPressed: _onSubmit),
          ],
        ),
      ),
    );
  }

  void _onPetSelected(String petImagePath) {
    setState(() {
      _selectedPetImage = petImagePath;
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return kUserFormStrings.nameRequiredError;
    }
    if (value.trim().length < 3) {
      return kUserFormStrings.nameMinLengthError;
    }
    if (value.trim().length > 50) {
      return kUserFormStrings.nameMaxLengthError;
    }
    final safeTextRegex = RegExp(r'^[a-zA-Z0-9\s\-_.,!¡?¿@ñÑáéíóúÁÉÍÓÚ]+$');
    if (!safeTextRegex.hasMatch(value)) {
      return kUserFormStrings.nameInvalidError;
    }
    return null;
  }

  void _onSubmit() {
    _nameFocusNode.unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      widget.onPetChosen?.call(_selectedPetImage);
      widget.onUserCreated?.call(_nameController.text.trim());
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
  final FormFieldValidator<String> validator;

  const _NameInputField({
    required this.controller,
    required this.focusNode,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(kUserFormStrings.nameLabel, style: _labelStyle),
        SizedBox(height: kProfileLayoutDimensions.spacingTiny),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          style: const TextStyle(
            fontSize: 15.0,
            color: textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: kUserFormStrings.nameHint,
            hintStyle: _hintStyle,
            helperText: kUserFormStrings.nameHelper,
            helperStyle: _helperStyle,
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

  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

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
        child: Text(kUserFormStrings.submitButtonText, style: _buttonTextStyle),
      ),
    );
  }
}
