// ignore_for_file: invalid_use_of_protected_member, duplicate_ignore


import 'package:easy_grade/provider/course_provider.dart';
import 'package:easy_grade/pages/course_detail_page/course_detail_page.dart';
import 'package:easy_grade/widgets/app_image_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../constant/color_constant.dart';
import '../../generated/l10n.dart';
import '../../model/course_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';

class MyCourse extends StatefulWidget {
  const MyCourse({Key? key}) : super(key: key);

  @override
  State<MyCourse> createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse> {
  List<String> newListOption = [];
  bool isSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CourseProvider courseProvider =
        Provider.of<CourseProvider>(context, listen: false);
      courseProvider.getCourse(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder:
          (BuildContext context, CourseProvider courseProvider, Widget? child) {
        return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                elevation: 0.0,
                automaticallyImplyLeading: true,
                iconTheme: const IconThemeData(
                  color: ColorConstant.appBlack,
                ),
                backgroundColor: ColorConstant.appWhite,
                title: !isSearch
                    ? AppText(
                        text: S.of(context).myCourse,
                        textColor: ColorConstant.appThemeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      )
                    : TextField(
                        autofocus: true,
                        controller: courseProvider.searchController,
                        decoration:  InputDecoration(
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 5,
                            minHeight: 2,
                          ),
                          suffixIcon: InkWell(
                            onTap: (){
                              isSearch = !isSearch;
                              if (isSearch == false) {
                                courseProvider.searchController.clear();
                                courseProvider.searchCourseDetail.clear();
                              }
                              // ignore: invalid_use_of_visible_for_testing_member
                              courseProvider.notifyListeners();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                  color: ColorConstant.appBlue),
                                child: const Icon(Icons.clear,color: ColorConstant.appWhite,size: 18,)),
                          ),
                          hintText: 'Search here ...',
                          hintStyle: const TextStyle(
                            color: ColorConstant.appThemeColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: ColorConstant.appThemeColor,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (value) {
                          courseProvider.onSearchTextChanged(value);
                        },
                      ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 15),
                    child: GestureDetector(
                      onTap: () {
                        isSearch = !isSearch;
                        if (isSearch == false) {
                          courseProvider.searchController.clear();
                          courseProvider.searchCourseDetail.clear();
                        }
                        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                        courseProvider.notifyListeners();
                      },
                      child: const Icon(CupertinoIcons.search,
                          color: ColorConstant.appBlack, size: 28),
                    ),
                  ),
                ],
                bottom: DecoratedTabBar(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ColorConstant.appGrey,
                        width: 3.0,
                      ),
                    ),
                  ),
                  tabBar: TabBar(
                    onTap: (value) {},
                    indicator: const UnderlineTabIndicator(
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
                        S.of(context).ongoing,
                        style: const TextStyle(
                            fontFamily: AppAsset.defaultFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )),
                      Tab(
                          icon: Text(
                        S.of(context).completed,
                        style: const TextStyle(
                            fontFamily: AppAsset.defaultFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )),
                    ],
                  ),
                ),
              ),
              body: Stack(
                children: [
                  TabBarView(
                    children: [
                      ongoingList(courseProvider),
                      completeList(courseProvider),
                    ],
                  ),
                  courseProvider.isLoading ? const AppLoader(): const SizedBox()
                ],
              ),
            ));
      },
    );
  }

  ongoingList(CourseProvider courseProvider) {
    return (courseProvider.searchCourseDetail.isNotEmpty || courseProvider.searchController.text.isNotEmpty)?
    AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: ListView.builder(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: courseProvider.searchCourseDetail.length,
          itemBuilder: (BuildContext c, int index) {
            CourseDetail courseDetail =
            courseProvider.searchCourseDetail[index];

            return AnimationConfiguration.staggeredList(
              position: index,
              delay: const Duration(milliseconds: 50),
              child: SlideAnimation(
                duration: const Duration(milliseconds: 1500),
                curve: Curves.fastLinearToSlowEaseIn,
                horizontalOffset: 30,
                verticalOffset: 300.0,
                child: FlipAnimation(
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    flipAxis: FlipAxis.y,
                    child: InkWell(
                      onTap: () async {
                        bool isRefresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CourseDetailPage(
                                  topicId: courseDetail.id.toString(),
                                  name: courseDetail.topicName,
                                  topicImage: courseDetail.image,
                                  // videoItem: courseProvider.ongoingItem[index].videoItem ?? []
                                )));
                        if (isRefresh) {
                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          courseProvider.notifyListeners();
                        }
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
                            Container(
                              height: 100,
                              width: 100,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: AppImageAsset(
                                  image: courseDetail.image,
                                  webFit: BoxFit.fill,
                                  isWebImage: true,
                                ),
                              ), // no matter how big it is, it won't overflow
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
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: AppText(
                                            text: courseDetail.topicName,
                                            textColor:
                                            ColorConstant.appBlack,
                                            maxLines: 1,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 5),
                                      child: AppText(
                                        text: courseDetail.length,
                                        maxLines: 1,
                                        fontWeight: FontWeight.w400,
                                        textColor: ColorConstant.appGrey,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                              const EdgeInsets.only(
                                                  right: 10),
                                              child: ClipRRect(
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(
                                                        10)),
                                                child:
                                                LinearProgressIndicator(
                                                  value: (courseDetail
                                                      .watchVideo! ==
                                                      0 &&
                                                      courseDetail
                                                          .totalVideo ==
                                                          0)
                                                      ? 0.0
                                                      : courseDetail
                                                      .watchVideo! /
                                                      int.parse(courseDetail
                                                          .totalVideo
                                                          .toString()),
                                                  // value:  0.7,
                                                  color: ColorConstant
                                                      .appBlue,
                                                  minHeight: 7,
                                                  backgroundColor: Colors
                                                      .grey, //<-- SEE HERE
                                                ),
                                              ),
                                            ),
                                          ),
                                          AppText(
                                            text:
                                            "${courseDetail.watchVideo}/${courseDetail.totalVideo}",
                                            maxLines: 1,
                                            fontWeight: FontWeight.w600,
                                            textColor:
                                            ColorConstant.appBlack,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            );
          },
        ),
      ),
    ) :
    (courseProvider.myCourseDetail.isEmpty)
        ? Center(
            child: AppText(text: S.of(context).noCourseAvailable),
          )
        :
    AnimationLimiter(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: courseProvider.myCourseDetail.length,
                itemBuilder: (BuildContext c, int index) {
                  CourseDetail courseDetail =
                      courseProvider.myCourseDetail[index];

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 50),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      horizontalOffset: 30,
                      verticalOffset: 300.0,
                      child: FlipAnimation(
                          duration: const Duration(milliseconds: 2000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          flipAxis: FlipAxis.y,
                          child: InkWell(
                            onTap: () async {
                            Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CourseDetailPage(
                                            topicId: courseDetail.id.toString(),
                                            name: courseDetail.topicName,
                                            topicImage: courseDetail.image,
                                            // videoItem: courseProvider.ongoingItem[index].videoItem ?? []
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
                                  Container(
                                    height: 100,
                                    width: 100,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: AppImageAsset(
                                        image: courseDetail.image,
                                        webFit: BoxFit.fill,
                                        isWebImage: true,
                                      ),
                                    ), // no matter how big it is, it won't overflow
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
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: AppText(
                                                  text: courseDetail.topicName,
                                                  textColor:
                                                      ColorConstant.appBlack,
                                                  maxLines: 1,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: AppText(
                                              text: courseDetail.length,
                                              maxLines: 1,
                                              fontWeight: FontWeight.w400,
                                              textColor: ColorConstant.appGrey,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: (courseDetail
                                                                        .watchVideo! ==
                                                                    0 &&
                                                                courseDetail
                                                                        .totalVideo ==
                                                                    0)
                                                            ? 0.0
                                                            : courseDetail
                                                                    .watchVideo! /
                                                                int.parse(courseDetail
                                                                    .totalVideo
                                                                    .toString()),
                                                        // value:  0.7,
                                                        color: ColorConstant
                                                            .appBlue,
                                                        minHeight: 7,
                                                        backgroundColor: Colors
                                                            .grey, //<-- SEE HERE
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                AppText(
                                                  text:
                                                      "${courseDetail.watchVideo}/${courseDetail.totalVideo}",
                                                  maxLines: 1,
                                                  fontWeight: FontWeight.w600,
                                                  textColor:
                                                      ColorConstant.appBlack,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  );
                },
              ),
            ),
          );
  }

  completeList(CourseProvider courseProvider) {
    return
      (courseProvider.searchCourseDetail.isNotEmpty || courseProvider.searchController.text.isNotEmpty) ?
      AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: courseProvider.searchCourseDetail.length,
        itemBuilder: (BuildContext c, int index) {
          CourseDetail courseDetail =
          courseProvider.searchCourseDetail[index];
          if (courseDetail.isCompleted == 1) {
            return AnimationConfiguration.staggeredList(
              position: index,
              delay: const Duration(milliseconds: 50),
              child: SlideAnimation(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  horizontalOffset: 30,
                  verticalOffset: 300.0,
                  child: FlipAnimation(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.fastLinearToSlowEaseIn,
                      flipAxis: FlipAxis.y,
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
                            Container(
                              height: 100,
                              width: 100,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: AppImageAsset(
                                  isWebImage: true,
                                  image: courseDetail.image!,
                                  webFit: BoxFit.fill,
                                ),
                              ), // no matter how big it is, it won't overflow
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: courseDetail.topicName,
                                    textColor: ColorConstant.appBlack,
                                    maxLines: 3,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 5),
                                    child: AppText(
                                      text: courseDetail.length,
                                      maxLines: 1,
                                      fontWeight: FontWeight.w400,
                                      textColor: ColorConstant.appGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              alignment: Alignment.center,
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 7,
                                      color: ColorConstant.appBlue)),
                              child: const AppText(
                                text: "100%",
                                textAlign: TextAlign.center,
                                textColor: ColorConstant.appBlack,
                              ),
                            )
                          ],
                        ),
                      ))),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    ) :
      (courseProvider.myCourseDetail.isEmpty)
        ? Center(
            child: AppText(text: S.of(context).noCourseAvailable),
          )
        : AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: courseProvider.myCourseDetail.length,
              itemBuilder: (BuildContext c, int index) {
                CourseDetail courseDetail =
                    courseProvider.myCourseDetail[index];
                if (courseDetail.isCompleted == 1) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 50),
                    child: SlideAnimation(
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        horizontalOffset: 30,
                        verticalOffset: 300.0,
                        child: FlipAnimation(
                            duration: const Duration(milliseconds: 2000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            flipAxis: FlipAxis.y,
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
                                  Container(
                                    height: 100,
                                    width: 100,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: AppImageAsset(
                                        isWebImage: true,
                                        image: courseDetail.image!,
                                        webFit: BoxFit.fill,
                                      ),
                                    ), // no matter how big it is, it won't overflow
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: courseDetail.topicName,
                                          textColor: ColorConstant.appBlack,
                                          maxLines: 3,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: AppText(
                                            text: courseDetail.length,
                                            maxLines: 1,
                                            fontWeight: FontWeight.w400,
                                            textColor: ColorConstant.appGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    alignment: Alignment.center,
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 7,
                                            color: ColorConstant.appBlue)),
                                    child: const AppText(
                                      text: "100%",
                                      textAlign: TextAlign.center,
                                      textColor: ColorConstant.appBlack,
                                    ),
                                  )
                                ],
                              ),
                            ))),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          );
  }
}

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
   // ignore: use_key_in_widget_constructors
   const DecoratedTabBar({required this.tabBar, required this.decoration});

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        tabBar,
      ],
    );
  }
}
