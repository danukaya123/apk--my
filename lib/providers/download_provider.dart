import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:dio/dio.dart';

class DownloadProvider with ChangeNotifier {
  double _progress = 0;
  bool _isDownloading = false;
  bool _isCompleted = false;
  String _speed = '0 KB/s';
  String _remainingTime = '...';
  int _totalBytes = 0;
  int _receivedBytes = 0;

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  double get progress => _progress;
  bool get isDownloading => _isDownloading;
  bool get isCompleted => _isCompleted;
  String get speed => _speed;
  String get remainingTime => _remainingTime;
  String get totalSize => _formatBytes(_totalBytes);
  String get downloadedSize => _formatBytes(_receivedBytes);
  bool get isPaused => false; // Pausing is not implemented

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  void downloadFile(String url, String filename) {
    startDownload(filename, url);
  }

  Future<void> startDownload(String title, String url) async {
    _isDownloading = true;
    _isCompleted = false;
    _progress = 0;
    _receivedBytes = 0;
    _totalBytes = 0;
    _speed = '0 KB/s';
    _remainingTime = '...';
    notifyListeners(); // Notify UI that we are starting

    _stopwatch.reset();
    _stopwatch.start();

    try {
      final dio = Dio();
      final response = await dio.head(url);
      if (response.statusCode == 200) {
        _totalBytes = int.parse(
          response.headers.value('content-length') ?? '0',
        );
      }
    } catch (e) {
      print("Error getting file size: $e");
      // Continue without total size, some features will be disabled
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _calculateSpeedAndRemainingTime();
    });

    FileDownloader.downloadFile(
      url: url,
      name: title,
      onProgress: (fileName, progress) {
        _progress = progress / 100;
        if (_totalBytes > 0) {
          _receivedBytes = (_totalBytes * _progress).toInt();
        }
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
        notifyListeners();
      },
      onDownloadError: (error) {
        _isDownloading = false;
        _isCompleted = false;
        _stopwatch.stop();
        _timer?.cancel();
        _speed = 'Error';
        _remainingTime = '';
        notifyListeners();
      },
    );
  }

  void _calculateSpeedAndRemainingTime() {
    if (!_isDownloading ||
        _stopwatch.elapsedMilliseconds < 500 ||
        _receivedBytes == 0)
      return;

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

  void pauseDownload() {
    // Not implemented
    notifyListeners();
  }

  void resumeDownload() {
    // Not implemented
    notifyListeners();
  }
}
