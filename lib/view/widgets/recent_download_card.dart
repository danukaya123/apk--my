import 'package:flutter/material.dart';
import 'package:myapp/models/completed_download.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:open_file/open_file.dart';
import 'dart:developer' as developer;

class RecentDownloadCard extends StatelessWidget {
  final CompletedDownload download;

  const RecentDownloadCard({super.key, required this.download});

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

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    final sizeInMB = bytes / (1024 * 1024);
    return '${sizeInMB.toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final isMp3 = download.filePath.toLowerCase().endsWith('.mp3');
    final quality = isMp3 ? 'MP3' : download.videoInfo.downloads.mp4.first.quality;
    final size = isMp3
        ? download.videoInfo.downloads.mp3.first.size
        : download.videoInfo.downloads.mp4.first.size;

    return GestureDetector(
      onTap: () => _openFile(download.filePath),
      child: Card(
        color: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  download.videoInfo.metadata.thumbnail,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      download.videoInfo.metadata.title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '$quality - ${_formatBytes(size ?? 0)}',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
