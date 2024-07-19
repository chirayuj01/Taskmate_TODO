import 'dart:async';
import 'package:flutter/material.dart';
import 'package:TaskMate/main.dart';

class TaskSplasher extends StatefulWidget {
  const TaskSplasher({super.key});

  @override
  State<TaskSplasher> createState() => _TaskSplasherState();
}

class _TaskSplasherState extends State<TaskSplasher> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Start the opacity animation
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to the next page with a slower slide transition after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 820), // Adjust the duration here
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff0acffe),
            Color(0xff495aff),
          ]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 3),
                child: Image.asset('assets/images/logo_todo.png'),
              ),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 3),
                child: const Text(
                  'TaskMate',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Playwrite',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
