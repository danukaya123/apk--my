import 'package:flutter/material.dart';
import 'package:myapp/providers/video_provider.dart';
import 'package:myapp/view/screens/details_screen.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 20),
            Text(
              'YouTube Video Downloader',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Download your favorite YouTube videos in any quality.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 50),
            _buildUrlTextField(controller, context),
            const SizedBox(height: 30),
            _buildDownloadButton(context, controller),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlTextField(
    TextEditingController controller,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter YouTube Video URL',
          hintStyle: const TextStyle(color: AppTheme.textSecondary),
          prefixIcon: const Icon(
            Icons.link_rounded,
            color: AppTheme.primary,
            size: 28,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.paste_rounded,
              color: AppTheme.textSecondary,
            ),
            onPressed: () {
              // TODO: Implement paste functionality
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(
    BuildContext context,
    TextEditingController controller,
  ) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: videoProvider.isLoading
            ? null
            : () {
                final url = controller.text.trim();
                if (url.isNotEmpty) {
                  videoProvider.fetchVideoInfo(url).then((_) {
                    if (videoProvider.videoInfo != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailsScreen(),
                        ),
                      );
                    }
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: videoProvider.isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.downloading_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Fetch Video',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
