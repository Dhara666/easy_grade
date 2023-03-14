// ignore_for_file: unnecessary_this, duplicate_ignore

import 'package:easy_grade/pages/pdf_view_page.dart';
import 'package:easy_grade/pages/play_video.dart';
import 'package:easy_grade/widgets/app_button.dart';
import 'package:easy_grade/widgets/app_image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../constant/color_constant.dart';
import '../../provider/course_provider.dart';
import '../../widgets/app_text.dart';
import '../generated/l10n.dart';
import '../model/course_book_model.dart';
import '../model/course_video_model.dart';
import '../widgets/app_loader.dart';

class LessonsPage extends StatefulWidget {
  final String? lessonTopicName;
  final String? topicId;

  const LessonsPage({Key? key, this.lessonTopicName,this.topicId}) : super(key: key);

  @override
  State<LessonsPage> createState() => LessonsPageState();
}

class LessonsPageState extends State<LessonsPage> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  bool titleView = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, CourseProvider courseProvider, _) {
      return Stack(
        children: [
          DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.grey[200],
                appBar: AppBar(
                  elevation: 0.0,
                  toolbarHeight: 0,
                  backgroundColor: ColorConstant.appWhite,
                  centerTitle: true,
                  iconTheme: const IconThemeData(
                    color: ColorConstant.appBlack,
                  ),
                  bottom: const TabBar(
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3.0,
                        color: ColorConstant.appBlue,
                      ),
                    ),
                    unselectedLabelColor: ColorConstant.appGrey,
                    labelColor: ColorConstant.appBlue,
                    indicatorColor: ColorConstant.appBlue,
                    tabs: [
                      Tab(
                          icon: Text(
                        "PDF",
                        style: TextStyle(
                            fontFamily: AppAsset.defaultFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )),
                      Tab(
                          icon: Text(
                        "VIDEO",
                        style: TextStyle(
                            fontFamily: AppAsset.defaultFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          bookList(courseProvider),
                          AppButton(
                            buttonText: S.of(context).startCourseAgain,
                            borderRadius: 30,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            onTap: () {
                              courseProvider.startCourseAgain(context,widget.topicId!);
                            },
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          videoList(courseProvider),
                          AppButton(
                            buttonText: S.of(context).startCourseAgain,
                            borderRadius: 30,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            onTap: () {
                              courseProvider.startCourseAgain(context,widget.topicId!);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          courseProvider.isLoading ? const AppLoader():const SizedBox()
        ],
      );
    });
  }

  bookList(CourseProvider courseProvider) {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: courseProvider.myCoursebookDetail.length,
        itemBuilder: (BuildContext c, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: const Duration(milliseconds: 50),
            child: SlideAnimation(
              duration: const Duration(milliseconds: 1800),
              curve: Curves.fastLinearToSlowEaseIn,
              horizontalOffset: 30,
              verticalOffset: 300.0,
              child: FlipAnimation(
                  duration: const Duration(milliseconds: 1800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  flipAxis: FlipAxis.y,
                  child: InkWell(
                    onTap: () async {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppText(
                                text: courseProvider
                                    .myCoursebookDetail[index].sectionName,
                                fontWeight: FontWeight.w600,
                                textColor: Colors.grey[700],
                                fontSize: 15,
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: courseProvider
                              .myCoursebookDetail[index].books?.length,
                          itemBuilder: (BuildContext context, int index1) {
                            Book itemBook = courseProvider
                                .myCoursebookDetail[index].books![index1];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PDFViewerCachedFromUrl(
                                              url: itemBook.pdfFile!,
                                              urlName: itemBook.bookName!,
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: ColorConstant.appWhite,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  children: [
                                    // Container(
                                    //   height: 50,
                                    //   width: 50,
                                    //   margin: const EdgeInsets.all(10),
                                    //   decoration: BoxDecoration(
                                    //     shape: BoxShape.circle,
                                    //     color: ColorConstant.appBlue
                                    //         .withOpacity(0.2),
                                    //   ),
                                    //   child: Center(
                                    //       child: AppText(
                                    //     text: index1.toString(),
                                    //     fontWeight: FontWeight.w600,
                                    //     fontSize: 20,
                                    //   )),
                                    // ),
                                    // const SizedBox(width: 10),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text: itemBook.bookName,
                                              textColor: ColorConstant.appBlack,
                                              maxLines: 1,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 35,
                                      width: 35,
                                      margin: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorConstant.appBlue),
                                      child: const Center(
                                          child: Icon(
                                        Icons.picture_as_pdf,
                                        color: ColorConstant.appWhite,
                                        size: 20,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }

  videoList(CourseProvider courseProvider) {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: courseProvider.myFilterVideoDetail.length,
        itemBuilder: (BuildContext c, int index) {
          Video itemBook = courseProvider.myFilterVideoDetail[index];
          if (courseProvider.myFilterVideoDetail[index] ==
              courseProvider.myFilterVideoDetail[0]) {
            titleView = true;
          } else if (courseProvider.myFilterVideoDetail[index].mySectionName ==
              courseProvider.myFilterVideoDetail[index - 1].mySectionName) {
            titleView = false;
          } else {
            titleView = true;
          }
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: const Duration(milliseconds: 50),
            child: SlideAnimation(
              duration: const Duration(milliseconds: 1800),
              curve: Curves.fastLinearToSlowEaseIn,
              horizontalOffset: 30,
              verticalOffset: 300.0,
              child: FlipAnimation(
                  duration: const Duration(milliseconds: 1800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  flipAxis: FlipAxis.y,
                  child: InkWell(
                    onTap: () async {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleView
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text: courseProvider
                                          .myFilterVideoDetail[index]
                                          .mySectionName,
                                      fontWeight: FontWeight.w600,
                                      textColor: Colors.grey[700],
                                      fontSize: 15,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        InkWell(
                          onTap: () async {
                              if (itemBook.iswatch == null) {
                               await courseProvider.videoComplete(
                                    context, itemBook.id.toString(),
                                    topicId: itemBook.topicId.toString());
                                final bool watch = courseProvider.myFilterVideoDetail.every((video) => video.iswatch == 1);
                                if(watch){
                                  courseProvider.courseComplete(
                                  this.context, itemBook.topicId.toString());
                                }
                              }
                              await Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AnimationPlayer(videoIndex : index)));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                                color: ColorConstant.appWhite,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                AppImageAsset(
                                  image: itemBook.videoThumbnail!,
                                  isWebImage: true,
                                  webFit: BoxFit.fill,
                                  webHeight: 50,
                                  webWidth: 80,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: itemBook.title,
                                          textColor: ColorConstant.appBlack,
                                          maxLines: 1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 35,
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorConstant.appBlue),
                                  child: const Center(
                                      child: Icon(
                                    Icons.play_arrow,
                                    color: ColorConstant.appWhite,
                                    size: 20,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }
}
