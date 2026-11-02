import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../constants/profile_constants.dart';

class PetAvatar extends StatelessWidget {
  static final double _haloSize = kPetAvatarDimensions.haloSize;
  static final double _petImageWidth = kPetAvatarDimensions.imageWidth;
  static final double _petImageHeight = kPetAvatarDimensions.imageHeight;

  static const BorderRadius _imageRadius = BorderRadius.all(
    Radius.circular(16.0),
  );

  static final BoxDecoration _haloDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: petHaloBackgroundColor,
    border: Border.fromBorderSide(
      BorderSide(
        color: petHaloBorderColor,
        width: kPetAvatarDimensions.haloBorderWidth,
      ),
    ),
  );

  final String imagePath;

  const PetAvatar({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _haloSize,
        height: _haloSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: _haloSize,
              height: _haloSize,
              decoration: _haloDecoration,
            ),
            Positioned(
              top: kSparkleDimensions.topOffset,
              right: kSparkleDimensions.rightOffset,
              child: Icon(
                Icons.auto_awesome,
                color: sextarianColor,
                size: kSparkleDimensions.largeSize,
              ),
            ),
            Positioned(
              bottom: kSparkleDimensions.bottomOffset,
              left: kSparkleDimensions.leftOffset,
              child: Icon(
                Icons.auto_awesome,
                color: sextarianColor,
                size: kSparkleDimensions.smallSize,
              ),
            ),
            ClipRRect(
              borderRadius: _imageRadius,
              child: Image.asset(
                imagePath,
                width: _petImageWidth,
                height: _petImageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
