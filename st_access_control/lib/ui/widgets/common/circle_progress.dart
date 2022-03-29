import 'package:flutter/material.dart';

import '../../values/colors.dart';

const double _kCircularColorChangeDelay = 12.0;
const double _kCircularColorChangeDuration = 2.0;

TweenSequenceItem<Color> _tweenSequenceItem(double w, Color c1, Color c2) {
  return TweenSequenceItem(
    weight: w,
    tween: ColorTween(
      begin: c1,
      end: c2,
    ),
  );
}

final Animatable<Color> circularTweenSequence = TweenSequence<Color>([
  _tweenSequenceItem(_kCircularColorChangeDelay, colorSecondary, colorSecondary),
  _tweenSequenceItem(_kCircularColorChangeDuration, colorSecondary, colorAccent),
  _tweenSequenceItem(_kCircularColorChangeDelay, colorAccent, colorAccent),
  _tweenSequenceItem(_kCircularColorChangeDuration, colorAccent, colorSecondary),
]);

class CircleProgress extends StatefulWidget {
  final bool center;

  const CircleProgress({Key key, this.center:true}) : super(key: key);

  @override
  _CircleProgressState createState() => _CircleProgressState();
}

class _CircleProgressState extends State<CircleProgress> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animatable<Color> _tweenSequence = circularTweenSequence;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2666), //1333*(qty colors)
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.center){
      return Center(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CircularProgressIndicator(
                key: widget.key,
                valueColor: AlwaysStoppedAnimation<Color>(_tweenSequence.evaluate(_controller)),
                strokeWidth: 3,
              );
            }),
      );
    } else {
      return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CircularProgressIndicator(
              key: widget.key,
              valueColor: AlwaysStoppedAnimation<Color>(_tweenSequence.evaluate(_controller)),
              strokeWidth: 3,
            );
          });
    }
  }
}
