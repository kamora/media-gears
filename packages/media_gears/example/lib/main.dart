import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_gears/media_gears.dart';

/// Plays the video whose path is given as the first argument, or the one in MEDIA_GEARS_VIDEO.
void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final path = args.isNotEmpty ? args.first : Platform.environment['MEDIA_GEARS_VIDEO'] ?? '';
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Example(path: path)));
}

class Example extends StatefulWidget {
  const Example({super.key, required this.path});

  final String path;

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    if (widget.path.isNotEmpty) {
      player.open(Media(widget.path));
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.path.isEmpty) {
      return const Scaffold(body: Center(child: Text('Pass a video path as the first argument.')));
    }

    return Scaffold(
      body: Video(controller: controller, controls: MaterialDesktopVideoControls),
    );
  }
}
