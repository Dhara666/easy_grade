import 'dart:async';

import 'package:easy_grade/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../constant/color_constant.dart';

class PDFViewerCachedFromUrl extends StatefulWidget {
  const PDFViewerCachedFromUrl({Key? key, required this.url,required this.urlName,}) : super(key: key);

  final String url;
  final String urlName;

  @override
  State<PDFViewerCachedFromUrl> createState() => _PDFViewerCachedFromUrlState();
}

class _PDFViewerCachedFromUrlState extends State<PDFViewerCachedFromUrl> {
  final Completer<PDFViewController> _pdfViewController =
  Completer<PDFViewController>();
  final StreamController<String> _pageCountController =
  StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          leadingWidth: 75,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Done",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.lock_fill,color: Colors.black,size: 15),
              const SizedBox(width: 2),
              Expanded(
                child: AppText(
                  text: widget.urlName.toLowerCase(),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          PDF(
            autoSpacing: true,
            onPageChanged: (int? current, int? total) =>
                _pageCountController.add('${current! + 1} of $total'),
            onViewCreated: (PDFViewController pdfViewController) async {
              _pdfViewController.complete(pdfViewController);
              final int currentPage = await pdfViewController.getCurrentPage() ?? 0;
              final int? pageCount = await pdfViewController.getPageCount();
              _pageCountController.add('${currentPage + 1} of $pageCount');
            },
          ).cachedFromUrl(
            widget.url,
            placeholder: (double progress) => const Center(child: CircularProgressIndicator(color: ColorConstant.appWhite)),
            errorWidget: (dynamic error) => Center(child: Text(error.toString())),
          ),
          StreamBuilder<String>(
              stream: _pageCountController.stream,
              builder: (_, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    margin: const EdgeInsets.only(top :20,left: 20),
                    decoration:  BoxDecoration(
                        color: ColorConstant.appWhite,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(snapshot.data!,style: const TextStyle(fontWeight: FontWeight.w700),),
                  );
                }
                return const SizedBox();
              }),
        ],
      ),
    );
  }
}