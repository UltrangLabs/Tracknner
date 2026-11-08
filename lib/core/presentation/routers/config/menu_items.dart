import 'package:flutter/material.dart';

import '../constants/routes_path_constant.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

final appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Inicio',
    subTitle: 'Sección de Inicio en desarrollo',
    link: kRoutesPath.dashboard,
    icon: Icons.home_outlined,
  ),
  MenuItem(
    title: 'Carrera',
    subTitle: 'Sección de Carrera en desarrollo',
    link: kRoutesPath.carrera,
    icon: Icons.access_time_rounded,
  ),
  MenuItem(
    title: 'Resumen',
    subTitle: 'Sección de Resumen en desarrollo',
    link: kRoutesPath.resumen,
    icon: Icons.military_tech_outlined,
  ),
  MenuItem(
    title: 'Historia',
    subTitle: 'Sección de Historia en desarrollo',
    link: kRoutesPath.historia,
    icon: Icons.calendar_month_outlined,
  ),
  MenuItem(
    title: 'Mascota',
    subTitle: 'Sección de Mascota en desarrollo',
    link: kRoutesPath.mascota,
    icon: Icons.pets_outlined,
  ),
];
