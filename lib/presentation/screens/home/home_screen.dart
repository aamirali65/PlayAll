import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playall/presentation/screens/setting/setting_screen.dart';
import '../../../core/constants/app_strings.dart';
import '../../../state/media_provider.dart';
import './folder_detail_screen.dart';
import '../../../data/models/media_file.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isSearching = false;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final folderAsync = ref.watch(mediaFolderProvider);

    return Scaffold(
      appBar: AppBar(
        leading: isSearching
            ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              isSearching = false;
              searchQuery = "";
            });
          },
        )
            : null,
        title: isSearching
            ? TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search songs...',
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 18),
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        )
            : const Text(AppStrings.homeTitle),
        actions: isSearching
            ? [] // Hide icons when searching
            : [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = true;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: folderAsync.when(
        data: (folders) {
          if (folders.isEmpty) {
            return const Center(child: Text('No media found'));
          }

          // flatten files for searching
          final allFiles = folders.values.expand((files) => files).toList();

          if (isSearching && searchQuery.isNotEmpty) {
            // ✅ Show filtered song list only when user typed something
            final filteredFiles = allFiles
                .where((file) => file.title.toLowerCase().contains(searchQuery))
                .toList();

            if (filteredFiles.isEmpty) {
              return const Center(child: Text('No results found'));
            }

            return ListView.builder(
              itemCount: filteredFiles.length,
              itemBuilder: (context, index) {
                final file = filteredFiles[index];
                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(file.title),
                  subtitle: Text(file.path),
                  onTap: () {
                    // TODO: play this file or open player
                  },
                );
              },
            );
          }

          // ✅ Normal folder view (shown in two cases)
          // 1. search is OFF
          // 2. search is ON but query is empty
          final folderNames = folders.keys.toList();

          return ListView.builder(
            itemCount: folderNames.length,
            itemBuilder: (context, index) {
              final folderName = folderNames[index];
              final files = folders[folderName]!;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FolderDetailScreen(
                        folderName: folderName,
                        files: files,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.folder, size: 80),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              folderName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${files.length} media files',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 30),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
