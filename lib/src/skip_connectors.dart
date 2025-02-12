import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'skip_connector_theme.dart';
import 'skip_line_painter.dart';
import 'timelines.dart';
import 'skip_timeline_node.dart';
import 'skip_timeline_theme.dart';

/// Abstract class for predefined connector widgets.
abstract class SkipConnector extends StatelessWidget
    with SkipThemedConnectorComponent {
  /// Creates an connector.
  const SkipConnector({
    Key? key,
    this.direction,
    this.space,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  })  : assert(thickness == null || thickness >= 0.0),
        assert(space == null || space >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0),
        super(key: key);

  /// Creates a solid line connector.
  factory SkipConnector.solidLine({
    Key? key,
    Axis? direction,
    double? thickness,
    double? space,
    double? indent,
    double? endIndent,
    Color? color,
  }) {
    return SkipSolidLineConnector(
      key: key,
      direction: direction,
      thickness: thickness,
      space: space,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }

  /// Creates a dashed line connector.
  factory SkipConnector.dashedLine({
    Key? key,
    Axis? direction,
    double? thickness,
    double? dash,
    double? gap,
    double? space,
    double? indent,
    double? endIndent,
    Color? color,
    Color? gapColor,
  }) {
    return SkipDashedLineConnector(
      key: key,
      direction: direction,
      thickness: thickness,
      dash: dash,
      gap: gap,
      space: space,
      indent: indent,
      endIndent: endIndent,
      color: color,
      gapColor: gapColor,
    );
  }

  /// Creates a dashed transparent connector.
  factory SkipConnector.transparent({
    Key? key,
    Axis? direction,
    double? indent,
    double? endIndent,
    double? space,
  }) {
    return SkipTransparentConnector(
      key: key,
      direction: direction,
      indent: indent,
      endIndent: endIndent,
      space: space,
    );
  }

  /// {@macro timelines.direction}
  ///
  /// {@macro timelines.connector.direction}
  @override
  final Axis? direction;

  /// The connector's cross axis size extent.
  ///
  /// The connector itself is always drawn as a line that is centered within the
  /// size specified by this value.
  /// {@macro timelines.connector.space}
  @override
  final double? space;

  /// The thickness of the line drawn within the connector.
  ///
  /// {@macro timelines.connector.thickness}
  @override
  final double? thickness;

  /// The amount of empty space to the leading edge of the connector.
  ///
  /// If this is null, then the [SkipConnectorThemeData.indent] is used. If that is
  /// also null, then this defaults to 0.0.
  @override
  final double? indent;

  /// The amount of empty space to the trailing edge of the connector.
  ///
  /// If this is null, then the [SkipConnectorThemeData.indent] is used. If that is
  /// also null, then this defaults to 0.0.
  @override
  final double? endIndent;

  /// The color to use when painting the line.
  ///
  /// If this is null, then the [SkipConnectorThemeData.color] is used. If that is
  /// also null, then [SkipTimelineThemeData.color] is used.
  @override
  final Color? color;
}

/// A thin line, with padding on either side.
///
/// The box's total cross axis size(width or height, depend on [direction]) is
/// controlled by [space].
///
/// The appropriate padding is automatically computed from the cross axis size.
class SkipSolidLineConnector extends SkipConnector {
  /// Creates a solid line connector.
  ///
  /// The [thickness], [space], [indent], and [endIndent] must be null or
  /// non-negative.
  const SkipSolidLineConnector({
    Key? key,
    Axis? direction,
    double? thickness,
    double? space,
    double? indent,
    double? endIndent,
    Color? color,
  }) : super(
          key: key,
          thickness: thickness,
          space: space,
          indent: indent,
          endIndent: endIndent,
          color: color,
        );

  @override
  Widget build(BuildContext context) {
    final direction = getEffectiveDirection(context);
    final thickness = getEffectiveThickness(context);
    final color = getEffectiveColor(context);
    final space = getEffectiveSpace(context);
    final indent = getEffectiveIndent(context);
    final endIndent = getEffectiveEndIndent(context);

    switch (direction) {
      case Axis.vertical:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            width: thickness,
            color: color,
          ),
        );
      case Axis.horizontal:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            height: thickness,
            color: color,
          ),
        );
    }
  }
}

/// A decorated thin line, with padding on either side.
///
/// The box's total cross axis size(width or height, depend on [direction]) is
/// controlled by [space].
///
/// The appropriate padding is automatically computed from the cross axis size.
class SkipDecoratedLineConnector extends SkipConnector {
  /// Creates a decorated line connector.
  ///
  /// The [thickness], [space], [indent], and [endIndent] must be null or
  /// non-negative.
  const SkipDecoratedLineConnector({
    Key? key,
    Axis? direction,
    double? thickness,
    double? space,
    double? indent,
    double? endIndent,
    this.decoration,
  }) : super(
          key: key,
          thickness: thickness,
          space: space,
          indent: indent,
          endIndent: endIndent,
        );

