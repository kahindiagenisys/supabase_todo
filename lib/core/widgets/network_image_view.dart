import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/string_extensions.dart';

class NetworkImageView extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final bool isCircular;

  const NetworkImageView({
    super.key,
    required this.avatarUrl,
    this.size = 50,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(isCircular ? size : 12);

    if (avatarUrl.isValueEmptyOrNull) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: ExtendedImage.network(
        avatarUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        cache: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.completed:
              return ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: size,
                height: size,
                fit: BoxFit.cover,
              );
            case LoadState.failed:
              return _placeholder();
            default:
              return _loader();
          }
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Icon(Icons.person, size: size * 0.6, color: Colors.white),
    );
  }

  Widget _loader() {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
