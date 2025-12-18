import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/providers/download_provider.dart';
import 'package:myapp/view/screens/downloading_screen.dart';
import 'package:myapp/view/screens/video_player_screen.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/video_provider.dart';
import '../../models/video_info.dart';

// Helper Functions
String _formatViews(int? views) {
  if (views == null) return 'N/A';
  return NumberFormat.compact().format(views);
}

String _formatSize(int? bytes) {
  if (bytes == null || bytes == 0) return '0 MB';
  final mb = bytes / 1048576;
  return '${mb.toStringAsFixed(0)} MB';
}

IconData _getQualityIcon({required bool isAudio}) {
  if (isAudio) {
    return Icons.audiotrack_rounded;
  } else {
    return Icons.videocam_rounded;
  }
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String _selectedFormat = 'video';
  DownloadFormat? _selectedQuality;

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    final videoInfo = videoProvider.videoInfo;
    final downloadProvider = Provider.of<DownloadProvider>(
      context,
      listen: false,
    );

    if (videoInfo == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text(
            'Could not load video information.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          VideoThumbnail(videoInfo: videoInfo),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundDark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    VideoDetails(videoInfo: videoInfo),
                    const SizedBox(height: 30),
                    FormatSelector(
                      selectedFormat: _selectedFormat,
                      onFormatSelected: (format) {
                        setState(() {
                          _selectedFormat = format;
                          _selectedQuality = null;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'QUALITY',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (_selectedFormat == 'video')
                      QualitySelectionList(
                        formats: videoInfo.downloads.mp4,
                        selectedQuality: _selectedQuality,
                        onQualitySelected: (quality) {
                          setState(() {
                            _selectedQuality = quality;
                          });
                        },
                      ),
                    if (_selectedFormat == 'audio')
                      QualitySelectionList(
                        formats: videoInfo.downloads.mp3,
                        isAudio: true,
                        selectedQuality: _selectedQuality,
                        onQualitySelected: (quality) {
                          setState(() {
                            _selectedQuality = quality;
                          });
                        },
                      ),
                    const SizedBox(height: 90),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: DownloadButton(
              selectedQuality: _selectedQuality,
              onPressed: () {
                if (_selectedQuality != null && _selectedQuality!.url != null) {
                  downloadProvider.downloadFile(
                    _selectedQuality!.url!,
                    _selectedQuality!.filename,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DownloadingScreen(videoInfo: videoInfo),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoThumbnail extends StatelessWidget {
  final VideoInfo videoInfo;

  const VideoThumbnail({super.key, required this.videoInfo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (videoInfo.metadata.thumbnail.isNotEmpty)
            Image.network(
              // Simple improvement: Always load medium quality instead of default
              videoInfo.metadata.thumbnail.replaceAll(
                'default.jpg',
                'hqdefault.jpg',
              ),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                // Fall back to default if medium quality fails
                return Image.network(
                  videoInfo.metadata.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.backgroundDark.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                onPressed: () {
                  // TODO: Implement share
                },
              ),
            ),
          ),
          Center(
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  final videoUrl = videoInfo.downloads.mp4.first.url;
                  if (videoUrl != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerScreen(videoUrl: videoUrl),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoDetails extends StatelessWidget {
  final VideoInfo videoInfo;

  const VideoDetails({super.key, required this.videoInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          videoInfo.metadata.title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            const CircleAvatar(radius: 12, backgroundColor: Colors.grey),
            const SizedBox(width: 10),
            Text(
              videoInfo.metadata.author,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.primary,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            const Icon(
              Icons.visibility_rounded,
              color: AppTheme.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              '${_formatViews(videoInfo.metadata.views)} Views',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 20),
            const Icon(
              Icons.timer_rounded,
              color: AppTheme.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              videoInfo.metadata.duration,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          'Show Description',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class FormatSelector extends StatelessWidget {
  final String selectedFormat;
  final Function(String) onFormatSelected;

  const FormatSelector({
    super.key,
    required this.selectedFormat,
    required this.onFormatSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFormatButton(
              context,
              'video',
              'Video (MP4)',
              Icons.videocam_rounded,
            ),
          ),
          Expanded(
            child: _buildFormatButton(
              context,
              'audio',
              'Audio (MP3)',
              Icons.headset_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton(
    BuildContext context,
    String format,
    String label,
    IconData icon,
  ) {
    final isSelected = selectedFormat == format;
    return GestureDetector(
      onTap: () => onFormatSelected(format),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QualitySelectionList extends StatelessWidget {
  final List<DownloadFormat> formats;
  final DownloadFormat? selectedQuality;
  final Function(DownloadFormat) onQualitySelected;
  final bool isAudio;

  const QualitySelectionList({
    super.key,
    required this.formats,
    required this.selectedQuality,
    required this.onQualitySelected,
    this.isAudio = false,
  });

  @override
  Widget build(BuildContext context) {
    // Sort formats from highest quality to lowest
    final sortedFormats = List<DownloadFormat>.from(formats)
      ..sort((a, b) => b.qualityNumber.compareTo(a.qualityNumber));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedFormats.length,
      itemBuilder: (context, index) {
        final format = sortedFormats[index];
        final isSelected = selectedQuality == format;
        final qualityLabel = isAudio ? 'MP3' : format.quality;

        return GestureDetector(
          onTap: () => onQualitySelected(format),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary.withOpacity(0.1)
                  : AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? AppTheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.surfaceDark.withOpacity(0.5),
                  child: Icon(
                    _getQualityIcon(isAudio: isAudio),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        qualityLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (index == 0 && !isAudio)
                        const Text(
                          'Recommended',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Flexible(
                  child: Text(
                    _formatSize(format.size),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primary, width: 2),
                    color: isSelected ? AppTheme.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.black, size: 16)
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DownloadButton extends StatelessWidget {
  final DownloadFormat? selectedQuality;
  final VoidCallback onPressed;

  const DownloadButton({
    super.key,
    required this.selectedQuality,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = selectedQuality != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        boxShadow: [
          BoxShadow(
            color: AppTheme.backgroundDark,
            spreadRadius: 20,
            blurRadius: 20,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: isEnabled ? AppTheme.primary : AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download_rounded, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              'Download (${_formatSize(selectedQuality?.size)})',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
