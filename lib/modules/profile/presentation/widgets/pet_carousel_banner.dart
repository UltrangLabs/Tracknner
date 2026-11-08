import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../constants/profile_constants.dart';

class PetCarouselBanner extends StatefulWidget {
  final String selectedPetImage;
  final ValueChanged<String> onPetSelected;

  const PetCarouselBanner({
    super.key,
    required this.selectedPetImage,
    required this.onPetSelected,
  });

  @override
  State<PetCarouselBanner> createState() => _PetCarouselBannerState();
}

class _PetCarouselBannerState extends State<PetCarouselBanner> {
  static const int _initialPageFactor = 1000;
  static final Duration _animationDuration = Duration(
    milliseconds: kPetCarouselDimensions.transitionDurationMs,
  );

  static final BorderRadius _cardRadius = BorderRadius.all(
    Radius.circular(kUserFormDimensions.cardRadius),
  );

  static final BoxDecoration _bannerDecoration = BoxDecoration(
    color: petHaloBackgroundColor,
    borderRadius: _cardRadius,
    border: Border.fromBorderSide(
      BorderSide(
        color: petHaloBorderColor,
        width: kPetCarouselDimensions.bannerBorderWidth,
      ),
    ),
  );

  late final PageController _pageController;
  late int _currentRealIndex;

  @override
  void initState() {
    super.initState();
    final initialIndex = kAvailablePets.indexWhere(
      (PetOption pet) => pet.imagePath == widget.selectedPetImage,
    );
    _currentRealIndex = initialIndex < 0 ? 0 : initialIndex;
    final initialPage =
        (_initialPageFactor * kAvailablePets.length) + _currentRealIndex;
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPet = kAvailablePets[_currentRealIndex];

    return Container(
      decoration: _bannerDecoration,
      padding: EdgeInsets.symmetric(
        vertical: kProfileLayoutDimensions.spacingDefault,
      ),
      child: Column(
        children: [
          _CarouselPetInfo(pet: currentPet),
          SizedBox(height: kProfileLayoutDimensions.spacingSmall),
          SizedBox(
            height: kPetCarouselDimensions.stageHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: kProfileLayoutDimensions.spacingSmall,
                  ),
                  child: _NavigationArrowButton(
                    icon: Icons.chevron_left_rounded,
                    tooltip: kUserFormStrings.previousPetTooltip,
                    onPressed: _onPrevious,
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (BuildContext context, int index) {
                      final pet = kAvailablePets[index % kAvailablePets.length];
                      return Center(
                        child: _PetImageHalo(imagePath: pet.imagePath),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: kProfileLayoutDimensions.spacingSmall,
                  ),
                  child: _NavigationArrowButton(
                    icon: Icons.chevron_right_rounded,
                    tooltip: kUserFormStrings.nextPetTooltip,
                    onPressed: _onNext,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kProfileLayoutDimensions.spacingSmall),
          _CarouselIndicators(
            currentIndex: _currentRealIndex,
            itemCount: kAvailablePets.length,
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    final realIndex = index % kAvailablePets.length;
    setState(() {
      _currentRealIndex = realIndex;
    });
    widget.onPetSelected(kAvailablePets[realIndex].imagePath);
  }

  void _onPrevious() {
    _pageController.previousPage(
      duration: _animationDuration,
      curve: Curves.easeInOut,
    );
  }

  void _onNext() {
    _pageController.nextPage(
      duration: _animationDuration,
      curve: Curves.easeInOut,
    );
  }
}

class _CarouselPetInfo extends StatelessWidget {
  static final BorderRadius _badgeRadius = BorderRadius.all(
    Radius.circular(kPetCarouselDimensions.badgeRadius),
  );

  static final BoxDecoration _badgeDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: _badgeRadius,
  );

  static const TextStyle _badgeStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w700,
    color: whiteColor,
  );

  static const TextStyle _petNameStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle _petBreedStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: textSecondaryColor,
  );

  final PetOption pet;

  const _CarouselPetInfo({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: kPetCarouselDimensions.badgePaddingHorizontal,
            vertical: kPetCarouselDimensions.badgePaddingVertical,
          ),
          decoration: _badgeDecoration,
          child: Text(kUserFormStrings.selectedBadgeText, style: _badgeStyle),
        ),
        SizedBox(height: kProfileLayoutDimensions.spacingTiny),
        Text(pet.name, style: _petNameStyle),
        SizedBox(height: kProfileLayoutDimensions.spacingMicro),
        Text(pet.breed, style: _petBreedStyle),
      ],
    );
  }
}

class _NavigationArrowButton extends StatelessWidget {
  static const BoxDecoration _buttonDecoration = BoxDecoration(
    color: whiteColor,
    shape: BoxShape.circle,
    border: Border.fromBorderSide(BorderSide(color: navBorderColor)),
  );

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _NavigationArrowButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kPetCarouselDimensions.navButtonSize,
      height: kPetCarouselDimensions.navButtonSize,
      decoration: _buttonDecoration,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: kPetCarouselDimensions.navIconSize,
        icon: Icon(icon, color: primaryColor),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}

class _PetImageHalo extends StatelessWidget {
  static final BorderRadius _imageRadius = BorderRadius.all(
    Radius.circular(kPetCarouselDimensions.petImageRadius),
  );

  static const BoxDecoration _haloDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: whiteColor,
  );

  // El borde se pinta como foreground para quedar por encima de la imagen.
  static final BoxDecoration _haloBorderDecoration = BoxDecoration(
    shape: BoxShape.circle,
    border: Border.fromBorderSide(
      BorderSide(
        color: petHaloBorderColor,
        width: kPetCarouselDimensions.haloBorderWidth,
      ),
    ),
  );

  final String imagePath;

  const _PetImageHalo({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kPetCarouselDimensions.haloSize,
      height: kPetCarouselDimensions.haloSize,
      clipBehavior: Clip.antiAlias,
      decoration: _haloDecoration,
      foregroundDecoration: _haloBorderDecoration,
      child: Center(
        child: ClipRRect(
          borderRadius: _imageRadius,
          child: Image.asset(
            imagePath,
            width: kPetCarouselDimensions.petImageWidth,
            height: kPetCarouselDimensions.petImageHeight,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _CarouselIndicators extends StatelessWidget {
  static final Duration _duration = Duration(
    milliseconds: kPetCarouselDimensions.transitionDurationMs,
  );
  static final BorderRadius _indicatorRadius = BorderRadius.all(
    Radius.circular(kPetCarouselDimensions.indicatorRadius),
  );

  final int currentIndex;
  final int itemCount;

  const _CarouselIndicators({
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < itemCount; i++)
          AnimatedContainer(
            duration: _duration,
            margin: EdgeInsets.symmetric(
              horizontal: kPetCarouselDimensions.indicatorSpacing / 2,
            ),
            width: i == currentIndex
                ? kPetCarouselDimensions.indicatorActiveDotWidth
                : kPetCarouselDimensions.indicatorDotSize,
            height: kPetCarouselDimensions.indicatorDotSize,
            decoration: BoxDecoration(
              color: i == currentIndex ? primaryColor : quinaryColor,
              borderRadius: _indicatorRadius,
            ),
          ),
      ],
    );
  }
}
