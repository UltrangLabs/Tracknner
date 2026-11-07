typedef GetCurrentTime = DateTime Function();

// Reloj de pared en UTC. Se usa el reloj de pared (y no un Stopwatch
// monotónico) porque sigue avanzando mientras el SO suspende la app, de modo
// que la diferencia entre dos marcas incluye el tiempo en segundo plano.
DateTime currentUtcTime() {
  return DateTime.now().toUtc();
}
