import 'package:flutter/material.dart';

import 'skip_indicator_theme.dart';
import 'skip_timeline_theme.dart';

/// [SkipTimelineNode]'s indicator.
mixin SkipPositionedIndicator on Widget {
  /// {@template timelines.indicator.position}
  /// If this is null, then the [SkipIndicatorThemeData.position] is used. If that
  /// is also null, then this defaults to [SkipTimelineThemeData.indicatorPosition].
  /// {@endtemplate}
  double? get position;
  double getEffectivePosition(BuildContext context) {
    return position ??
        SkipIndicatorTheme.of(context).position ??
        SkipTimelineTheme.of(context).indicatorPosition;
  }
}

/// Abstract class for predefined indicator widgets.
abstract class SkipIndicator extends StatelessWidget
    with SkipPositionedIndicator, SkipThemedIndicatorComponent {
  /// Creates an indicator.
  const SkipIndicator({
    Key? key,
    this.size,
    this.color,
    this.border,
    this.position,
    this.child,
  })  : assert(size == null || size >= 0),
        assert(position == null || 0 <= position && position <= 1),
        super(key: key);

  /// Creates a dot indicator.
  factory SkipIndicator.dot({
    Key? key,
    double? size,
    Color? color,
    double? position,
    Border? border,
    Widget? child,
  }) =>
      SkipDotIndicator(
        size: size,
        color: color,
        position: position,
        border: border,
        child: child,
      );

  /// Creates a outlined dot indicator.
  factory SkipIndicator.outlined({
    Key? key,
    double? size,
    Color? color,
    Color? backgroundColor,
    double? position,
    double borderWidth = 2.0,
    Widget? child,
  }) =>
      SkipOutlinedDotIndicator(
        size: size,
        color: color,
        position: position,
        backgroundColor: backgroundColor,
        borderWidth: borderWidth,
        child: child,
      );

  /// Creates a transparent indicator.
  factory SkipIndicator.transparent({
    Key? key,
    double? size,
    double? position,
  }) =>
      SkipContainerIndicator(
        size: size,
        position: position,
      );

  /// Creates a widget indicator.
  factory SkipIndicator.widget({
    Key? key,
    double? size,
    double? position,
    Widget? child,
  }) =>
      SkipContainerIndicator(
        size: size,
        position: position,
        child: child,
      );

  /// The size of the dot in logical pixels.
  @override
  final double? size;

  /// The color to use when drawing the dot.
  @override
  final Color? color;

  /// The position of a indicator between the two connectors.
  @override
  final double? position;

  /// The border to use when drawing the dot's outline.
  final BoxBorder? border;

  /// The widget below this widget in the tree.
  final Widget? child;
}

/// A widget that displays an [child]. The [child] if null, the indicator is not
/// visible.
class SkipContainerIndicator extends SkipIndicator {
  /// Creates a container indicator.
  const SkipContainerIndicator({
    Key? key,
    double? size,
    double? position,
    this.child,
  }) : super(
          key: key,
          size: size,
          position: position,
          color: Colors.transparent,
        );

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final size = getEffectiveSize(context);
    return Container(
      width: size,
      height: size,
      child: child,
    );
  }
}

/// A widget that displays an dot.
class SkipDotIndicator extends SkipIndicator {
  /// Creates a dot indicator.
  const SkipDotIndicator({
    Key? key,
    double? size,
    Color? color,
    double? position,
    this.border,
    this.child,
  }) : super(
          key: key,
          size: size,
          color: color,
          position: position,
        );

  /// The border to use when drawing the dot's outline.
  final BoxBorder? border;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = getEffectiveSize(context);
    final effectiveColor = getEffectiveColor(context);
    return Center(
      child: Container(
        width: effectiveSize ?? ((child == null) ? 15.0 : null),
        height: effectiveSize ?? ((child == null) ? 15.0 : null),
        child: child,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: effectiveColor,
          border: border,
        ),
      ),
    );
  }
}

/// A widget that displays an outlined dot.
class SkipOutlinedDotIndicator extends SkipIndicator {
  /// Creates a outlined dot indicator.
  const SkipOutlinedDotIndicator({
    Key? key,
    double? size,
    Color? color,
    double? position,
    this.backgroundColor,
    this.borderWidth = 2.0,
    this.child,
  })  : assert(size == null || size >= 0),
        assert(position == null || 0 <= position && position <= 1),
        super(
          key: key,
          size: size,
          color: color,
          position: position,
        );

  /// The color to use when drawing the dot in outline.
  final Color? backgroundColor;

  /// The width of this outline, in logical pixels.
  final double borderWidth;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SkipDotIndicator(
      size: size,
      color: backgroundColor ?? Colors.transparent,
      position: position,
      border: Border.all(
        color: color ?? getEffectiveColor(context),
        width: borderWidth,
      ),
      child: child,
    );
  }
}
