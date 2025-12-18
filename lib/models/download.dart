class Download {
  final String title;
  final String path;
  final int totalBytes;
  final DateTime downloadedAt;

  Download({
    required this.title,
    required this.path,
    required this.totalBytes,
    required this.downloadedAt,
  });
}
