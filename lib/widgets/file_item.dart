import 'package:flutter/material.dart';
import 'package:maps_application/styles/font_styles.dart';

class FileItem extends StatelessWidget {
  final String fileName;
  final int size;
  final VoidCallback onCloseTap;

  const FileItem({
    super.key,
    required this.fileName,
    required this.size,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FileUploadTextStyles.name,
                ),
                Text(
                  '${(size / 1024 / 1024).toStringAsFixed(2)} MB',
                  style: FileUploadTextStyles.size,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCloseTap,
            icon: Icon(Icons.close),
          )
        ],
      ),
    );
  }
}
