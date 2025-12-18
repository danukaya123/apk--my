import '../models/video_info.dart';

abstract class DownloaderService {
  Future<VideoInfo> getVideoInfo(String videoUrl);

  Future<void> downloadVideo(
    String type,
    String url,
    String filename,
    String savePath, {
    Function(int, int)? onReceiveProgress,
  });
}
