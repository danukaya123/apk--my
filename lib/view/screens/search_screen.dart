import 'package:flutter/material.dart';
import 'package:myapp/models/completed_download.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:myapp/view/widgets/recent_download_card.dart';

class SearchScreen extends StatelessWidget {
  final List<CompletedDownload> searchResults;

  const SearchScreen({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        title: Text('Search Results (${searchResults.length})'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: searchResults.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No search results found!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Check your search terms and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final download = searchResults[index];
                  return RecentDownloadCard(download: download);
                },
              ),
      ),
    );
  }
}
