import 'package:flutter/material.dart';
import 'package:myapp/models/video_info.dart';
import 'package:myapp/providers/download_provider.dart';
import 'package:myapp/view/screens/download_manager_screen.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:provider/provider.dart';

class DownloadingScreen extends StatelessWidget {
  final VideoInfo videoInfo;
  const DownloadingScreen({super.key, required this.videoInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Downloading'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Consumer<DownloadProvider>(
                  builder: (context, provider, child) {
                    if (!provider.isDownloading) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DownloadManagerScreen(),
                          ),
                        );
                      });
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    height: 250,
                                    child: CircularProgressIndicator(
                                      value: provider.progress / 100,
                                      strokeWidth: 15,
                                      backgroundColor: AppTheme.surfaceDark,
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppTheme.primary,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${provider.progress.toStringAsFixed(0)}%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        'Downloading',
                                        style: TextStyle(color: AppTheme.textSecondary),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildInfoCard(context, Icons.speed_rounded, provider.speed, 'Speed'),
                                _buildInfoCard(context, Icons.timer_rounded, provider.remainingTime, 'Remaining'),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            children: [
                              _buildFileCard(context, provider),
                              const SizedBox(height: 40),
                              _buildControls(context),
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primary, size: 28),
          const SizedBox(height: 10),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildFileCard(BuildContext context, DownloadProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videoInfo.metadata.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text('${(provider.receivedBytes / (1024 * 1024)).toStringAsFixed(2)} MB / ${(provider.totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB', style: const TextStyle(color: AppTheme.textSecondary)),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: provider.progress / 100,
                  backgroundColor: AppTheme.backgroundDark,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.textSecondary, width: 2),
          ),
          child: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary, size: 30),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 30),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primary,
          ),
          child: IconButton(
            icon: const Icon(Icons.pause_rounded, color: Colors.black, size: 40),
            onPressed: () {},
            iconSize: 40,
          ),
        ),
      ],
    );
  }
}
