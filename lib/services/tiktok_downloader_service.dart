import 'package:dio/dio.dart';
import '../models/video_info.dart';
import 'downloader_service.dart';

class TiktokDownloaderService implements DownloaderService {
  static const String _baseUrl = 'https://tiktok-web-one.vercel.app/api/tiktok';
  final Dio _dio = Dio();

  @override
  Future<VideoInfo> getVideoInfo(String videoUrl) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'action': 'info', 'url': videoUrl},
      );
      if (response.statusCode == 200 && response.data['ok'] == true) {
        return VideoInfo.fromTiktokJson(response.data);
      } else {
        throw Exception(
          response.data['error'] ?? 'Failed to fetch video info',
        );
      }
    } catch (e) {
      throw Exception('Error fetching video info: $e');
    }
  }

  @override
  Future<void> downloadVideo(
    String type,
    String url,
    String filename,
    String savePath, {
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final downloadUrl = await _getDownloadUrl(type, url, filename);
      await _dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  Future<String> _getDownloadUrl(
      String type, String url, String title) async {
    return '$_baseUrl?action=download&url=${Uri.encodeComponent(url)}&type=$type&title=${Uri.encodeComponent(title)}';
  }
}
