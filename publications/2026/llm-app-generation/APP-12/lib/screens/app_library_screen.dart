import 'package:flow_launcher/models/smart_folder.dart';
import 'package:flutter/material.dart';

class AppLibraryScreen extends StatefulWidget {
  @override
  _AppLibraryScreenState createState() => _AppLibraryScreenState();
}

class _AppLibraryScreenState extends State<AppLibraryScreen> {
  final List<String> _apps = [
    'App 1', 'App 2', 'App 3',
    'Browser', 'Calculator', 'Calendar',
    'Camera', 'Clock', 'Contacts',
    'Email', 'Facebook', 'Files',
    'Gallery', 'Gmail', 'Google',
    'Maps', 'Messages', 'Music',
    'Phone', 'Photos', 'Play Store',
    'Settings', 'Spotify', 'Twitter',
    'YouTube',
  ];

  final List<SmartFolder> _smartFolders = [
    SmartFolder(name: 'Utilities', apps: ['Calculator', 'Clock', 'Files']),
    SmartFolder(name: 'Shopping', apps: []),
  ];

  final ScrollController _scrollController = ScrollController();

  void _scrollTo(int index) {
    _scrollController.animateTo(
      index * 56.0, // Approximate height of each item
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    _apps.sort();
    return Scaffold(
      appBar: AppBar(
        title: Text('App Library'),
      ),
      body: Row(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Wrap(
                    children: _smartFolders.map((folder) {
                      return ListTile(
                        leading: Icon(Icons.folder),
                        title: Text(folder.name),
                        onTap: () {
                          // TODO: Show apps in folder
                        },
                      );
                    }).toList(),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        leading: Icon(Icons.apps),
                        title: Text(_apps[index]),
                      );
                    },
                    childCount: _apps.length,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 20,
            child: ListView.builder(
              itemCount: 26,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final char = String.fromCharCode(index + 65);
                    final appIndex = _apps.indexWhere((app) => app.toUpperCase().startsWith(char));
                    if (appIndex != -1) {
                      _scrollTo(appIndex);
                    }
                  },
                  child: Text(String.fromCharCode(index + 65)),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}