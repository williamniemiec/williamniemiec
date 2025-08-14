import 'package:flutter/material.dart';

class SoundSelectionPanel extends StatelessWidget {
  final List<String> sounds = [
    'Kick 808',
    'Snare Vintage',
    'Hi-Hat Crisp',
    'Open Hat',
    'Clap',
    'Cowbell',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.grey[800],
      child: ListView.builder(
        itemCount: sounds.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              sounds[index],
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle sound selection
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}