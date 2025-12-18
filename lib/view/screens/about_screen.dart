import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/view/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'About Quizontal',
          style: GoogleFonts.poppins(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.downloading,
                color: AppTheme.primary,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quizontal',
              style: GoogleFonts.oswald(
                color: AppTheme.textPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 36),
            _buildSectionTitle('About the App'),
            const SizedBox(height: 12),
            _buildBodyText(
                'Quizontal is a powerful and intuitive media downloader that allows you to save video content from your favorite social platforms directly to your device for offline viewing. Our mission is to provide a seamless and user-friendly experience for accessing content anytime, anywhere.'),
            const SizedBox(height: 24),
            _buildSectionTitle('How It Works'),
            const SizedBox(height: 12),
            _buildBodyText(
                '1. Find a video on YouTube, Facebook, or TikTok.\n2. Copy the video\'s URL.\n3. Paste the link into the input field in Quizontal.\n4. Choose your desired format and quality.\n5. Your video will be downloaded and saved in the "Files" section of the app.'),
            const SizedBox(height: 24),
            _buildSectionTitle('Supported Platforms'),
            const SizedBox(height: 12),
            _buildBodyText(
                'We currently support downloads from:\n• YouTube\n• Facebook\n• TikTok'),
            const SizedBox(height: 24),
            _buildSectionTitle('Legal Disclaimer & License'),
            const SizedBox(height: 12),
            _buildBodyText(
                'Quizontal should only be used to download content that is non-copyrighted or for which you have explicit permission from the copyright holder. Users are solely responsible for complying with the terms of service of the platforms they download from and for respecting intellectual property rights.\n\nUnauthorized downloading and distribution of copyrighted material is strictly prohibited. Please use Quizontal responsibly and ethically. This application is distributed under the MIT License.'),
            const SizedBox(height: 48),
            Text(
              'Developed by Danuka Dissanayake.',
              style: GoogleFonts.poppins(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.oswald(
        color: AppTheme.primary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 15,
        height: 1.6,
      ),
    );
  }
}
