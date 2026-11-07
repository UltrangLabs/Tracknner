const int _experiencePerLevel = 100;

typedef PetProgress = ({int level, int experience});

int requiredExperienceFor(int level) => level * _experiencePerLevel;

PetProgress applyExperience({
  required int level,
  required int experience,
  required int gainedExperience,
}) {
  var currentLevel = level;
  var remaining = experience + gainedExperience;

  while (remaining >= requiredExperienceFor(currentLevel)) {
    remaining -= requiredExperienceFor(currentLevel);
    currentLevel++;
  }

  return (level: currentLevel, experience: remaining);
}
