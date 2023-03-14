import 'dart:math';

import 'package:easy_grade/constant/color_constant.dart';
import 'package:easy_grade/model/community_model.dart';
import 'package:easy_grade/pages/community_page/course_post_page.dart';
import 'package:easy_grade/pages/community_page/view_post_screen.dart';
import 'package:easy_grade/provider/course_provider.dart';
import 'package:easy_grade/utills/app_logs.dart';
import 'package:easy_grade/widgets/app_button.dart';
import 'package:easy_grade/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../provider/community_provider.dart';
import '../../widgets/app_image_assets.dart';
import 'community_profile_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  bool isSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    CourseProvider courseProvider =
        Provider.of<CourseProvider>(context, listen: false);
    courseProvider.getCourse(context);
    CommunityProvider communityProvider =
        Provider.of<CommunityProvider>(context, listen: false);
    communityProvider.getAllCommunity(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (context, CommunityProvider communityProvider,
        CourseProvider courseProvider, _) {
      return Scaffold(
        backgroundColor: ColorConstant.appBlue,
        body: Stack(
          children: [
            loginBody(communityProvider, courseProvider),
            logo(communityProvider),
          ],
        ),
      );
    });
  }

  Widget logo(CommunityProvider communityProvider) {
    return Container(
      height: 180,
      padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: ColorConstant.appWhite,
                  size: 28,
                ),
              ),
              profile(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !isSearch
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: userInfo?.name,
                              textColor: ColorConstant.appWhite,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            AppText(
                              text: S.of(context).findTopic,
                              textColor: ColorConstant.appWhite,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          autofocus: true,
                          controller:
                              communityProvider.searchCommunityController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorConstant.appWhite, width: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorConstant.appWhite, width: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorConstant.appWhite, width: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                            hintText:S.of(context).search,
                            hintStyle: const TextStyle(
                              color: ColorConstant.appWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            // border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                            color: ColorConstant.appWhite,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (value) {
                            communityProvider.onSearchCommunity(value);
                          },
                        ),
                      ),
                    ),
              GestureDetector(
                onTap: () {
                  isSearch = !isSearch;
                  if (isSearch == false) {
                    communityProvider.searchCommunityController.clear();
                    communityProvider.searchCommunityList.clear();
                  }
                  // ignore: invalid_use_of_visible_for_testing_member
                  communityProvider.notifyListeners();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isSearch ? Icons.close : Icons.search,
                    color: ColorConstant.appWhite,
                    size: 30,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget profile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contents) => const CommunityProfilePage()));
      },
      child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xffb3c3f5), width: 1)),
          margin: const EdgeInsets.only(top: 15, bottom: 18),
          height: 40,
          width: 40,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: AppImageAsset(
                isWebImage: true,
                image: userInfo?.profile,
                webFit: BoxFit.cover,
              ))),
    );
  }

  Widget loginBody(
      CommunityProvider communityProvider, CourseProvider courseProvider) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 190,
      margin: const EdgeInsets.only(top: 190),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: SingleChildScrollView(
        primary: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CommunityProfilePage()));
              },
              child:  Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, top: 15,left: 10),
                    child: Text(
                      S.of(context).askQuestion,
                      style: const TextStyle(
                        shadows: [
                          Shadow(
                              color: ColorConstant.appBlue,
                              offset: Offset(0, -5))
                        ],
                        color: Colors.transparent,
                        decoration:
                        TextDecoration.underline,
                        decorationColor: ColorConstant.appBlue,
                        decorationThickness: 4,
                      ),
                    ),
                  )),
            ),
            popularTopic(courseProvider),
            popularTopics(courseProvider),
            trendingPost(),
            postList(communityProvider),
          ],
        ),
      ),
    );
  }

  popularTopic(CourseProvider courseProvider) {
    return (courseProvider.myCourseDetail.isEmpty || isSearch)
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20,top: 5),
            child: AppText(
              text: S.of(context).popularTopics,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textColor: ColorConstant.appBlack,
            ),
          );
  }

  popularTopics(CourseProvider courseProvider) {
    return (courseProvider.myCourseDetail.isEmpty || isSearch)
        ? SizedBox()
        : SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: courseProvider.myCourseDetail.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CoursePostPage(
                                topicId: courseProvider.myCourseDetail[index].id
                                    .toString(),
                                topicName: courseProvider
                                    .myCourseDetail[index].topicName)));
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(left: 20.0),
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppText(
                                text: courseProvider
                                    .myCourseDetail[index].topicName,
                                textColor: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                maxLines: 2,
                                // maxLines: 2,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${courseProvider.myCourseDetail[index].totalCommunity}  ${S.of(context).questions}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 1.2),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20.0),
                        height: 35,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.09),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          height: 60,
                          width: 65,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.09),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  trendingPost() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
      child: AppText(
        text: S.of(context).trendingPosts,
        fontSize: 18,
        fontWeight: FontWeight.w900,
        textColor: ColorConstant.appBlack,
      ),
    );
  }

  postList(CommunityProvider communityProvider) {
    List<GetAllCommunity> myList =
        (communityProvider.searchCommunityList.isNotEmpty ||
                communityProvider.searchCommunityController.text.isNotEmpty)
            ? communityProvider.searchCommunityList
            : communityProvider.allCommunityList;
    return myList.isEmpty
        ?  Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(child: AppText(text :S.of(context).noQuestionAvailable)),
        )
        : Column(
            children: myList
                .map<Widget>((question) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ViewPostScreen(
                                      question: question,
                                    )));
                      },
                      child: Container(
                        height: 180,
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26.withOpacity(0.12),
                                  offset: const Offset(0.0, 6.0),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.10)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 72,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        question.profile !=
                                                'https://easygrade.online/public/uploads/profile/'
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    question.profile!),
                                                radius: 22,
                                              )
                                            : const CircleAvatar(
                                                radius: 22,
                                                backgroundColor:
                                                    ColorConstant.appBlue,
                                              ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.70,
                                                child: AppText(
                                                  text: question.title ?? '',
                                                  fontSize: 16,
                                                  textColor:
                                                      ColorConstant.appBlack,
                                                ),
                                              ),
                                              const SizedBox(height: 2.0),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      fit: FlexFit.loose,
                                                      child: AppText(
                                                        text: question.name,
                                                        textColor: Colors.grey
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    AppText(
                                                      text: question.createdAt!
                                                          .toString()
                                                          .substring(0, 10),
                                                      textColor: Colors.grey
                                                          .withOpacity(0.8),
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                  letterSpacing: .2),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      communityProvider.likeCommunity(context,
                                          communityId: question.id.toString(),
                                          communityAnsId: "0");
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          CupertinoIcons.hand_thumbsup,
                                          color: Colors.grey.withOpacity(0.8),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4.0),
                                        AppText(
                                          text:
                                              "${question.liked} ${S.of(context).votes}",
                                          textColor:
                                              Colors.grey.withOpacity(0.8),
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
                                        text: "${0} ${S.of(context).replies}",
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
                    ))
                .toList());
  }
}
