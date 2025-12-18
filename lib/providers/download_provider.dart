import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:myapp/models/download.dart';

class DownloadProvider with ChangeNotifier {
  double _progress = 0;
  bool _isDownloading = false;
  String _speed = '0 KB/s';
  String _remainingTime = '...';
  int _totalBytes = 0;
  int _receivedBytes = 0;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  final List<Download> _activeDownloads = [];
  final List<Download> _completedDownloads = [];

  double get progress => _progress;
  bool get isDownloading => _isDownloading;
  String get speed => _speed;
  String get remainingTime => _remainingTime;
  int get totalBytes => _totalBytes;
  int get receivedBytes => _receivedBytes;
  List<Download> get activeDownloads => _activeDownloads;
  List<Download> get completedDownloads => _completedDownloads;

  void downloadFile(String url, String name, int totalBytes, String title) {
    _isDownloading = true;
    _progress = 0;
    _speed = '0 KB/s';
    _remainingTime = '...';
    _totalBytes = totalBytes;
    _receivedBytes = 0;
    _stopwatch.start();
    
    final download = Download(
      title: title,
      path: '',
      totalBytes: totalBytes,
      downloadedAt: DateTime.now(),
    );
    _activeDownloads.add(download);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateSpeedAndRemainingTime();
    });

    notifyListeners();

    FileDownloader.downloadFile(
      url: url.trim(),
      name: name.trim(),
      onProgress: (fileName, progress) {
          _progress = progress;
          _receivedBytes = (_totalBytes * (progress / 100)).round();
          notifyListeners();
      },
      onDownloadCompleted: (path) {
        _isDownloading = false;
        _stopwatch.stop();
        _stopwatch.reset();
        _timer?.cancel();
        _activeDownloads.remove(download);
        _completedDownloads.add(Download(
          title: title,
          path: path,
          totalBytes: totalBytes,
          downloadedAt: DateTime.now(),
        ));
        notifyListeners();
      },
      onDownloadError: (error) {
        _isDownloading = false;
        _stopwatch.stop();
        _stopwatch.reset();
        _timer?.cancel();
        _activeDownloads.remove(download);
        notifyListeners();
      },
    );
  }

  void _calculateSpeedAndRemainingTime() {
    if (_stopwatch.elapsedMilliseconds == 0) return;

    double bps = _receivedBytes / (_stopwatch.elapsedMilliseconds / 1000);
    double mbps = bps / (1024 * 1024);
    
    _speed = mbps > 1 ? '${mbps.toStringAsFixed(2)} MB/s' : '${(bps/1024).toStringAsFixed(2)} KB/s';


    if (bps > 0) {
      int remainingBytes = _totalBytes - _receivedBytes;
      int remainingSeconds = (remainingBytes / bps).round();
      
      _remainingTime = '${remainingSeconds}s';
    } else {
      _remainingTime = '...';
    }
    notifyListeners();
  }

    @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
