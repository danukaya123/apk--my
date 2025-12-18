import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/completed_download.dart';
import 'package:myapp/providers/download_provider.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:myapp/view/widgets/recent_download_card.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:developer' as developer;

class FilesScreen extends StatelessWidget {
  const FilesScreen({super.key});

  Future<void> _openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        developer.log('Error opening file: ${result.message}', name: 'OpenFile');
      }
    } catch (e) {
      developer.log('Error opening file: $e', name: 'OpenFile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        title: const Text('My Files', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: downloadProvider.completedDownloads.isEmpty
          ? const Center(
              child: Text(
                'No downloads yet.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
            )
          : _buildGroupedDownloads(downloadProvider.completedDownloads),
    );
  }

  Widget _buildGroupedDownloads(List<CompletedDownload> downloads) {
    if (downloads.isEmpty) {
      return const Center(
        child: Text(
          'No downloads yet!',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      );
    }

    final groupedDownloads = _groupDownloadsByTime(downloads);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      itemCount: groupedDownloads.length,
      itemBuilder: (context, index) {
        final group = groupedDownloads[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                group.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ...group.downloads.map((download) => 
              GestureDetector(
                onTap: () => _openFile(download.filePath),
                child: RecentDownloadCard(download: download),
              ),
            )
          ],
        );
      },
    );
  }

  List<_DownloadGroup> _groupDownloadsByTime(List<CompletedDownload> downloads) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final startOfWeek = today.subtract(Duration(days: now.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);

    final groups = <String, List<CompletedDownload>>{
      'Today': [],
      'Yesterday': [],
      'This Week': [],
      'This Month': [],
    };
    final pastMonths = <String, List<CompletedDownload>>{};

    for (final download in downloads) {
      final downloadedDate = DateTime(
        download.downloadedAt.year,
        download.downloadedAt.month,
        download.downloadedAt.day,
      );

      if (downloadedDate.isAtSameMomentAs(today)) {
        groups['Today']!.add(download);
      } else if (downloadedDate.isAtSameMomentAs(yesterday)) {
        groups['Yesterday']!.add(download);
      } else if (downloadedDate.isAfter(startOfWeek)) {
        groups['This Week']!.add(download);
      } else if (download.downloadedAt.isAfter(startOfMonth)) {
        groups['This Month']!.add(download);
      } else {
        final monthYear = DateFormat('MMMM yyyy').format(download.downloadedAt);
        if (!pastMonths.containsKey(monthYear)) {
          pastMonths[monthYear] = [];
        }
        pastMonths[monthYear]!.add(download);
      }
    }

    final result = <_DownloadGroup>[];
    groups.forEach((title, downloads) {
      if (downloads.isNotEmpty) {
        result.add(_DownloadGroup(title, downloads));
      }
    });

    pastMonths.forEach((title, downloads) {
      result.add(_DownloadGroup(title, downloads));
    });

    return result;
  }
}

class _DownloadGroup {
  final String title;
  final List<CompletedDownload> downloads;

  _DownloadGroup(this.title, this.downloads);
}
