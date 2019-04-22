import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    boxAnimation = Tween(
      begin: pi * 0.60,
      end: pi * 0.65,
    ).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOut,
      ),
    );
    boxController.forward();
    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -50.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation!'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              // buildBox(),
              buildAnimation(),
              buildBox(),
              buildLeftFLap(),
              buildRightFLap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          //margin: EdgeInsets.only(top: catAnimation.value),
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      color: Colors.brown,
      height: 200,
      width: 200,
    );
  }

  Widget buildLeftFLap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          color: Colors.brown,
          height: 10.0,
          width: 125.0,
        ),
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildRightFLap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          color: Colors.brown,
          height: 10.0,
          width: 125.0,
        ),
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.topRight,
            angle: -boxAnimation.value,
            child: child,
          );
        },
      ),
    );
  }
}
