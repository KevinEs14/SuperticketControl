import 'package:flutter/material.dart';

class TicketTopVerticalBorder extends ShapeBorder{
  final double radius;

  const TicketTopVerticalBorder({
    this.radius: 8.0,
  })
      : assert(radius != null);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only();

  @override
  ShapeBorder scale(double t) {
    return TicketTopVerticalBorder(
      radius: radius * (t),
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    double _radius = radius;
    return Path()
      ..moveTo(rect.left, rect.top+_radius)
      ..lineTo(rect.left, rect.bottom - _radius)
      ..arcToPoint(Offset(rect.left+_radius, rect.bottom), radius: Radius.circular(_radius), clockwise: true)
      ..lineTo(rect.right-_radius, rect.bottom)
      ..arcToPoint(Offset(rect.right, rect.bottom-_radius), radius: Radius.circular(_radius), clockwise: true)
      ..lineTo(rect.right, rect.top+_radius)
      ..arcToPoint(Offset(rect.right-_radius, rect.top), radius: Radius.circular(_radius), clockwise: false)
      ..lineTo(rect.left+_radius, rect.top)
      ..arcToPoint(Offset(rect.left, rect.top+_radius), radius: Radius.circular(_radius), clockwise: false)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}
}

class TicketBottomVerticalBorder extends ShapeBorder{
  final double radius;

  const TicketBottomVerticalBorder({
    this.radius: 8.0,
  })
      : assert(radius != null);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only();

  @override
  ShapeBorder scale(double t) {
    return TicketTopVerticalBorder(
      radius: radius * (t),
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    double _radius = radius;
    return Path()
      ..moveTo(rect.left, rect.top+_radius)
      ..lineTo(rect.left, rect.bottom - _radius)
      ..arcToPoint(Offset(rect.left+_radius, rect.bottom), radius: Radius.circular(_radius), clockwise: false)
      ..lineTo(rect.right-_radius, rect.bottom)
      ..arcToPoint(Offset(rect.right, rect.bottom-_radius), radius: Radius.circular(_radius), clockwise: false)
      ..lineTo(rect.right, rect.top+_radius)
      ..arcToPoint(Offset(rect.right-_radius, rect.top), radius: Radius.circular(_radius), clockwise: true)
      ..lineTo(rect.left+_radius, rect.top)
      ..arcToPoint(Offset(rect.left, rect.top+_radius), radius: Radius.circular(_radius), clockwise: true)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}
}