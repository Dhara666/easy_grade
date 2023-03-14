import 'dart:io';
import 'package:easy_grade/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../constant/color_constant.dart';
import 'app_loader.dart';
import 'app_text.dart';

class AppPhotoView extends StatelessWidget {
  final String? url;
  final File? fileImage;

  const AppPhotoView(
      {Key? key, this.url, this.fileImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(
        color: ColorConstant.appBlack,
      ),
      titleSpacing: 0,
      backgroundColor: ColorConstant.appWhite,
       title: AppText(
        text: S.of(context).viewImage,
        textColor: ColorConstant.appThemeColor,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
      body:  PhotoView(
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 2,
      imageProvider: (url!.contains('https') || url!.contains('http'))
          ? NetworkImage(url!)
          : FileImage(fileImage!) as ImageProvider,
      loadingBuilder: (context, event) => const Center(
          child: AppLoader()),
      backgroundDecoration: const BoxDecoration(
          color:ColorConstant.appWhite),
    )
    );
  }
}
