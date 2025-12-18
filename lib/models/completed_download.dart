import 'package:myapp/models/video_info.dart';

class CompletedDownload {
  final VideoInfo videoInfo;
  final String filePath;
  final DateTime downloadedAt;

  CompletedDownload({
    required this.videoInfo,
    required this.filePath,
    required this.downloadedAt,
  });

  Map<String, dynamic> toJson() => {
        'videoInfo': videoInfo.toJson(),
        'filePath': filePath,
        'downloadedAt': downloadedAt.toIso8601String(),
      };

  factory CompletedDownload.fromJson(Map<String, dynamic> json) => CompletedDownload(
        videoInfo: VideoInfo.fromJson(json['videoInfo']),
        filePath: json['filePath'],
        downloadedAt: DateTime.parse(json['downloadedAt']),
      );
}
