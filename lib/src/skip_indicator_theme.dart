import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'skip_indicators.dart';
import 'skip_timeline_node.dart';
import 'skip_timeline_theme.dart';

/// Defines the visual properties of [SkipDotIndicator], indicators inside
/// [SkipTimelineNode]s.
@immutable
class SkipIndicatorThemeData with Diagnosticable {
  /// Creates a theme that can be used for [SkipIndicatorTheme] or
  /// [SkipTimelineThemeData.indicatorTheme].
  const SkipIndicatorThemeData({
    this.color,
    this.size,
    this.position,
  });

  /// The color of [SkipDotIndicator]s and indicators inside [SkipTimelineNode]s, and so
  /// forth.
  final Color? color;

  /// The size of [SkipDotIndicator]s and indicators inside [SkipTimelineNode]s, and so
  /// forth in logical pixels.
  final double? size;

  /// A position of indicator inside both two connectors.
  final double? position;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  SkipIndicatorThemeData copyWith({
    Color? color,
    double? size,
    double? position,
  }) {
    return SkipIndicatorThemeData(
      color: color ?? this.color,
      size: size ?? this.size,
      position: position ?? this.position,
    );
  }

  /// Linearly interpolate between two Indicator themes.
  static SkipIndicatorThemeData lerp(
      SkipIndicatorThemeData? a, SkipIndicatorThemeData? b, double t) {
    return SkipIndicatorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      size: lerpDouble(a?.size, b?.size, t),
      position: lerpDouble(a?.position, b?.position, t),
    );
  }

  @override
  int get hashCode => hashValues(color, size, position);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is SkipIndicatorThemeData &&
        other.color == color &&
        other.size == size &&
        other.position == position;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('size', size, defaultValue: null))
      ..add(DoubleProperty('position', size, defaultValue: null));
  }
}

/// Controls the default color and size of indicators in a widget subtree.
class SkipIndicatorTheme extends InheritedTheme {
  /// Creates an indicator theme that controls the color and size for
  /// [SkipDotIndicator]s, indicators inside [SkipTimelineNode]s.
  const SkipIndicatorTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The properties for descendant [SkipDotIndicator]s, indicators inside
  /// [SkipTimelineNode]s.
  final SkipIndicatorThemeData data;

  /// The data from the closest instance of this class that encloses the given
  /// context.
  static SkipIndicatorThemeData of(BuildContext context) {
    final indicatorTheme =
        context.dependOnInheritedWidgetOfExactType<SkipIndicatorTheme>();
    return indicatorTheme?.data ?? SkipTimelineTheme.of(context).indicatorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestorTheme =
        context.findAncestorWidgetOfExactType<SkipIndicatorTheme>();
    return identical(this, ancestorTheme