import 'package:flutter/material.dart';
import '../models/video_info.dart';
import '../services/api_service.dart';

class VideoProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
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
    _videoUrl = videoUrl; // Store the video URL
    notifyListeners();

    try {
      _videoInfo = await _apiService.fetchVideoInfo(videoUrl);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
