
import 'package:flutter/material.dart';

class DownloadItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? progress;

  const DownloadItem({super.key, 
    required this.title,
    required this.subtitle,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: progress != null
          ? SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
              ),
            )
          : const Icon(Icons.check_circle, color: Colors.green),
    );
  }
}
