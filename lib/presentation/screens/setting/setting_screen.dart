import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text("Player"),
              onTap: () {
                // handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text("Audio"),
              onTap: () {
                // handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.subtitles),
              title: const Text("Subtitle"),
              onTap: () {
                // handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text("Theme"),
              onTap: () {
                // handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("App Language"),
              onTap: () {
                // handle tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
