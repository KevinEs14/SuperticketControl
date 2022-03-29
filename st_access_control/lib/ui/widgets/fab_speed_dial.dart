import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FabSpeedDial extends StatefulWidget {
  final List<SpeedDialModel> list;

  const FabSpeedDial({Key key, @required this.list}) : super(key: key);

  @override
  _FabSpeedDialState createState() => _FabSpeedDialState();
}

class _FabSpeedDialState extends State<FabSpeedDial> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.list.length, (int index) {
        Widget child = Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(
                  0.0,
                  1.0 - index / widget.list.length / 2.0,
                  curve: Curves.easeOut
              ),
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: true,
              child: Icon(widget.list[index].icon, color: foregroundColor),
              onPressed: (){
                Navigator.of(context).pushNamed(widget.list[index].route);
              },
            ),
          ),
        );
        return child;
      }).toList()..add(
        FloatingActionButton(
          heroTag: null,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Transform(
                transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                alignment: FractionalOffset.center,
                child: Icon(_controller.isDismissed ? Icons.add : Icons.close),
              );
            },
          ),
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
        ),
      ),
    );
  }
}


class SpeedDialModel extends Equatable {
  final IconData icon;
  final String route;

  SpeedDialModel({
    @required this.icon,
    @required this.route,
  });

  @override
  List<Object> get props => [icon, route];

  @override
  String toString() => 'SpeedDialModel {icon:$icon, onPressed:$route}';

  SpeedDialModel copyWith({
    IconData icon,
    String onPressed,
  }) {
    return SpeedDialModel(
      icon: icon ?? this.icon,
      route: onPressed ?? this.route,
    );
  }
}