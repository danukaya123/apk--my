import 'package:flutter/material.dart';
import 'package:myapp/providers/download_provider.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:provider/provider.dart';

class DownloadManagerScreen extends StatelessWidget {
  const DownloadManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        appBar: AppBar(
          title: const Text('Downloads'),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppTheme.primary,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            tabs: [
              Tab(text: 'Active (${context.watch<DownloadProvider>().activeDownloads.length})'),
              const Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildActiveDownloads(context),
            _buildCompletedDownloads(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveDownloads(BuildContext context) {
    final provider = context.watch<DownloadProvider>();
    if (provider.activeDownloads.isEmpty) {
      return const Center(
        child: Text(
          'No active downloads',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return ListView.builder(
      itemCount: provider.activeDownloads.length,
      itemBuilder: (context, index) {
        final download = provider.activeDownloads[index];
        return ListTile(
          title: Text(download.title, style: const TextStyle(color: Colors.white)),
          subtitle: Text('${(download.totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB', style: const TextStyle(color: AppTheme.textSecondary)),
        );
      },
    );
  }

  Widget _buildCompletedDownloads(BuildContext context) {
    final provider = context.watch<DownloadProvider>();
    if (provider.completedDownloads.isEmpty) {
      return const Center(
        child: Text(
          'No completed downloads',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return ListView.builder(
      itemCount: provider.completedDownloads.length,
      itemBuilder: (context, index) {
        final download = provider.completedDownloads[index];
        return ListTile(
          title: Text(download.title, style: const TextStyle(color: Colors.white)),
          subtitle: Text('${(download.totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB', style: const TextStyle(color: AppTheme.textSecondary)),
        );
      },
    );
  }
}
