import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ridge/core/theme/app_motion.dart';

RectCallback? _getClipCallback(
  RenderBox referenceBox,
  bool containedInkWell,
  RectCallback? rectCallback,
) {
  if (rectCallback != null) {
    assert(
      containedInkWell,
      'A rectCallback can only be provided when containedInkWell is true.',
    );
    return rectCallback;
  }
  if (containedInkWell) {
    return () => Offset.zero & referenceBox.size;
  }
  return null;
}

int _alpha(Color color) => (color.a * 255.0).round().clamp(0, 255);

double _getTargetRadius(
  RenderBox referenceBox,
  bool containedInkWell,
  RectCallback? rectCallback,
  Offset position,
) {
  final size = rectCallback != null ? rectCallback().size : referenceBox.size;
  final d1 = size.bottomRight(Offset.zero).distance;
  final d2 =
      (size.topRight(Offset.zero) - size.bottomLeft(Offset.zero)).distance;
  return math.max(d1, d2) / 2.0;
}

/// The app's signature touch feedback: a slower, slightly overshooting
/// bloom instead of Material's brisk default ripple — same silhouette
/// language (`paintInkCircle`) but tuned to [AppMotion]'s spatial spring so
/// every tap reads as part of the same expressive motion system.
class ExpressiveInkFeatureFactory extends InteractiveInkFeatureFactory {
  /// Creates the factory — stateless, safe to use as a `const` splash
  /// factory in a [ThemeData].
  const new();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return _ExpressiveInkBloom(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}

/// The app-wide `InkWell`/`InkResponse` splash factory — set once on
/// [ThemeData.splashFactory] in `app_theme.dart`.
const expressiveSplashFactory = ExpressiveInkFeatureFactory();

const _fadeInDuration = Duration(milliseconds: 90);
const _fadeOutDuration = Duration(milliseconds: 420);
const _unconfirmedDuration = Duration(seconds: 1);
const _fadeOutIntervalStart = 0.5;

class _ExpressiveInkBloom extends InteractiveInkFeature {
  new({
    required super.controller,
    required super.referenceBox,
    required Offset position,
    required super.color,
    required this.textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    super.customBorder,
    double? radius,
    super.onRemoved,
  }) : _position = position,
       _borderRadius = borderRadius ?? BorderRadius.zero,
       _targetRadius =
           radius ??
           _getTargetRadius(
             referenceBox,
             containedInkWell,
             rectCallback,
             position,
           ),
       _clipCallback = _getClipCallback(
         referenceBox,
         containedInkWell,
         rectCallback,
       ) {
    _fadeInController =
        AnimationController(duration: _fadeInDuration, vsync: controller.vsync)
          ..addListener(controller.markNeedsPaint)
          ..forward();
    _fadeIn = _fadeInController.drive(IntTween(begin: 0, end: _alpha(color)));

    _radiusController =
        AnimationController(
            duration: _unconfirmedDuration,
            vsync: controller.vsync,
          )
          ..addListener(controller.markNeedsPaint)
          ..forward();
    // Starts a touch larger than InkRipple's default and eases past the
    // target before settling — the "bloom" that makes it feel alive.
    _radius = _radiusController.drive(
      Tween<double>(
        begin: _targetRadius * 0.45,
        end: _targetRadius * 1.05,
      ).chain(CurveTween(curve: AppMotion.emphasizedBounce)),
    );

    _fadeOutController =
        AnimationController(duration: _fadeOutDuration, vsync: controller.vsync)
          ..addListener(controller.markNeedsPaint)
          ..addStatusListener(_handleAlphaStatusChanged);
    _fadeOut = _fadeOutController.drive(
      IntTween(
        begin: _alpha(color),
        end: 0,
      ).chain(CurveTween(curve: const Interval(_fadeOutIntervalStart, 1))),
    );

    controller.addInkFeature(this);
  }

  final Offset _position;
  final BorderRadius _borderRadius;
  final double _targetRadius;
  final RectCallback? _clipCallback;
  final TextDirection textDirection;

  late final Animation<double> _radius;
  late final AnimationController _radiusController;
  late final Animation<int> _fadeIn;
  late final AnimationController _fadeInController;
  late final Animation<int> _fadeOut;
  late final AnimationController _fadeOutController;

  @override
  void confirm() {
    _radiusController
      ..duration = AppMotion.spatialDefault
      ..forward();
    _fadeInController.forward();
    _fadeOutController.animateTo(1, duration: _fadeOutDuration);
  }

  @override
  void cancel() {
    _fadeInController.stop();
    final fadeOutValue = 1.0 - _fadeInController.value;
    _fadeOutController.value = fadeOutValue;
    if (fadeOutValue < 1.0) {
      _fadeOutController.animateTo(1, duration: AppMotion.effectsFast);
    }
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status.isCompleted) dispose();
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _fadeInController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final alpha = _fadeInController.isAnimating
        ? _fadeIn.value
        : _fadeOut.value;
    final paint = Paint()..color = color.withAlpha(alpha);
    final rect = _clipCallback?.call();
    final center = Offset.lerp(
      _position,
      rect != null ? rect.center : referenceBox.size.center(Offset.zero),
      AppMotion.spatial.transform(_radiusController.value.clamp(0.0, 1.0)),
    )!;
    paintInkCircle(
      canvas: canvas,
      transform: transform,
      paint: paint,
      center: center,
      textDirection: textDirection,
      radius: _radius.value,
      customBorder: customBorder,
      borderRadius: _borderRadius,
      clipCallback: _clipCallback,
    );
  }
}
