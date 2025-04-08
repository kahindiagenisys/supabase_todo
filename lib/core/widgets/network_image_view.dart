import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/string_extensions.dart';

class NetworkImageView extends StatelessWidget {
  final String? avatarUrl;
  final double? size;

  const NetworkImageView({super.key, required this.avatarUrl, this.size});

  @override
  Widget build(BuildContext context) {
    if (avatarUrl.isValueEmptyOrNull) {
      return Icon(Icons.people);
    }

    return ExtendedImage.network(
      avatarUrl!,
      width: size,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              width: size,
              height: size,
            );
          default:
            return Icon(Icons.people);
        }
      },
    );
  }
}
