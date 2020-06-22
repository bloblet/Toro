import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class AnimatedSlide extends StatefulWidget {
  final Widget oldPage;
  final Widget page;

  const AnimatedSlide({Key key, this.oldPage, this.page}) : super(key: key);

  @override
  _AnimatedSlideState createState() => _AnimatedSlideState();
}

class _AnimatedSlideState extends State<AnimatedSlide>
    with TickerProviderStateMixin {
  AnimationController controller;
  SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    super.initState();
    final GlobalKey key = widget.oldPage.key;

    controller = AnimationController(vsync: this);
    final RenderBox fabRenderBox =
       key.currentContext.findRenderObject();
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<Offset>(
            begin: fabOffset,
            end: MediaQuery.of(context).size.topRight(fabOffset),
          ),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 300),
          curve: Curves.easeInOutExpo,
          tag: 'moveToTopRight',
        )
        .addAnimatable(
          animatable: Tween<Size>(
              begin: fabSize,
              end: MediaQuery.of(key.currentContext).size),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 300),
          curve: Curves.easeInOutExpo,
          tag: 'scale',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 1, end: 0),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 300),
          curve: Curves.slowMiddle,
          tag: 'fadeOut',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 1),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 300),
          curve: Curves.slowMiddle,
          tag: 'fadeIn',
        )
        .addAnimatable(
          animatable: Tween<BorderRadius>(
              begin: BorderRadius.circular(10), end: BorderRadius.zero),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 300),
          curve: Curves.slowMiddle,
          tag: 'borderRadius',
        )
        .animate(controller);
  }

  Widget positionedClippedChild(Widget child) {
    return Positioned(
      width: sequenceAnimation['scale'].value.width,
      height: sequenceAnimation['scale'].value.height,
      left: sequenceAnimation['moveToTopRight'].value.dx,
      top: sequenceAnimation['moveToTopRight'].value.dy,
      child: ClipRRect(
        borderRadius: sequenceAnimation['borderRadius'].value,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: sequenceAnimation['fadeOut'].value,
          child: positionedClippedChild(widget.oldPage),
        ),
        Opacity(
          opacity: sequenceAnimation['fadeIn'].value,
          child: positionedClippedChild(widget.page),
        ),
      ],
    );
  }
}
