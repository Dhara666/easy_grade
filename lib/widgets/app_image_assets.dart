import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constant/color_constant.dart';

class AppImageAsset extends StatelessWidget {
  final String? image;
  final bool isWebImage;
  final double? height;
  final double? webHeight;
  final double? width;
  final double? webWidth;
  final Color? color;
  final BoxFit? fit;
  final BoxFit? webFit;

  const AppImageAsset(
      {Key? key,
      @required this.image,
      this.webFit,
      this.fit,
      this.height,
      this.webHeight,
      this.width,
      this.webWidth,
      this.color,
      this.isWebImage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isWebImage) {
      return CachedNetworkImage(
            imageUrl: image!,
            height: webHeight,
            width: webWidth,
            fit: webFit ?? BoxFit.fill,
            placeholder: (context, url) => Container(color: ColorConstant.appLightBlue),
            errorWidget: (context, url, error) => const Center(
             child: Icon(Icons.error_outline),
            ),
          );
    } else {
      return Image.asset(
                image!,
                fit: fit,
                height: height,
                width: width,
                color: color,
              );
    }
  }
}
