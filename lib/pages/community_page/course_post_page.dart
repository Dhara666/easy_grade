import 'package:easy_grade/pages/community_page/view_post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/color_constant.dart';
import '../../generated/l10n.dart';
import '../../provider/community_provider.dart';
import '../../widgets/app_text.dart';

class CoursePostPage extends StatefulWidget {
  final String? topicId;
  final String? topicName;
  const CoursePostPage({Key? key, this.topicId,this.topicName}) : super(key: key);

  @override
  State<CoursePostPage> createState() => _CoursePostPageState();
}

class _CoursePostPageState extends State<CoursePostPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("--->widget.topicId ${widget.topicId}");
    CommunityProvider communityProvider =
    Provider.of<CommunityProvider>(context, listen: false);
    communityProvider.getCourseCommunity(context,topicId:widget.topicId);
  }

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
            text: widget.topicName,
            textColor: ColorConstant.appThemeColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      body: Consumer(
        builder: (context,CommunityProvider communityProvider,_) {
          return communityProvider.courseCommunityList.isEmpty ?
               const Center(child: AppText(text: "No data available"))
              :
            Column(
              children:
              communityProvider.courseCommunityList.map<Widget>((question) =>
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ViewPostScreen(
                                question: question,
                                 topicId:widget.topicId,
                              )
                          )
                      );
                    },
                    child: Container(
                      height: 180,
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow:  [
                            BoxShadow(
                                color: Colors.black26.withOpacity(0.12),
                                offset: const Offset(0.0,6.0),
                                blurRadius: 10.0,
                                spreadRadius: 0.10
                            )]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 72,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      question.profile != 'https://easygrade.online/public/uploads/profile/' ?  CircleAvatar(
                                        backgroundImage:
                                        NetworkImage(question.profile!),
                                        radius: 22,
                                      ): const CircleAvatar(
                                        radius: 22,
                                        backgroundColor: ColorConstant.appBlue,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.65,
                                              child: AppText(
                                                text: question.title ?? '',
                                                fontSize: 16,
                                                textColor: ColorConstant.appBlack,
                                              ),
                                            ),
                                            const SizedBox(height: 2.0),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.7,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    fit: FlexFit.loose,
                                                    child: AppText(
                                                      text: question.name,
                                                      textColor: Colors.grey
                                                          .withOpacity(0.8),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  AppText(
                                                    text: question.createdAt!.toString().substring(0,10),
                                                    textColor: Colors.grey
                                                        .withOpacity(0.8),
                                                    fontWeight: FontWeight.w500,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Expanded(
                                  //   child: Icon(
                                  //     CupertinoIcons.bookmark,
                                  //     color: Colors.grey.withOpacity(0.6),
                                  //     size: 26,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            AppText(
                                text: question.description!,
                                textColor: Colors.black.withOpacity(0.7),
                                maxLines: 2,
                                fontWeight: FontWeight.w500,
                                letterSpacing: .2
                             ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                       communityProvider.likeCommunity(context, communityId:question.id.toString(), communityAnsId: "0",getCourseId:widget.topicId);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        CupertinoIcons.hand_thumbsup,
                                        color: Colors.grey.withOpacity(0.8),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 4.0),
                                      AppText(
                                        text: "${question.liked} ${S.of(context).votes}",
                                        textColor: Colors.grey.withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      CupertinoIcons.captions_bubble,
                                      color: Colors.grey.withOpacity(0.8),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4.0),
                                    AppText(
                                      text:  "${0} ${S.of(context).replies}",
                                      textColor: Colors.grey.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.grey.withOpacity(0.8),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 4.0),
                                    AppText(
                                      text: "${question.views} ${S.of(context).views}",
                                      textColor: Colors.grey.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              ).toList()
          );
        }
      )
    );
  }
}
