typedef GetCurrentTime = DateTime Function();

DateTime currentUtcTime() {
  return DateTime.now().toUtc();
}
