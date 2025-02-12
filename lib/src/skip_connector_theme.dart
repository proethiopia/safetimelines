import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'skip_connectors.dart';
import 'skip_timeline_node.dart';
import 'skip_timeline_theme.dart';

/// Defines the visual properties of [SkipSolidLineConnector], connectors inside
/// [SkipTimelineNode].
@immutable
class SkipConnectorThemeData with Diagnosticable {
  /// Creates a theme that can be used for [SkipConnectorTheme] or
  /// [SkipTimelineThemeData.connectorTheme].
  const SkipConnectorThemeData({
    this.color,
    this.space,
    this.thickness,
    this.indent,
  });

  /// The color of [SkipSolidLineConnector]s and connectors inside [SkipTimelineNode]s,
  /// and so forth.
  final Color? color;

  /// This represents the amount of horizontal or vertical space the connector
  /// takes up.
  final double? space;

  /// The thickness of the line drawn within the connector.
  final double? thickness;

  /// The amount of empty space at the edge of [SkipSolidLineConnector].
  final double? indent;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  SkipConnectorThemeData copyWith({
    Color? color,
    double? space,
    double? thickness,
    double? indent,
  }) {
    return SkipConnectorThemeData(
      color: color ?? this.color,
      space: space ?? this.space,
      thickness: thickness ?? this.thickness,
      indent: indent ?? this.indent,
    );
  }

  /// Linearly interpolate between two Connector themes.
  static SkipConnectorThemeData lerp(
      SkipConnectorThemeData? a, SkipConnectorThemeData? b, double t) {
    return SkipConnectorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      space: lerpDouble(a?.space, b?.space, t),
      thickness: lerpDouble(a?.thickness, b?.thickness, t),
      indent: lerpDouble(a?.indent, b?.indent, t),
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      space,
      thickness,
      indent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is SkipConnectorThemeData &&
        other.color == color &&
        other.space == space &&
        other.thickness == thickness &&
        other.indent == indent;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('space', space, defaultValue: null))
      ..add(DoubleProperty('thickness', thickness, defaultValue: null))
      ..add(DoubleProperty('indent', indent, defaultValue: null));
  }
}

/// An inherited widget that defines the configuration for
/// [SkipSolidLineConnector]s, connectors inside [SkipTimelineNode]s.
class SkipConnectorTheme extends InheritedTheme {
  /// Creates a connector theme that controls the configurations for
  /// [SkipSolidLineConnector]s, connectors inside [SkipTimelineNode]s.
  const SkipConnectorTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The properties for descendant [SkipSolidLineConnector]s, connectors inside
  /// [SkipTimelineNode]s.
  final SkipConnectorThemeData data;

  /// The closest instance of this class's [data] value that encloses the given
  /// context.
  ///
  /// If there is no ancestor, it returns [SkipTimelineThemeData.connectorTheme].
  /// Applications can assume that the returned value will not be null.
  static SkipConnectorThemeData of(BuildContext context) {
    final connectorTheme =
        context.dependOnInheritedWidgetOfExactType<SkipConnectorTheme>();
    return connectorTheme?.data ?? SkipTimelineTheme.of(context).connectorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestorTheme =
        context.findAncestorWidgetOfExactType<SkipConnectorTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SkipConnectorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(SkipConnectorTheme oldWidget) =>
      data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

/// Connector component configured through [SkipConnectorTheme]
mixin SkipThemedConnectorComponent on Widget {
  /// {@template timelines.connector.direction}
  /// If this is null, then the [SkipTimelineThemeData.direction] is used.
  /// {@endtemplate}
  Axis? get direction;
  Axis getEffectiveDirection(BuildContext context) {
    return direction ?? SkipTimelineTheme.of(context).direction;
  }

  /// {@template timelines.connector.thickness}
  /// If this is null, then the [SkipConnectorThemeData.thickness] is used which
  /// defaults to 2.0.
  /// {@endtemplate}
  double? get thickness;
  double getEffectiveThickness(BuildContext context) {
    return thickness ?? SkipConnectorTheme.of(context).thickness ?? 2.0;
  }

  /// {@template timelines.connector.space}
  /// If this is null, then the [SkipConnectorThemeData.space] is used. If that is
  /// also null, then this defaults to double.infinity.
  /// {@endtemplate}
  double? get space;
  double? getEffectiveSpace(BuildContext context) {
    return space ?? SkipConnectorTheme.of(context).space;
  }

  double? get indent;
  double getEffectiveIndent(BuildContext context) {
    return indent ?? SkipConnectorTheme.of(context).indent ?? 0.0;
  }

  double? get endIndent;
  double getEffectiveEndIndent(BuildContext context) {
    return endIndent ?? SkipConnectorTheme.of(context).indent ?? 0.0;
  }

  Color? get color;
  Color getEffectiveColor(BuildContext context) {
    return color ??
        SkipConnectorTheme.of(context).color ??
        SkipTimelineTheme.of(context).color;
  }
}
