import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import '../shimmer/shimmer_effect.dart';

class HkRoundedImage extends StatelessWidget {
  const HkRoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = HkSizes.md,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
          child: isNetworkImage
              ? CachedNetworkImage(
            fit: fit,
            imageUrl: imageUrl,
            progressIndicatorBuilder: (context, url, progress) => HkShimmerEffect(
              width: width ?? double.infinity,
              height: height ?? double.infinity,
            ),
            errorWidget: (context, url, error) => const Center(child: Icon(Icons.error, color: Colors.red)),
          )
              : Image(
            image: AssetImage(imageUrl),
            fit: fit,
          ),
        ),
      ),
    );
  }
}