import 'dart:convert';

import 'package:easy_grade/pages/lessons_page.dart';
import 'package:easy_grade/widgets/app_button.dart';
import 'package:easy_grade/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/color_constant.dart';
import '../../generated/l10n.dart';
import '../../model/course_video_model.dart';
import '../../provider/course_provider.dart';
import '../../shared_preference/shared_preference.dart';
import '../../utills/app_logs.dart';
import '../../utills/app_validation.dart';
import '../../widgets/app_text_field.dart';
import '../download_page/download_course_page.dart';
import '../my_course/my_course.dart';
import '../splash_page/splash_page.dart';

class CourseDetailPage extends StatefulWidget {
  final String? name;
  final String? topicId;
  final String? topicImage;

  const CourseDetailPage({Key? key, this.name, this.topicId,this.topicImage}) : super(key: key);

  @override
  State<CourseDetailPage> createState() => CourseDetailPageState();
}

class CourseDetailPageState extends State<CourseDetailPage> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CourseProvider courseProvider =
        Provider.of<CourseProvider>(context, listen: false);
    courseProvider.getPdfCourse(context, widget.topicId!);
    courseProvider.getVideo(context, widget.topicId!);

  }

  Future<bool> _willPopCallback() async {
    CourseProvider courseProvider =
    Provider.of<CourseProvider>(context, listen: false);
    await courseProvider.getCourse(context) ;
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Consumer(builder: (context, CourseProvider courseProvider,_) {
        return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                elevation: 0.0,
                automaticallyImplyLeading: true,
                leading: BackButton(
                    onPressed: () async {
                        Navigator.pop(context);
                        await courseProvider.getCourse(context);

                    },
                    color: Colors.black),
                backgroundColor: ColorConstant.appWhite,
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: ColorConstant.appBlack,
                ),
                title: Text(
                  widget.name!,
                  style: const TextStyle(
                      color: ColorConstant.appThemeColor,
                      fontFamily: AppAsset.defaultFont,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
                actions: [
                  InkWell(
                    onTap: () async {
                      for (var element in courseProvider.myCourseVideoDetail) {
                        element.videos?.forEach((element1) {
                          myVideo.add(Video(
                              topicImage:widget.topicImage?.trim(),
                              topicName: widget.name.toString(),
                              id: element1.id,
                              videoThumbnail: element1.videoThumbnail,
                              videoFile: element1.videoFile,
                              videoLength: element1.videoLength,
                              sectionId: element1.sectionId,
                              createdAt: element1.createdAt,
                              title: element1.title,
                              topicId: element1.topicId,
                              updatedAt: element1.updatedAt));
                        });
                      }
                      var seen = <int>{};
                      List<Video> uniquelist = myVideo.where((student) => seen.add(student.id!)).toList();
                      final prefs = await SharedPreferences.getInstance();
                      List<String> encodedRestaturants = uniquelist.map((res) => json.encode(res.toJson())).toList();
                      prefs.setStringList(downloadList, encodedRestaturants);
                      Navigator.push(
                          this.context,
                          MaterialPageRoute(
                              builder: (context) => const DownloadCoursePage()));
                    },
                    child: Container(
                       margin: const EdgeInsets.only(right: 15.0, left: 15),
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: ColorConstant.appBlue),
                        child: const Center(
                            child: Icon(Icons.arrow_downward_sharp,
                                size: 15, color: ColorConstant.appWhite))),
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
                        S.of(context).lessons,
                        style: const TextStyle(
                            fontFamily: AppAsset.defaultFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )),
                      Tab(
                          icon: Text(
                        S.of(context).certificates,
                        style: const TextStyle(
                            fontFamily: AppAsset.defaultFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  LessonsPage(lessonTopicName: widget.name, topicId:widget.topicId),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 20, top: 50),
                    child: Center(
                      child: AppButton(
                          onTap: () {
                            double courseRating = 1;
                            TextEditingController reviewController = TextEditingController();
                            final formKey = GlobalKey<FormState>();
                            showDialog(
                                context: context,
                                builder: (_) => CongratulationDialog(
                                      titleMsg: "${S.of(context).courseCompleted}!",
                                      subTitleMsg: S.of(context).reviewDec,
                                      icon: const Icon(
                                        Icons.edit,
                                        color: ColorConstant.appWhite,
                                        size: 40,
                                      ),
                                      alertWidget: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Column(
                                          children: [
                                          Form(
                                            key : formKey,
                                            child: AppTextField(
                                              validator: (value) =>
                                                  emptyValidator(value!, S.of(context).validReview),
                                               controller: reviewController,
                                            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                            fillColor: ColorConstant.appBlue.withOpacity(0.06),
                                            hint: S.of(context).enterReview,enabledBorder: AppTextField.appOutlineInputBorder(color: ColorConstant.appGrey),focusedBorder: AppTextField.appOutlineInputBorder(),
                                            errorBorder: AppTextField.appOutlineInputBorder(color: Colors.red) ,
                                        ),
                                          ),
                                          RatingBar.builder(
                                          initialRating: 1,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: ColorConstant.appLightBlue,
                                          ),
                                          onRatingUpdate: (rating) {
                                            logs(rating.toString());
                                            courseRating = rating;
                                            logs("rating--->$courseRating");
                                          },
                                        ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            AppButton(
                                                onTap: () {
                                                  if(formKey.currentState!.validate()){
                                                  }
                                                },
                                                buttonText:
                                                S.of(context).writeReview,
                                                borderRadius: 30,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900),
                                            AppWithoutBgButton(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              textColor: ColorConstant.appBlue,
                                              borderColor: Colors.transparent,
                                              borderRadius: 30,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 14,
                                              buttonColor: ColorConstant.appBlue
                                                  .withOpacity(0.2),
                                              buttonText: S.of(context).cancel,
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          buttonText: S.of(context).courseCompleted),
                    ),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}
