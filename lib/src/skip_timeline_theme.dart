import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'skip_connector_theme.dart';
import 'skip_indicator_theme.dart';
import 'timelines.dart';

/// Applies a theme to descendant timeline widgets.
class SkipTimelineTheme extends StatelessWidget {
  /// Applies the given theme [data] to [child].
  const SkipTimelineTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  /// Specifies the direction for descendant widgets.
  final SkipTimelineThemeData data;

  /// The widget below this widget in the tree.
  final Widget child;

  static final SkipTimelineThemeData _kFallbackTheme =
      SkipTimelineThemeData.fallback();

  /// The data from the closest [SkipTimelineTheme] instance.
  static SkipTimelineThemeData of(BuildContext context) {
    final inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    return inheritedTheme?.theme.data ?? _kFallbackTheme;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      theme: this,
      child: SkipIndicatorTheme(
        data: data.indicatorTheme,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SkipTimelineThemeData>('data', data,
        showName: false));
  }
}

class _InheritedTheme extends InheritedTheme {
  const _InheritedTheme({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

  final SkipTimelineTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestorTheme =
        context.findAncestorWidgetOfExactType<_InheritedTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SkipTimelineTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedTheme old) => theme.data != old.theme.data;
}

/// Defines the configuration of the overall visual [SkipTimelineTheme]
@immutable
class SkipTimelineThemeData with Diagnosticable {
  /// Create a [SkipTimelineThemeData] that's used to configure a [SkipTimelineTheme].
  factory SkipTimelineThemeData({
    Axis? direction,
    Color? color,
    double? nodePosition,
    bool? nodeItemOverlap,
    double? indicatorPosition,
    SkipIndicatorThemeData? indicatorTheme,
    SkipConnectorThemeData? connectorTheme,
  }) {
    direction ??= Axis.vertical;
    color ??= Colors.blue;
    nodePosition ??= 0.5;
    nodeItemOverlap ??= false;
    indicatorPosition ??= 0.5;
    indicatorTheme ??= SkipIndicatorThemeData();
    connectorTheme ??= SkipConnectorThemeData();
    return SkipTimelineThemeData.raw(
      direction: direction,
      color: color,
      nodePosition: nodePosition,
      nodeItemOverlap: nodeItemOverlap,
      indicatorPosition: indicatorPosition,
      indicatorTheme: indicatorTheme,
      connectorTheme: connectorTheme,
    );
  }

  /// The default direction theme. Same as [new SkipTimelineThemeData.vertical].
  factory SkipTimelineThemeData.fallback() => SkipTimelineThemeData.vertical();

  /// Create a [SkipTimelineThemeData] given a set of exact values.
  const SkipTimelineThemeData.raw({
    required this.direction,
    required this.color,
    required this.nodePosition,
    required this.nodeItemOverlap,
    required this.indicatorPosition,
    required this.indicatorTheme,
    required this.connectorTheme,
  });

  /// A default vertical theme.
  factory SkipTimelineThemeData.vertical() => SkipTimelineThemeData(
        direction: Axis.vertical,
      );

  /// A default horizontal theme.
  factory SkipTimelineThemeData.horizontal() => SkipTimelineThemeData(
        direction: Axis.horizontal,
      );

  /// {@macro timelines.direction}
  final Axis direction;

  /// The color for major parts of the timeline (indicator, connector, etc)
  final Color color;

  /// The position for [SkipTimelineNode] in [TimelineTile].
  ///
  /// Defaults to 0.5.
  final double nodePosition;

  /// Determine whether each connectors and indicator will overlap in
  /// [SkipTimelineNode].
  final bool nodeItemOverlap;

  /// The position for indicator in [SkipTimelineNode].
  ///
  /// Defaults to 0.5.
  final double indicatorPosition;

  /// A theme for customizing the appearance and layout of
  /// [ThemedIndicatorComponent] widgets.
  final SkipIndicatorThemeData indicatorTheme;

  /// A theme for customizing the appearance and layout of
  /// [ThemedConnectorComponent] widgets.
  final SkipConnectorThemeData connectorTheme;

