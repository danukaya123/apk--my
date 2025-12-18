
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/download_provider.dart';
import '../widgets/download_item.dart';

class DownloadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: Consumer<DownloadProvider>(
        builder: (context, provider, child) {
          if (provider.downloadProgress.isEmpty && provider.downloadedVideos.isEmpty) {
            return const Center(
              child: Text('No active downloads.'),
            );
          }

          return ListView(
            children: [
              if (provider.downloadProgress.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Downloading', style: Theme.of(context).textTheme.titleLarge),
                ),
              ...provider.downloadProgress.entries.map((entry) {
                return DownloadItem(
                  title: entry.key,
                  subtitle: 'Downloading...',
                  progress: entry.value,
                );
              }),
              if (provider.downloadedVideos.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Downloaded', style: Theme.of(context).textTheme.titleLarge),
                ),
              ...provider.downloadedVideos.map((filename) {
                return DownloadItem(
                  title: filename,
                  subtitle: 'Downloaded',
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
