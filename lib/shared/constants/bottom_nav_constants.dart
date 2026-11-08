import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData icon;
  final String label;

  const BottomNavItem({required this.icon, required this.label});
}

const List<BottomNavItem> defaultBottomNavItems = [
  BottomNavItem(icon: Icons.home_outlined, label: 'Inicio'),
  BottomNavItem(icon: Icons.access_time_rounded, label: 'Carrera'),
  BottomNavItem(icon: Icons.military_tech_outlined, label: 'Resumen'),
  BottomNavItem(icon: Icons.calendar_month_outlined, label: 'Historia'),
  BottomNavItem(icon: Icons.pets_outlined, label: 'Mascota'),
];
