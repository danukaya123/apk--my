
int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

class VideoInfo {
  final Metadata metadata;
  final Downloads downloads;

  VideoInfo({required this.metadata, required this.downloads});

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      metadata: Metadata.fromJson(json['metadata']),
      downloads: Downloads.fromJson(json['downloads']),
    );
  }
}

class Metadata {
  final String title;
  final String thumbnail;
  final int? views;
  final String description;
  final String author;
  final String duration;

  Metadata({
    required this.title,
    required this.thumbnail,
    this.views,
    required this.description,
    required this.author,
    required this.duration,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      title: json['title'] ?? 'Unknown Title',
      thumbnail: json['thumbnail'] ?? '',
      views: _parseInt(json['views']),
      description: json['description'] ?? 'No description available',
      author: json['author'] ?? 'Unknown Author',
      duration: (json['duration'] is Map ? json['duration']['timestamp'] : json['duration']) ?? 'Unknown duration',
    );
  }
}

class Downloads {
  final List<DownloadFormat> mp4;
  final List<DownloadFormat> mp3;

  Downloads({required this.mp4, required this.mp3});

  factory Downloads.fromJson(Map<String, dynamic> json) {
    var mp4List = (json['mp4'] as List? ?? [])
        .map((i) => DownloadFormat.fromJson(i))
        .toList();
    var mp3List = (json['mp3'] as List? ?? [])
        .map((i) => DownloadFormat.fromJson(i))
        .toList();
    return Downloads(mp4: mp4List, mp3: mp3List);
  }
}

class DownloadFormat {
  final String quality;
  final int? size;
  final int qualityNumber;
  final String filename;
  final String? url;

  DownloadFormat({
    required this.quality,
    this.size,
    required this.qualityNumber,
    required this.filename,
    this.url,
  });

  factory DownloadFormat.fromJson(Map<String, dynamic> json) {
    return DownloadFormat(
      quality: json['quality'] ?? '',
      size: _parseInt(json['size']),
      qualityNumber: _parseInt(json['qualityNumber']) ?? 0,
      filename: json['filename'] ?? '',
      url: json['url'],
    );
  }
}
