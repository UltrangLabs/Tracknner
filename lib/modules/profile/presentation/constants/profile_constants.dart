// Layout and screen spacing constants
const kProfileLayoutDimensions = (
  screenHorizontalPadding: 20.0,
  screenVerticalPadding: 16.0,
  spacingLarge: 28.0,
  spacingMedium: 24.0,
  spacingDefault: 20.0,
  spacingSmall: 18.0,
  spacingCompact: 16.0,
  spacingTiny: 8.0,
  spacingMicro: 4.0,
  spacingInline: 6.0,
  spacingGap: 10.0,
  spacingWideGap: 14.0,
);

// Top bar and logo constants
const kProfileTopBarDimensions = (
  logoSize: 36.0,
  logoIconSize: 20.0,
  coinIconSize: 18.0,
  coinHorizontalPadding: 12.0,
  coinVerticalPadding: 6.0,
);

// Pet avatar and halo constants
const kPetAvatarDimensions = (
  haloSize: 200.0,
  haloBorderWidth: 2.0,
  imageWidth: 140.0,
  imageHeight: 100.0,
  imageRadius: 16.0,
);

// Sparkle particle constants
const kSparkleDimensions = (
  largeSize: 20.0,
  smallSize: 16.0,
  topOffset: 24.0,
  rightOffset: 28.0,
  bottomOffset: 30.0,
  leftOffset: 26.0,
);

// Pet level, XP, and action button constants
const kPetProgressDimensions = (
  levelBadgeHorizontalPadding: 12.0,
  levelBadgeVerticalPadding: 4.0,
  progressBarHeight: 8.0,
  feedButtonHorizontalPadding: 20.0,
  feedButtonVerticalPadding: 10.0,
  feedButtonBorderWidth: 1.5,
  feedActionIconSize: 18.0,
  feedCoinIconSize: 16.0,
);

// Daily mission card constants
const kDailyMissionCardDimensions = (
  cardPadding: 14.0,
  iconPadding: 10.0,
  iconSize: 24.0,
  checkIconSize: 26.0,
  shadowBlurRadius: 10.0,
  shadowOffsetY: 4.0,
);

// User form dimensions
const kUserFormDimensions = (
  inputBorderRadius: 16.0,
  inputBorderWidth: 1.5,
  inputContentPaddingHorizontal: 16.0,
  inputContentPaddingVertical: 14.0,
  inputIconSize: 20.0,
  submitButtonHeight: 52.0,
  submitButtonRadius: 16.0,
  cardPadding: 20.0,
  cardRadius: 20.0,
);

// Pet carousel dimensions
const kPetCarouselDimensions = (
  bannerHeight: 220.0,
  bannerBorderWidth: 1.5,
  stageHeight: 190.0,
  petImageWidth: 150.0,
  petImageHeight: 110.0,
  petImageRadius: 18.0,
  haloSize: 180.0,
  haloBorderWidth: 2.0,
  navButtonSize: 42.0,
  navIconSize: 22.0,
  navButtonElevation: 2.0,
  indicatorDotSize: 8.0,
  indicatorActiveDotWidth: 20.0,
  indicatorSpacing: 6.0,
  indicatorRadius: 4.0,
  badgePaddingHorizontal: 12.0,
  badgePaddingVertical: 4.0,
  badgeRadius: 16.0,
  transitionDurationMs: 300,
);

// Texts and UI copy
const kProfileStrings = (
  appName: 'Tracknner',
  appLogoPath: 'assets/icon/ico_tracknner_boceto.jpg',
  companionSubtitle: 'TU COMPAÑERO DE CARRERA',
  levelTitle: 'Corredor constante',
  xpTitle: 'XP',
  feedButtonTitle: 'Alimentar',
  feedCost: '10',
  bulletSeparator: '•',
  dailyMissionTag: 'MISIÓN DIARIA',
  startRunLabel: 'Empezar Carrera',
);

String greetingFor(String userName) => '¡Sigue así, $userName!';

String levelLabelFor(int level) => 'LVL $level';

String experienceLabel({required int experience, required int goal}) {
  return '$experience / $goal';
}

String missionTitleFor(int targetDurationSeconds) {
  return 'Objetivo de hoy: Corre ${targetDurationSeconds ~/ 60} minutos';
}

// User form copy
const kUserFormStrings = (
  formTitle: 'Crea tu Perfil',
  formSubtitle:
      'Elige tu compañero y dinos tu nombre para comenzar la aventura.',
  petBannerTitle: 'ELIGE A TU COMPAÑERO',
  nameLabel: 'Nombre del Corredor',
  nameHint: 'Ej. Alex Runner',
  nameHelper: 'Mínimo 3 caracteres y máximo 50',
  nameRequiredError: 'El nombre es requerido',
  nameMinLengthError: 'El nombre es muy corto',
  nameMaxLengthError: 'El nombre es muy largo',
  nameInvalidError: 'El nombre contiene caracteres inválidos',
  submitButtonText: 'Crear Perfil',
  previousPetTooltip: 'Mascota anterior',
  nextPetTooltip: 'Mascota siguiente',
  selectedBadgeText: 'Seleccionado',
);

typedef PetOption = ({String id, String name, String breed, String imagePath});

const List<PetOption> kAvailablePets = [
  (
    id: 'golden',
    name: 'Max',
    breed: 'Golden Retriever',
    imagePath: 'assets/imgs/pets/golden.jpg',
  ),
  (
    id: 'chihuahua',
    name: 'Kiu',
    breed: 'Chihuahua',
    imagePath: 'assets/imgs/pets/chihuahua.jpg',
  ),
  (
    id: 'poodle',
    name: 'Luna',
    breed: 'Poodle',
    imagePath: 'assets/imgs/pets/poodle.jpg',
  ),
  (
    id: 'shih_tzu',
    name: 'Rocky',
    breed: 'Shih Tzu',
    imagePath: 'assets/imgs/pets/shih-tzu.jpg',
  ),
];
