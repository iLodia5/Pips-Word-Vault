import 'package:flutter/material.dart';

class SpriteAnimation extends StatefulWidget {
  final ImageProvider image;
  final int columns;
  final int rows;
  final int totalFrames;
  final Duration duration;
  final bool loop;
  final VoidCallback? onCompleted;
  final double? width;
  final double? height;
  
  const SpriteAnimation({
    Key? key,
    required this.image,
    required this.columns,
    required this.rows,
    required this.totalFrames,
    required this.duration,
    this.loop = false,
    this.onCompleted,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<SpriteAnimation> createState() => _SpriteAnimationState();
}

class _SpriteAnimationState extends State<SpriteAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _frameAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _frameAnimation = IntTween(begin: 0, end: widget.totalFrames - 1).animate(_controller);

    if (widget.loop) {
      _controller.repeat();
    } else {
      _controller.forward().then((_) {
        widget.onCompleted?.call();
      });
    }
  }

  @override
  void didUpdateWidget(SpriteAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image || 
        widget.columns != oldWidget.columns || 
        widget.rows != oldWidget.rows || 
        widget.totalFrames != oldWidget.totalFrames) {
      _frameAnimation = IntTween(begin: 0, end: widget.totalFrames - 1).animate(_controller);
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      if (_controller.isAnimating) {
        if (widget.loop) {
          _controller.repeat();
        } else {
          _controller.forward();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _frameAnimation,
      builder: (context, child) {
        final int frameIndex = _frameAnimation.value;
        final int col = frameIndex % widget.columns;
        final int row = frameIndex ~/ widget.columns;
        
        final double alignX = widget.columns > 1 ? (col / (widget.columns - 1)) * 2 - 1 : 0.0;
        final double alignY = widget.rows > 1 ? (row / (widget.rows - 1)) * 2 - 1 : 0.0;

        Widget sprite = FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
          child: ClipRect(
            child: Align(
              alignment: Alignment(alignX, alignY),
              widthFactor: 1.0 / widget.columns,
              heightFactor: 1.0 / widget.rows,
              child: Image(
                image: widget.image,
                fit: BoxFit.none,
                gaplessPlayback: true,
              ),
            ),
          ),
        );

        if (widget.width != null || widget.height != null) {
          sprite = SizedBox(
            width: widget.width,
            height: widget.height,
            child: sprite,
          );
        }

        return sprite;
      },
    );
  }
}
