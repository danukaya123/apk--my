import 'package:flutter/material.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/download_provider.dart';

class DownloadsManagerScreen extends StatelessWidget {
  const DownloadsManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(title: const Text('Downloads')),
      body: Consumer<DownloadProvider>(
        builder: (context, downloadProvider, child) {
          return ListView(
            children: [
              if (downloadProvider.downloadProgress.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Active Downloads',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ...downloadProvider.downloadProgress.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  subtitle: LinearProgressIndicator(
                    value: entry.value,
                    backgroundColor: AppTheme.surfaceDark,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primary,
                    ),
                  ),
                  trailing: Text('${(entry.value * 100).toStringAsFixed(1)}%'),
                );
              }),
              if (downloadProvider.downloadedVideos.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Completed Downloads',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ...downloadProvider.downloadedVideos.map((video) {
                return ListTile(
                  title: Text(video),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: AppTheme.primary,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
