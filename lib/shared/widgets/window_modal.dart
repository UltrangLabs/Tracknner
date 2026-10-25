import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class WindowModal extends StatelessWidget {
  static const double defaultWidth = 320.0;
  static const double defaultHeight = 400.0;

  static const double defaultBarrierOpacity = 0.5;
  static const double maxBarrierOpacity = 0.7;

  static const BorderRadius defaultBorderRadius = BorderRadius.all(
    Radius.circular(24.0),
  );
  static const EdgeInsets defaultPadding = EdgeInsets.all(20.0);

  final Widget child;

  final double width;
  final double height;
  final double barrierOpacity;

  final VoidCallback? onClose;
  final bool showCloseButton;

  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const WindowModal({
    super.key,
    required this.child,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.barrierOpacity = defaultBarrierOpacity,
    this.onClose,
    this.showCloseButton = false,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
  }) : assert(
         barrierOpacity >= 0.0 && barrierOpacity <= maxBarrierOpacity,
         'barrierOpacity cannot be greater than $maxBarrierOpacity',
       ),
       assert(width > 0, 'width must be greater than 0'),
       assert(height > 0, 'height must be greater than 0');

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double width = defaultWidth,
    double height = defaultHeight,
    double barrierOpacity = defaultBarrierOpacity,
    VoidCallback? onClose,
    bool showCloseButton = false,
    Color? backgroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (modalContext) {
        return WindowModal(
          width: width,
          height: height,
          barrierOpacity: barrierOpacity,
          onClose: () {
            onClose?.call();
            Navigator.of(modalContext).maybePop();
          },
          showCloseButton: showCloseButton,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderRadius: borderRadius,
          padding: padding,
          child: child,
        );
      },
    );
  }

  void _handleClose(BuildContext context) {
    if (onClose != null) {
      onClose!();
      return;
    }
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: _ModalBackdrop(
                opacity: barrierOpacity,
                onTap: () {
                  _handleClose(context);
                },
              ),
            ),
            _ModalCard(
              width: width,
              height: height,
              backgroundColor: backgroundColor,
              borderColor: borderColor,
              borderRadius: borderRadius,
              padding: padding,
              showCloseButton: showCloseButton,
              onClose: () {
                _handleClose(context);
              },
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModalBackdrop extends StatelessWidget {
  final double opacity;
  final VoidCallback onTap;

  const _ModalBackdrop({required this.opacity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: ColoredBox(color: Color.fromRGBO(0, 0, 0, opacity)),
      ),
    );
  }
}

class _ModalCard extends StatelessWidget {
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool showCloseButton;
  final VoidCallback onClose;
  final Widget child;

  const _ModalCard({
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderRadius,
    required this.padding,
    required this.showCloseButton,
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final maxAllowedWidth = mediaQuery.width * 0.92;
    final maxAllowedHeight = mediaQuery.height * 0.92;

    final effectiveWidth = width > maxAllowedWidth ? maxAllowedWidth : width;
    final effectiveHeight = height > maxAllowedHeight
        ? maxAllowedHeight
        : height;
    final effectiveRadius = borderRadius ?? WindowModal.defaultBorderRadius;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Container(
        width: effectiveWidth,
        height: effectiveHeight,
        decoration: BoxDecoration(
          color: backgroundColor ?? quaternaryColor,
          borderRadius: effectiveRadius,
          border: Border.all(
            color: borderColor ?? primaryColor.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 24.0,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.08),
              blurRadius: 16.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: effectiveRadius,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: padding ?? WindowModal.defaultPadding,
                  child: child,
                ),
              ),
              if (showCloseButton)
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: _ModalCloseButton(onPressed: onClose),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ModalCloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.close_rounded),
      color: primaryColor,
      iconSize: 20.0,
      tooltip: 'Cerrar',
      style: IconButton.styleFrom(
        backgroundColor: secondaryColor.withValues(alpha: 0.7),
        highlightColor: quinaryColor,
        padding: const EdgeInsets.all(6.0),
        minimumSize: const Size(32.0, 32.0),
      ),
    );
  }
}
