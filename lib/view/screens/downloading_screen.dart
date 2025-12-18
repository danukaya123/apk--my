import 'package:flutter/material.dart';
import 'package:myapp/models/video_info.dart';
import 'package:myapp/providers/download_provider.dart';
import 'package:provider/provider.dart';

class DownloadingScreen extends StatelessWidget {
  final VideoInfo videoInfo;
  const DownloadingScreen({super.key, required this.videoInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Downloading',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<DownloadProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircularProgressIndicator(
                            value: provider.progress,
                            strokeWidth: 20,
                            backgroundColor: Colors.grey.shade800.withOpacity(
                              0.5,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.greenAccent,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: provider.isCompleted
                                  ? _buildCompletedWidget()
                                  : _buildProgressText(provider.progress),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.isCompleted
                                  ? 'Completed'
                                  : 'Downloading',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard(
                        icon: Icons.speed_rounded,
                        value: provider.speed,
                        label: 'Speed',
                      ),
                      _buildInfoCard(
                        icon: Icons.timelapse_rounded,
                        value: provider.remainingTime,
                        label: 'Remaining',
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildFileInfoCard(
                    title: videoInfo.title ?? 'Video File',
                    progress: provider.progress,
                    downloadedSize: provider.downloadedSize,
                    totalSize: provider.totalSize,
                  ),
                  const SizedBox(height: 50),
                  if (!provider.isCompleted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 50),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              provider.isPaused
                                  ? Icons.play_arrow_rounded
                                  : Icons.pause_rounded,
                              color: Colors.black,
                              size: 50,
                            ),
                            onPressed: () {
                              if (provider.isPaused) {
                                provider.resumeDownload();
                              } else {
                                provider.pauseDownload();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressText(double progress) {
    return Text(
      '${(progress * 100).toStringAsFixed(0)}%',
      key: const ValueKey('progress'),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 56,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCompletedWidget() {
    return Container(
      key: const ValueKey('completed'),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.green, width: 3),
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 80),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 35),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFileInfoCard({
    required String title,
    required double progress,
    required String downloadedSize,
    required String totalSize,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  '$downloadedSize / $totalSize',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade600,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.greenAccent,
                  ),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
