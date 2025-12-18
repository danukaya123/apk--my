import 'package:flutter/material.dart';
import 'package:myapp/providers/download_provider.dart';
import 'package:myapp/providers/video_provider.dart';
import 'package:myapp/view/screens/splash_screen.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VideoProvider()),
        ChangeNotifierProvider(create: (context) => DownloadProvider()),
      ],
      child: MaterialApp(
        title: 'YouTube Downloader',
        theme: AppTheme.darkTheme, // Correctly referencing the theme
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
