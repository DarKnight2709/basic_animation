import 'package:flutter/material.dart';

class Heart extends StatefulWidget {
  const Heart({super.key});

  @override
  _HeartState createState() => _HeartState();
}

// learn more about SingleTickerProviderStateMixin (how it works...)
class _HeartState extends State<Heart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  bool isFav = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    print("this is dispose");
  }

  @override
  void initState() {
    print("hello");
    super.initState();
    
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), 
        //when the heart widget is created on the screen then the controller will be working
        vsync: this
      );

    // make ColorTween become Animation with _controller
    _colorAnimation = ColorTween(begin: Colors.grey[400], end: Colors.red)
        .animate(_controller);
    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double> (
          tween: Tween<double> (begin: 30, end: 50),
          weight: 50
        ),
        TweenSequenceItem<double> (
          tween: Tween<double> (begin: 50, end: 30),
          weight: 50
        ),

      ]
    ).animate(_controller);


    // whenever the value of Controller changes, the inner function will be called
    _controller.addListener(() {
      print(_controller.value);
      print(_colorAnimation.value);
    });

    // when the status of Controller changes, the inner function will be called
    _controller.addStatusListener((status) {
      if(_controller.status == AnimationStatus.completed){
        setState(() {
          isFav = true;
        });
      }
      if(_controller.status == AnimationStatus.dismissed){
        setState(() {
          isFav = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // AnimatiedBuild can replace for setState function in this case
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return IconButton(
            icon: Icon(
              Icons.favorite,
              color: _colorAnimation.value,
              size: _sizeAnimation.value,
            ),
            onPressed: () {
              isFav
              ? _controller.reverse()
              : _controller.forward();
            },
          );
        });
  }
}
