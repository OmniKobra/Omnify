import 'package:flutter/material.dart';

class MyLoading extends StatefulWidget {
  const MyLoading({super.key});

  @override
  State<MyLoading> createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoading> {
  @override
  Widget build(BuildContext context) => Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                        backgroundColor:
                            Theme.of(context).colorScheme.primary)))
          ]);
}
