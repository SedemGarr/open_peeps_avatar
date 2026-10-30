import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_peeps_avatar/open_peeps_avatar.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Peeps Avatar',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _avatar = const AvatarLook(
    head: 0,
    face: 0,
    facialHair: 0,
    accessory: 0,
  ).shuffled(Random()).encode();
  List<int> _saved = [];

  void _openStudio() {
    showPeepStudio(
      context: context,
      studio: PeepStudio(
        initial: _avatar,
        onClose: (code) => setState(() => _avatar = code),
        savedLooks: _saved,
        onSavedLooksChanged: (looks) => _saved = looks,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Peeps Avatar')),
      body: Center(
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            PeepSticker(avatar: _avatar, size: 96, animate: true),
            PeepSticker(avatar: _avatar, size: 64, prop: AvatarProp.crown),
            PeepCard(avatar: _avatar, width: 160),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openStudio,
        icon: const Icon(Icons.edit),
        label: const Text('Customise'),
      ),
    );
  }
}
