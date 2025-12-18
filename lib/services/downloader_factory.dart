import 'package:myapp/services/downloader_service.dart';
import 'package:myapp/services/facebook_downloader_service.dart';
import 'package:myapp/services/tiktok_downloader_service.dart';
import 'package:myapp/services/youtube_downloader_service.dart';

class DownloaderFactory {
  static DownloaderService? getDownloader(String url) {
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return YoutubeDownloaderService();
    } else if (url.contains('tiktok.com')) {
      return TiktokDownloaderService();
    } else if (url.contains('facebook.com') || url.contains('fb.watch')) {
      return FacebookDownloaderService();
    } else {
      return null;
    }
  }
}
