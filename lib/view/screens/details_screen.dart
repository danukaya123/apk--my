
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/video_provider.dart';
import '../../providers/download_provider.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    final downloadProvider = Provider.of<DownloadProvider>(context);
    final videoInfo = videoProvider.videoInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Details'),
      ),
      body: videoInfo == null
          ? const Center(child: Text('No video info available.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(videoInfo.metadata.thumbnail),
                  const SizedBox(height: 16.0),
                  Text(videoInfo.metadata.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8.0),
                  Text('By ${videoInfo.metadata.author}'),
                  const SizedBox(height: 8.0),
                  Text('${videoInfo.metadata.views?.toString() ?? 'N/A'} views • ${videoInfo.metadata.duration}'),
                  const SizedBox(height: 16.0),
                  Text(videoInfo.metadata.description),
                  const SizedBox(height: 24.0),
                  Text('Downloads', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16.0),
                  _buildDownloadList('MP4', videoInfo.downloads.mp4, context),
                  const SizedBox(height: 16.0),
                  _buildDownloadList('MP3', videoInfo.downloads.mp3, context),
                ],
              ),
            ),
    );
  }

  Widget _buildDownloadList(String title, List<dynamic> formats, BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context, listen: false);
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8.0),
        ...formats.map((format) {
          final isDownloading = downloadProvider.downloadProgress.containsKey(format.filename);
          final progress = isDownloading ? downloadProvider.downloadProgress[format.filename] : null;

          return ListTile(
            title: Text(format.quality),
            subtitle: Text('${(format.size! / 1048576).toStringAsFixed(2)} MB'),
            trailing: isDownloading
                ? SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      downloadProvider.downloadVideo(
                        title.toLowerCase(),
                        format.qualityNumber,
                        videoProvider.videoUrl!,
                        format.filename,
                      );
                    },
                  ),
          );
        }).toList(),
        if (downloadProvider.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              downloadProvider.error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
