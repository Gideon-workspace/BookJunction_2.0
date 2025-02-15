import 'package:flutter/material.dart';

class CustomPageRoute1 extends PageRouteBuilder{
  final Widget child;

  CustomPageRoute1({
    required this.child,
  }):super(
    pageBuilder:(context,animation,secondaryAnimation)=>child,
  );

  @override
  Widget buildTransitions(BuildContext context,Animation<double>animation,
      Animation<double>secondaryAnimation,Widget child)=>
      ScaleTransition(
          scale: animation,
          child: child
      );
}