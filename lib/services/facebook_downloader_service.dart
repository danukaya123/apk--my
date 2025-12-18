import 'package:dio/dio.dart';
import '../models/video_info.dart';
import 'downloader_service.dart';

class FacebookDownloaderService implements DownloaderService {
  static const String _baseUrl = 'https://fb-web-psi.vercel.app/api';
  final Dio _dio = Dio();

  @override
  Future<VideoInfo> getVideoInfo(String videoUrl) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/fb-info',
        queryParameters: {'q': videoUrl},
      );
      if (response.statusCode == 200 && response.data['ok'] == true) {
        return VideoInfo.fromFacebookJson(response.data);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch video info',
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
    String title,
    String savePath, {
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final downloadUrl = await _getDownloadUrl(url, title);
      await _dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  Future<String> _getDownloadUrl(String url, String title) async {
    return '$_baseUrl/fb-download?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}';
  }
}
