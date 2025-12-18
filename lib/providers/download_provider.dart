
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import '../services/api_service.dart';

class DownloadProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Map<String, double> _downloadProgress = {};
  final List<String> _downloadedVideos = [];
  String? _error;

  Map<String, double> get downloadProgress => _downloadProgress;
  List<String> get downloadedVideos => _downloadedVideos;
  String? get error => _error;

  Future<void> downloadVideo(String type, int quality, String q, String filename) async {
    _downloadProgress[filename] = 0.0;
    _error = null;
    notifyListeners();

    try {
      final url = await _apiService.getDownloadUrl(type, quality, q, filename);

      FileDownloader.downloadFile(
        url: url,
        name: filename,
        onProgress: (name, progress) {
            _downloadProgress[filename] = progress / 100;
            notifyListeners();
        },
        onDownloadCompleted: (path) {
           _downloadedVideos.add(filename);
          _error = null;
          _downloadProgress.remove(filename);
          notifyListeners();
        },
         onDownloadError: (error) {
            _error = 'Error downloading video: $error';
             _downloadProgress.remove(filename);
            notifyListeners();
        }
      );
    } catch (e) {
      _error = 'Error downloading video: ${e.toString()}';
       _downloadProgress.remove(filename);
      notifyListeners();
    }
  }
}