  /// Creates a copy of this theme but with the given fields replaced with the
  /// new values.
  SkipTimelineThemeData copyWith({
    Axis? direction,
    Color? color,
    double? nodePosition,
    bool? nodeItemOverlap,
    double? indicatorPosition,
    SkipIndicatorThemeData? indicatorTheme,
    SkipConnectorThemeData? connectorTheme,
  }) {
    return SkipTimelineThemeData.raw(
      direction: direction ?? this.direction,
      color: color ?? this.color,
      nodePosition: nodePosition ?? this.nodePosition,
      nodeItemOverlap: nodeItemOverlap ?? this.nodeItemOverlap,
      indicatorPosition: indicatorPosition ?? this.indicatorPosition,
      indicatorTheme: indicatorTheme ?? this.indicatorTheme,
      connectorTheme: connectorTheme ?? this.connectorTheme,
    );
  }

  /// Linearly interpolate between two themes.
  static SkipTimelineThemeData lerp(
      SkipTimelineThemeData a, SkipTimelineThemeData b, double t) {
    return SkipTimelineThemeData.raw(
      direction: t < 0.5 ? a.direction : b.direction,
      color: Color.lerp(a.color, b.color, t)!,
      nodePosition: lerpDouble(a.nodePosition, b.nodePosition, t)!,
      nodeItemOverlap: t < 0.5 ? a.nodeItemOverlap : b.nodeItemOverlap,
      indicatorPosition:
          lerpDouble(a.indicatorPosition, b.indicatorPosition, t)!,
      indicatorTheme:
          SkipIndicatorThemeData.lerp(a.indicatorTheme, b.indicatorTheme, t),
      connectorTheme:
          SkipConnectorThemeData.lerp(a.connectorTheme, b.connectorTheme, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is SkipTimelineThemeData &&
        other.direction == direction &&
        other.color == color &&
        other.nodePosition == nodePosition &&
        other.nodeItemOverlap == nodeItemOverlap &&
        other.indicatorPosition == indicatorPosition &&
        other.indicatorTheme == indicatorTheme &&
        other.connectorTheme == connectorTheme;
  }

  @override
  int get hashCode {
    final values = <Object>[
      direction,
      color,
      nodePosition,
      nodeItemOverlap,
      indicatorPosition,
      indicatorTheme,
      connectorTheme,
    ];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final defaultData = SkipTimelineThemeData.fallback();
    properties
      ..add(DiagnosticsProperty<Axis>('direction', direction,
          defaultValue: defaultData.direction, level: DiagnosticLevel.debug))
      ..add(ColorProperty('color', color,
          defaultValue: defaultData.color, level: DiagnosticLevel.debug))
      ..add(DoubleProperty('nodePosition', nodePosition,
          defaultValue: defaultData.nodePosition, level: DiagnosticLevel.debug))
      ..add(FlagProperty('nodeItemOverlap',
          value: nodeItemOverlap, ifTrue: 'overlap connector and indicator'))
      ..add(DoubleProperty('indicatorPosition', indicatorPosition,
          defaultValue: defaultData.indicatorPosition,
          level: DiagnosticLevel.debug))
      ..add(DiagnosticsProperty<SkipIndicatorThemeData>(
        'indicatorTheme',
        indicatorTheme,
        defaultValue: defaultData.indicatorTheme,
        level: DiagnosticLevel.debug,
      ))
      ..add(DiagnosticsProperty<SkipConnectorThemeData>(
        'connectorTheme',
        connectorTheme,
        defaultValue: defaultData.connectorTheme,
        level: DiagnosticLevel.debug,
      ));
  }

  // RxDart - Theme Management
  static final BehaviorSubject<SkipTimelineThemeData> _themeController =
      BehaviorSubject<SkipTimelineThemeData>.seeded(
          SkipTimelineThemeData.fallback());

  static Stream<SkipTimelineThemeData> get themeStream =>
      _themeController.stream;

  static SkipTimelineThemeData get currentTheme => _themeController.value;

  static void setTheme(SkipTimelineThemeData theme) {
    _themeController.sink.add(theme);
  }

  static void dispose() {
    _themeController.close();
  }
}
