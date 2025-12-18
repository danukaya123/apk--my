String _formatDuration(int totalSeconds) {
  if (totalSeconds <= 0) {
    return 'N/A';
  }
  final duration = Duration(seconds: totalSeconds);
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

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

  String? get title => metadata.title;

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      metadata: Metadata.fromJson(json['metadata']),
      downloads: Downloads.fromJson(json['downloads']),
    );
  }

  Map<String, dynamic> toJson() => {
        'metadata': metadata.toJson(),
        'downloads': downloads.toJson(),
      };

  factory VideoInfo.fromTiktokJson(Map<String, dynamic> json) {
    return VideoInfo(
      metadata: Metadata(
        title: json['title'] ?? 'Unknown Title',
        thumbnail: json['thumbnail'] ?? '',
        author: json['author'] ?? 'Unknown Author',
        duration: _formatDuration(json['duration'] ?? 0),
        description: json['title'] ?? 'No description available.',
        views: null,
      ),
      downloads: Downloads(
        mp4: [
          if (json['videoUrl'] != null)
            DownloadFormat(
              quality: 'HD',
              qualityNumber: 720,
              filename: 'tiktok_video.mp4',
              url: json['videoUrl'],
            ),
        ],
        mp3: [
          if (json['audioUrl'] != null)
            DownloadFormat(
              quality: '128kbps',
              qualityNumber: 128,
              filename: 'tiktok_audio.mp3',
              url: json['audioUrl'],
            ),
        ],
      ),
    );
  }

  factory VideoInfo.fromFacebookJson(Map<String, dynamic> json) {
    return VideoInfo(
      metadata: Metadata(
        title: json['title'] ?? 'Facebook Video',
        thumbnail: json['thumbnail'] ?? '',
        author: 'Facebook',
        duration: 'N/A',
        description: json['title'] ?? 'No description available.',
        views: null,
      ),
      downloads: Downloads(
        mp4: [
          if (json['urls']?['hd'] != null)
            DownloadFormat(
              quality: 'HD',
              qualityNumber: 720,
              filename: 'facebook_video_hd.mp4',
              url: json['urls']['hd'],
            ),
          if (json['urls']?['sd'] != null)
            DownloadFormat(
              quality: 'SD',
              qualityNumber: 360,
              filename: 'facebook_video_sd.mp4',
              url: json['urls']['sd'],
            ),
        ],
        mp3: [],
      ),
    );
  }

  VideoInfo copyWith({
    Metadata? metadata,
    Downloads? downloads,
  }) {
    return VideoInfo(
      metadata: metadata ?? this.metadata,
      downloads: downloads ?? this.downloads,
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
    var durationValue = json['duration'];
    String formattedDuration = 'N/A';
    if (durationValue is Map && durationValue.containsKey('timestamp')) {
      formattedDuration = durationValue['timestamp'];
    } else if (durationValue is String) {
      formattedDuration = durationValue;
    } else if (durationValue is int) {
      formattedDuration = _formatDuration(durationValue);
    }

    return Metadata(
      title: json['title'] ?? 'Unknown Title',
      thumbnail: json['thumbnail'] ?? '',
      views: _parseInt(json['views']),
      description: json['description'] ?? 'No description available.',
      author: json['author'] ?? 'Unknown Author',
      duration: formattedDuration,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'thumbnail': thumbnail,
        'views': views,
        'description': description,
        'author': author,
        'duration': duration,
      };
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

  Map<String, dynamic> toJson() => {
        'mp4': mp4.map((i) => i.toJson()).toList(),
        'mp3': mp3.map((i) => i.toJson()).toList(),
      };

  Downloads copyWith({
    List<DownloadFormat>? mp4,
    List<DownloadFormat>? mp3,
  }) {
    return Downloads(
      mp4: mp4 ?? this.mp4,
      mp3: mp3 ?? this.mp3,
    );
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

  Map<String, dynamic> toJson() => {
        'quality': quality,
        'size': size,
        'qualityNumber': qualityNumber,
        'filename': filename,
        'url': url,
      };

  DownloadFormat copyWith({
    String? quality,
    int? size,
    int? qualityNumber,
    String? filename,
    String? url,
  }) {
    return DownloadFormat(
      quality: quality ?? this.quality,
      size: size ?? this.size,
      qualityNumber: qualityNumber ?? this.qualityNumber,
      filename: filename ?? this.filename,
      url: url ?? this.url,
    );
  }
}
