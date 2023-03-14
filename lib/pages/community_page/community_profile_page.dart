import 'package:easy_grade/constant/color_constant.dart';
import 'package:easy_grade/model/community_model.dart';
import 'package:easy_grade/provider/community_provider.dart';
import 'package:easy_grade/widgets/app_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../provider/course_provider.dart';
import '../../utills/app_logs.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image_assets.dart';
import '../../widgets/app_text.dart';


class CommunityProfilePage extends StatefulWidget {
  const CommunityProfilePage({Key? key}) : super(key: key);

  @override
  State<CommunityProfilePage> createState() => _CommunityProfilePageState();
}

class _CommunityProfilePageState extends State<CommunityProfilePage> {

  @override
  void initState() {
    // TODO: implement initState
    CommunityProvider communityProvider = Provider.of<CommunityProvider>(context, listen: false);
    communityProvider.getCommunityProfile(context);
    communityProvider.getUserCommunity(context);
    communityProvider.getUserAnswerCommunity(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2(
      builder: (context, CommunityProvider communityProvider,CourseProvider courseProvider,_) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: ColorConstant.appBlue,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: ColorConstant.appBlue,
                elevation: 0.0,
              ),
              floatingActionButton: courseProvider.myCourseDetail.isEmpty ? SizedBox() :
              FloatingActionButton(
                onPressed: () async {
                  communityProvider.addCommunity(context,courseProvider);
                },
                backgroundColor: ColorConstant.appBlue,
                child: const Icon(Icons.add),
              ),
              body: ListView(
                children: [
                  logo(communityProvider),
                  recentPosts(communityProvider,courseProvider),
                ],
              ),
            ),
            communityProvider.isLoading ? const AppLoader() : const SizedBox(),
          ],
        );
      }
    );
  }

  logo(CommunityProvider communityProvider) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xffb3c3f5), width: 2)),
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  height: 70,
                  width: 70,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child:  AppImageAsset(
                        isWebImage: true,
                        image: userInfo?.profile,
                        webFit: BoxFit.cover,
                      ))),
              Positioned(
                bottom: 10,
                right: 0,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xffb3c3f5)),
                      child: const Icon(
                        Icons.edit,
                        color: ColorConstant.appBlue,
                        size: 13,
                      )),
                ),
              ),
            ],
          ),
           AppText(
            text: userInfo?.name.toString(),
            textColor: ColorConstant.appWhite,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15, top: 10),
            child: Divider(color: Color(0xffb3c3f5), height: 2),
          ),
           Row(
             children: [
               Expanded(
                 flex: 4,
                 child: AppText(
                  text: communityProvider.communityProfile?.commDesc == null ? "" : communityProvider.communityProfile?.commDesc.toString(),
                    //  "Well hello people!, I'm abdool, a greek  enthusiast eventho i don't do much codeing.",
                  textColor: ColorConstant.appWhite,
                  fontWeight: FontWeight.w300,
                  maxLines: 10,
                ),
               ),
               Stack(
                 children: [
                   InkWell(
                     onTap: () {
                       communityProvider.updateCommDescription(context,editDec :communityProvider.communityProfile?.commDesc.toString());
                     },
                     child: Container(
                         padding: const EdgeInsets.all(5),
                         decoration: const BoxDecoration(
                             shape: BoxShape.circle, color: ColorConstant.appWhite),
                         child: const Icon(
                           Icons.edit,
                           color: ColorConstant.appBlue,
                           size: 14,
                         )),
                   ),
                   communityProvider.isLoading ? AppLoader() : SizedBox()
                 ],
               ),
             ],
           ),
          Container(
            height: 80,
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
                color: const Color(0xff5680d4),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      AppText(
                        text: communityProvider.communityProfile?.totalPost ==  null ? "0" :communityProvider.communityProfile?.totalPost.toString(),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        textColor: ColorConstant.appWhite,
                      ),
                       AppText(
                        text: S.of(context).questions,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        textColor: ColorConstant.appWhite,
                      )
                    ],
                  ),
                ),
                const VerticalDivider(color: Color(0xffb3c3f5)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      AppText(
                        text:communityProvider.communityProfile?.totalReplay ==  null ? "0" : communityProvider.communityProfile?.totalReplay.toString(),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        textColor: ColorConstant.appWhite,
                      ),
                       AppText(
                        text: S.of(context).replies1,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        textColor: ColorConstant.appWhite,
                      )
                    ],
                  ),
                ),
                const VerticalDivider(color: Color(0xffb3c3f5)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                       AppText(
                        text:communityProvider.communityProfile?.totalLike ==  null? "0" : communityProvider.communityProfile?.totalLike.toString(),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        textColor: ColorConstant.appWhite,
                      ),
                      AppText(
                        text: S.of(context).votes1,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        textColor: ColorConstant.appWhite,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  recentPostText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20),
      child: AppText(
        text: text,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        textColor: ColorConstant.appBlack,
      ),
    );
  }

  recentPosts(CommunityProvider communityProvider,CourseProvider courseProvider) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          recentPostText(S.of(context).recentQuestion),
          communityProvider.userCommunityList.isNotEmpty ?
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: communityProvider.userCommunityList.length,
              shrinkWrap: true,
              primary: true,
              itemBuilder: (BuildContext context, int index) {
                communityProvider.userCommunityList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                UserCommunity question = communityProvider.userCommunityList[index];
                return Container(
                  width: MediaQuery.of(context)
                      .size
                      .width-30,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
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
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 60,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  // CircleAvatar(
                                  //   backgroundImage: AssetImage('asset/image/author6.jpg'),
                                  //   radius: 22,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.59,
                                          child: AppText(
                                            text: question.title,
                                            fontSize: 16,
                                            textColor: ColorConstant.appBlack,
                                          ),
                                        ),
                                        const SizedBox(height: 2.0),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.59,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: AppText(
                                                  text: question.description,
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
                              Row(
                                children: [
                                  // Icon(
                                  //   CupertinoIcons.bookmark,
                                  //   color: Colors.grey.withOpacity(0.6),
                                  //    // size: 26,
                                  // ),
                                  // const SizedBox(width: 3.0),
                                  GestureDetector(
                                    onTap: ()  {
                                      communityProvider.addCommunity(context,courseProvider,isEdit: true,editTitle:question.title, editDec:question.description,netWorkImage: question.files,editId:question.id.toString());
                                    },
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.grey.withOpacity(0.6),
                                       // size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  GestureDetector(
                                    onTap: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) =>
                                          AlertDialog(
                                            titlePadding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30)),
                                            title: Container(
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  color: ColorConstant.appLightBlue,
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(30),
                                                      topLeft: Radius.circular(30))),
                                              padding: const EdgeInsets.all(10),
                                              child:  AppText(
                                                text: S.of(context).delete,
                                                textColor: ColorConstant.appWhite,
                                              ),
                                            ),
                                            content: AppText(
                                              text: S.of(context).deleteMsg,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  AppButton(
                                                    height: 40,
                                                    width: 80,
                                                    buttonText: S.of(context).no,
                                                    fontSize: 12,
                                                    borderRadius: 10,
                                                    onTap: () => Navigator.pop(context),
                                                  ),
                                                  AppButton(
                                                    height: 40,
                                                    width: 80,
                                                    buttonText: S.of(context).yes,
                                                    fontSize: 12,
                                                    borderRadius: 10,
                                                    onTap: () {
                                                      communityProvider.deleteUserCommunity(context,communityId:question.id.toString()) ;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ));
                                     //
                                    },
                                    child: Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.grey.withOpacity(0.6),
                                       // size: 26,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        AppText(
                            text: question.description,
                            textColor: Colors.black.withOpacity(0.7),
                            maxLines: 2,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .2),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  CupertinoIcons.hand_thumbsup,
                                  color: Colors.grey.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 4.0),
                                AppText(
                                  // text: "${question.votes} votes",
                                  text: "${0} ${S.of(context).votes}",
                                  textColor: Colors.grey.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  CupertinoIcons.captions_bubble,
                                  color: Colors.grey.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 4.0),
                                AppText(
                                //  text: "${question.repliesCount} replies",
                                  text: "${0} ${S.of(context).replies}",
                                  textColor: Colors.grey.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: <Widget>[
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.grey.withOpacity(0.8),
                                  size: 22,
                                ),
                                const SizedBox(width: 4.0),
                                AppText(
                               //   text: "${question.views} views",
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
                );
              },
            ),
          ):
          Container(
            alignment: Alignment.center,
            height: 200,
            child:  AppText(text :S.of(context).emptyCommunity),
          ),
          recentPostText(S.of(context).yourAnswer),
          communityProvider.userAnswerList.isNotEmpty ?
          SizedBox(
            height: 200,
            width: MediaQuery.of(context)
              .size
              .width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: communityProvider.userAnswerList.length,
              shrinkWrap: true,
              primary: true,
              itemBuilder: (BuildContext context, int index) {
                communityProvider.userAnswerList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                CommunityAnswer question = communityProvider.userAnswerList[index];
                return Container(
                  width: MediaQuery.of(context)
                      .size
                      .width-30,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
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
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.6,
                                  child: AppText(
                                    text: question.description,
                                    fontSize: 16,
                                    textColor: ColorConstant.appBlack,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                SizedBox(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width-30,
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: AppText(
                                          text: question.description,
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
                        ),
                        AppText(
                            text: question.description,
                            textColor: Colors.black.withOpacity(0.7),
                            maxLines: 2,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .2),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  CupertinoIcons.hand_thumbsup,
                                  color: Colors.grey.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 10.0),
                                AppText(
                                  // text: "${question.votes} votes",
                                  text: "${0} ${S.of(context).votes}",
                                  textColor: Colors.grey.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                )
                              ],
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
                                  //  text: "${question.repliesCount} replies",
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
                                  //   text: "${question.views} views",
                                  text: "${0} ${S.of(context).views}",
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
                );
              },
            ),
          ):
          Container(
            alignment: Alignment.center,
            height: 200,
            child: AppText(text :S.of(context).emptyAnswer),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
