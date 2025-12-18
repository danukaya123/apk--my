import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:myapp/services/downloader_factory.dart';
import '../models/video_info.dart';

class VideoProvider with ChangeNotifier {
  VideoInfo? _videoInfo;
  String? _videoUrl;
  String? _error;
  bool _isLoading = false;

  VideoInfo? get videoInfo => _videoInfo;
  String? get videoUrl => _videoUrl;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> fetchVideoInfo(String videoUrl) async {
    _isLoading = true;
    _error = null;
    _videoUrl = videoUrl;
    notifyListeners();

    try {
      final downloader = DownloaderFactory.getDownloader(videoUrl);
      if (downloader == null) {
        throw Exception('Unsupported video URL');
      }
      var videoInfo = await downloader.getVideoInfo(videoUrl);
      _videoInfo = await _fetchFileSizes(videoInfo);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<VideoInfo> _fetchFileSizes(VideoInfo videoInfo) async {
    final dio = Dio();
    List<DownloadFormat> updatedMp4 = [];
    List<DownloadFormat> updatedMp3 = [];

    for (var format in videoInfo.downloads.mp4) {
      if (format.url != null) {
        try {
          final response = await dio.head(format.url!);
          final size = int.tryParse(
            response.headers.value('content-length') ?? '0',
          );
          updatedMp4.add(format.copyWith(size: size));
        } catch (e) {
          updatedMp4.add(format.copyWith(size: null));
        }
      } else {
        updatedMp4.add(format.copyWith(size: null));
      }
    }

    for (var format in videoInfo.downloads.mp3) {
      if (format.url != null) {
        try {
          final response = await dio.head(format.url!);
          final size = int.tryParse(
            response.headers.value('content-length') ?? '0',
          );
          updatedMp3.add(format.copyWith(size: size));
        } catch (e) {
          updatedMp3.add(format.copyWith(size: null));
        }
      } else {
        updatedMp3.add(format.copyWith(size: null));
      }
    }

    return videoInfo.copyWith(
      downloads: videoInfo.downloads.copyWith(
        mp4: updatedMp4,
        mp3: updatedMp3,
      ),
    );
  }
}
