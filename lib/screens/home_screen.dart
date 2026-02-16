import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.callbackTheme});

  final VoidCallback callbackTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TEXT', style: Theme.of(context).textTheme.bodyLarge),
            IconButton(
              onPressed: callbackTheme,
              icon: Icon(Icons.abc, color: Theme.of(context).focusColor),
            ),
          ],
        ),
      ),
    );
  }
}
