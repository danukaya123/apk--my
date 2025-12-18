import 'package:dio/dio.dart';
import '../models/video_info.dart';

class ApiService {
  static const String _baseUrl = 'https://yt-web-six.vercel.app/api/api';
  final Dio _dio = Dio();

  Future<VideoInfo> fetchVideoInfo(String videoUrl) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'action': 'info', 'q': videoUrl},
      );
      if (response.statusCode == 200 && response.data['ok'] == true) {
        return VideoInfo.fromJson(response.data);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch video info',
        );
      }
    } catch (e) {
      throw Exception('Error fetching video info: $e');
    }
  }

  Future<String> getDownloadUrl(
    String type,
    int quality,
    String q,
    String filename,
  ) async {
    try {
      final downloadUrlResponse = await _dio.get(
        _baseUrl,
        queryParameters: {
          'action': 'download',
          'type': type,
          'quality': quality,
          'q': q,
        },
      );

      if (downloadUrlResponse.statusCode == 200 &&
          downloadUrlResponse.data['ok'] == true) {
        final downloadUrl = downloadUrlResponse.data['url'];
        final proxyUrl =
            '$_baseUrl?action=proxy&url=${Uri.encodeComponent(downloadUrl)}&filename=${Uri.encodeComponent(filename)}';
        return proxyUrl;
      } else {
        throw Exception(
          'Failed to get download URL: ${downloadUrlResponse.data['message']}',
        );
      }
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  Future<void> downloadVideo(
    String type,
    int quality,
    String q,
    String savePath, {
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final downloadUrl = await getDownloadUrl(
        type,
        quality,
        q,
        savePath.split('/').last,
      );

      await _dio.download(
        downloadUrl,
        savePath, // Use the provided savePath directly
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': '*/*',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
          },
        ),
      );
    } catch (e) {
      if (e is DioException) {
        throw Exception(
          'Download failed: ${e.response?.data['message'] ?? e.message}',
        );
      }
      throw Exception('Download failed: $e');
    }
  }
}
