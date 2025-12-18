import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:myapp/models/completed_download.dart';
import 'package:myapp/models/video_info.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class DownloadProvider with ChangeNotifier {
  double _progress = 0;
  bool _isDownloading = false;
  bool _isCompleted = false;
  String _speed = '0 KB/s';
  String _remainingTime = '...';
  int _totalBytes = 0;
  int _receivedBytes = 0;

  final List<CompletedDownload> _completedDownloads = [];

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  DownloadProvider() {
    _loadCompletedDownloads();
  }

  double get progress => _progress;
  bool get isDownloading => _isDownloading;
  bool get isCompleted => _isCompleted;
  String get speed => _speed;
  String get remainingTime => _remainingTime;
  String get totalSize => _formatBytes(_totalBytes);
  String get downloadedSize => _formatBytes(_receivedBytes);
  List<CompletedDownload> get completedDownloads => _completedDownloads;
  bool get isPaused => false;

  Map<String, double> get downloadProgress =>
      _isDownloading ? {'current': _progress} : {};

  Future<void> _loadCompletedDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final downloadsJson = prefs.getStringList('completedDownloads') ?? [];
    _completedDownloads.clear();
    for (final jsonString in downloadsJson) {
      try {
        _completedDownloads.add(CompletedDownload.fromJson(jsonDecode(jsonString)));
      } catch (e) {
        // Handle potential parsing errors
      }
    }
    notifyListeners();
  }

  Future<void> _saveCompletedDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final downloadsJson = _completedDownloads.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList('completedDownloads', downloadsJson);
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  Future<void> startDownload(VideoInfo videoInfo, String format) async {
    _isDownloading = true;
    _isCompleted = false;
    _progress = 0;
    _receivedBytes = 0;
    _totalBytes = 0;
    _speed = '0 KB/s';
    _remainingTime = '...';
    notifyListeners();

    _stopwatch.reset();
    _stopwatch.start();

    final downloads = format == 'mp4' ? videoInfo.downloads.mp4 : videoInfo.downloads.mp3;
    if (downloads.isEmpty) {
      _onDownloadError(Exception('No download links available'));
      return;
    }

    final download = downloads.first;
    if (download.url == null) {
      _onDownloadError(Exception('No download links available'));
      return;
    }

    try {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _calculateSpeedAndRemainingTime();
      });

      await FileDownloader.downloadFile(
        url: download.url!,
        name: download.filename,
        downloadDestination: DownloadDestinations.publicDownloads,
        onProgress: (fileName, progress) {
          _progress = progress / 100;
          _totalBytes = download.size ?? 0;
          _receivedBytes = (_totalBytes * _progress).round();
          notifyListeners();
        },
        onDownloadCompleted: (path) {
          _progress = 1.0;
          _isDownloading = false;
          _isCompleted = true;
          _stopwatch.stop();
          _timer?.cancel();
          _speed = '';
          _remainingTime = '';
          if (_totalBytes > 0) {
            _receivedBytes = _totalBytes;
          }
          _completedDownloads.add(CompletedDownload(
            videoInfo: videoInfo,
            filePath: path,
            downloadedAt: DateTime.now(),
          ));
          _saveCompletedDownloads();
          notifyListeners();
        },
        onDownloadError: (error) {
          _onDownloadError(Exception(error));
        },
      );
    } catch (e) {
      _onDownloadError(e);
    }
  }

  void _onDownloadError(dynamic e) {
    _isDownloading = false;
    _isCompleted = false;
    _stopwatch.stop();
    _timer?.cancel();
    _speed = 'Error';
    _remainingTime = '';
    notifyListeners();
  }

  void _calculateSpeedAndRemainingTime() {
    if (!_isDownloading ||
        _stopwatch.elapsedMilliseconds < 500 ||
        _receivedBytes == 0) {
      return;
    }

    final elapsedSeconds = _stopwatch.elapsed.inSeconds;
    if (elapsedSeconds > 0) {
      final bytesPerSecond = _receivedBytes / elapsedSeconds;
      _speed = '${_formatBytes(bytesPerSecond.toInt())}/s';

      if (bytesPerSecond > 0 && _totalBytes > 0) {
        final remainingBytes = _totalBytes - _receivedBytes;
        final remainingSeconds = remainingBytes / bytesPerSecond;
        _remainingTime = '${remainingSeconds.toInt()}s';
      } else {
        _remainingTime = '...';
      }
    } else {
      _speed = '...';
    }
    notifyListeners();
  }

  void pauseDownload() {}

  void resumeDownload() {}

  void clearHistory() {
    _completedDownloads.clear();
    _saveCompletedDownloads();
    notifyListeners();
  }
}
