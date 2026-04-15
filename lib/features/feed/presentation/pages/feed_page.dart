import 'package:flutter/material.dart';
import 'package:jolu_trip/screens/feed_screen.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key, this.initialLocationId});

  final String? initialLocationId;

  @override
  Widget build(BuildContext context) {
    return FeedScreen(initialLocationId: initialLocationId);
  }
}
