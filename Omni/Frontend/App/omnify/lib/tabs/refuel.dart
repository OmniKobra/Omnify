import 'package:flutter/material.dart';

class Refuel extends StatefulWidget {
  const Refuel({super.key});

  @override
  State<Refuel> createState() => _RefuelState();
}

class _RefuelState extends State<Refuel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const Text("REFUEL"),
    );
  }
}
