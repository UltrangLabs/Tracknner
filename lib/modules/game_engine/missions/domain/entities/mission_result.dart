enum MissionStatus { success, failed }

class MissionResult {
  final MissionStatus status;
  final int targetDurationSeconds;
  final int completedDurationSeconds;

  const MissionResult({
    required this.status,
    required this.targetDurationSeconds,
    required this.completedDurationSeconds,
  });

  bool get isRewardEligible => status == MissionStatus.success;
}
