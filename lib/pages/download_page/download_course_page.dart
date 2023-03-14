import 'dart:convert';

import 'package:easy_grade/pages/download_page/download_page.dart';
import 'package:easy_grade/widgets/app_image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/color_constant.dart';
import '../../generated/l10n.dart';
import '../../model/course_video_model.dart';
import '../../shared_preference/shared_preference.dart';
import '../../widgets/app_text.dart';

class DownloadCoursePage extends StatefulWidget {
  const DownloadCoursePage({Key? key}) : super(key: key);

  @override
  State<DownloadCoursePage> createState() => _DownloadCoursePageState();
}

class _DownloadCoursePageState extends State<DownloadCoursePage> {
  List<Video>? uniquelist;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    List<Video> videoList = [];
    final prefs = await SharedPreferences.getInstance();
    List<String>? decodedRestaturantsString = prefs.getStringList(downloadList);
    if (decodedRestaturantsString != null) {
      videoList = decodedRestaturantsString.map((res)=> Video.fromJson(json.decode(res))).toList();
      var seen = <String>{};
         uniquelist = videoList.where((student) => seen.add(student.topicName!)).toList();
      }
     setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: ColorConstant.appWhite,
        iconTheme: const IconThemeData(
          color: ColorConstant.appBlack,
        ),
        elevation: 0.0,
        titleSpacing: 0.0,
        title: const AppText(
            text: "DownLoad",
            fontSize: 18,
            textColor: ColorConstant.appBlack),
      ),
      body:_buildDownloadList());
  }

  Widget _buildDownloadList() {
    return (uniquelist == null || uniquelist!.isEmpty) ?
         Center(child: AppText(text :S.of(context).noAnyDownload),)
        :
      AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        physics: const BouncingScrollPhysics(
        ),
        itemCount: uniquelist?.length,
        itemBuilder: (BuildContext c, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: const Duration(milliseconds: 100),
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyDownloadPage(downloadName:uniquelist![index].topicName)));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: ColorConstant.appWhite,
                          borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AppImageAsset(
                              image: uniquelist![index].topicImage ?? AppAsset.appLogo,
                              webFit: BoxFit.fill,
                              isWebImage: true,
                            ),
                          ), // no matter how big it is, it won't overflow
                        ),
                        const SizedBox(width: 5),
                        Expanded(child: AppText(text:uniquelist![index].topicName,maxLines: 2,)),
                      ],
                    )
                    ),
                  )),
            ),
          );
        },
      ),
    );

  }
}