  /// The decoration to paint line.
  ///
  /// Use the [SkipSolidLineConnector] class to specify a simple solid color line.
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    final direction = getEffectiveDirection(context);
    final thickness = getEffectiveThickness(context);
    final space = getEffectiveSpace(context);
    final indent = getEffectiveIndent(context);
    final endIndent = getEffectiveEndIndent(context);
    final color = decoration == null ? getEffectiveColor(context) : null;

    switch (direction) {
      case Axis.vertical:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            width: thickness,
            color: color,
            decoration: decoration,
          ),
        );
      case Axis.horizontal:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            height: thickness,
            color: color,
            decoration: decoration,
          ),
        );
    }
  }
}

/// A thin dashed line, with padding on either side.
///
/// The box's total cross axis size(width or height, depend on [direction]) is
/// controlled by [space].
///
/// The appropriate padding is automatically computed from the cross axis size.
///
/// See also:
///
///  * [SkipDashedLinePainter], which is painter that draws this connector.
class SkipDashedLineConnector extends SkipConnector {
  /// Creates a dashed line connector.
  ///
  /// The [thickness], [space], [indent], and [endIndent] must be null or
  /// non-negative.
  const SkipDashedLineConnector({
    Key? key,
    Axis? direction,
    double? thickness,
    this.dash,
    this.gap,
    double? space,
    double? indent,
    double? endIndent,
    Color? color,
    this.gapColor,
  }) : super(
          key: key,
          direction: direction,
          thickness: thickness,
          space: space,
          indent: indent,
          endIndent: endIndent,
          color: color,
        );

  /// The dash size of the line drawn within the connector.
  ///
  /// If this is null, then this defaults to 1.0.
  final double? dash;

  /// The gap of the line drawn within the connector.
  ///
  /// If this is null, then this defaults to 1.0.
  final double? gap;

  /// The color to use when painting the gap in the line.
  ///
  /// If this is null, then the [Colors.transparent] is used.
  final Color? gapColor;

  @override
  Widget build(BuildContext context) {
    final direction = getEffectiveDirection(context);
    return _ConnectorIndent(
      direction: direction,
      indent: getEffectiveIndent(context),
      endIndent: getEffectiveEndIndent(context),
      space: getEffectiveSpace(context),
      child: CustomPaint(
        painter: SkipDashedLinePainter(
          direction: direction,
          color: getEffectiveColor(context),
          strokeWidth: getEffectiveThickness(context),
          dashSize: dash ?? 1.0,
          gapSize: gap ?? 1.0,
          gapColor: gapColor ?? Colors.transparent,
        ),
        child: Container(),
      ),
    );
  }
}

/// A transparent connector for start, end [SkipTimelineNode] of the [Timeline].
///
/// This connector will be not displayed, it only occupies an area.
class SkipTransparentConnector extends SkipConnector {
  /// Creates a transparent connector.
  ///
  /// The [space], [indent], and [endIndent] must be null or non-negative.
  const SkipTransparentConnector({
    Key? key,
    Axis? direction,
    double? indent,
    double? endIndent,
    double? space,
  }) : super(
          key: key,
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
        );

  @override
  Widget build(BuildContext context) {
    return _ConnectorIndent(
      direction: getEffectiveDirection(context),
      indent: getEffectiveIndent(context),
      endIndent: getEffectiveEndIndent(context),
      space: getEffectiveSpace(context),
      child: Container(),
    );
  }
}

/// Apply indent to [child].
class _ConnectorIndent extends StatelessWidget {
  /// Creates a indent.
  ///
  /// The [direction]and [child] must be null. And [space], [indent] and
  /// [endIndent] must be null or non-negative.
  const _ConnectorIndent({
    Key? key,
    required this.direction,
    required this.space,
    this.indent,
    this.endIndent,
    required this.child,
  })  : assert(space == null || space >= 0),
        assert(indent == null || indent >= 0),
        assert(endIndent == null || endIndent >= 0),
        super(key: key);

  /// {@macro timelines.direction}
  final Axis direction;

  /// The connector's cross axis size extent.
  ///
  /// The connector itself is always drawn as a line that is centered within the
  /// size specified by this value.
  final double? space;

  /// The amount of empty space to the leading edge of the connector.
  final double? indent;

  /// The amount of empty space to the trailing edge of the connector.
  final double? endIndent;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: direction == Axis.vertical ? space : null,
      height: direction == Axis.vertical ? null : space,
      child: Center(
        child: Padding(
          padding: direction == Axis.vertical
              ? EdgeInsetsDirectional.only(
                  top: indent ?? 0,
                  bottom: endIndent ?? 0,
                )
              : EdgeInsetsDirectional.only(
                  start: indent ?? 0,
                  end: endIndent ?? 0,
                ),
          child: child,
        ),
      ),
    );
  }
}
