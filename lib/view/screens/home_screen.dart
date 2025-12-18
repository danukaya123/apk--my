import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/completed_download.dart';
import 'package:myapp/providers/download_provider.dart';
import 'package:myapp/view/screens/files_screen.dart';
import 'package:myapp/view/screens/search_screen.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:myapp/view/widgets/recent_download_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        title: const Text(
          'Quizontal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSearchBar(downloadProvider),
            const SizedBox(height: 30),
            _buildSupportedPlatforms(),
            const SizedBox(height: 30),
            _buildRecentDownloadsHeader(context),
            const SizedBox(height: 20),
            Expanded(
              child: _buildGroupedDownloads(downloadProvider.completedDownloads),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(DownloadProvider downloadProvider) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search Downloaded Files',
        hintStyle: const TextStyle(color: AppTheme.textSecondary),
        prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
        filled: true,
        fillColor: AppTheme.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: (query) {
        final searchResults = downloadProvider.completedDownloads.where((
          download,
        ) {
          final title = download.videoInfo.metadata.title;
          return title.toLowerCase().contains(query.toLowerCase());
        }).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(searchResults: searchResults),
          ),
        );
      },
    );
  }

  Widget _buildSupportedPlatforms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Text(
            'Supported Platforms',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPlatformIcon(Icons.play_arrow, 'YouTube'),
            _buildPlatformIcon(Icons.facebook, 'Facebook'),
            _buildPlatformIcon(Icons.music_note, 'TikTok'),
          ],
        ),
      ],
    );
  }

  Widget _buildPlatformIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppTheme.surfaceDark,
          child: Icon(icon, color: AppTheme.primary, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRecentDownloadsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Downloads',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilesScreen()),
            );
          },
          child: const Text(
            'View All',
            style: TextStyle(color: AppTheme.primary),
          ),
        ),
      ],
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
            ...group.downloads.map((download) => RecentDownloadCard(download: download)),
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
