import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../constant/color_constant.dart';
import '../generated/l10n.dart';
import '../model/form_chat_list_model.dart';
import '../provider/help_center_provider.dart';
import '../widgets/app_text.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => ChatListPageState();
}

class ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HelpCenterProvider helpCenterProvider =
    Provider.of<HelpCenterProvider>(context, listen: false);
    helpCenterProvider.getFormData(context);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,HelpCenterProvider helpCenterProvider,_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(
              color: ColorConstant.appBlack,
            ),
            titleSpacing: 0,
            backgroundColor: ColorConstant.appWhite,
            title: const AppText(
              text: "Chat List",
              textColor: ColorConstant.appThemeColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          body: helpCenterProvider.chatListData.isEmpty ? Center(child: const AppText(text: "No data Available")) :
          ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: helpCenterProvider.chatListData.length,
            itemBuilder: (BuildContext c, int index) {
              FormChatList courseDetail = helpCenterProvider.chatListData[index];
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      child: AppText(
                                        text: "Email: " ,
                                        textColor:
                                        ColorConstant.appBlack,
                                        maxLines: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: AppText(
                                         text: courseDetail.email,
                                        textColor:
                                        ColorConstant.appBlack,
                                        maxLines: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      child: AppText(
                                        text: "Phone: " ,
                                        textColor:
                                        ColorConstant.appBlack,
                                        maxLines: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: AppText(
                                        text: courseDetail.phone,
                                        textColor:
                                        ColorConstant.appBlack,
                                        maxLines: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      child: AppText(
                                        text: "Subject: " ,
                                        textColor:
                                        ColorConstant.appBlack,
                                        maxLines: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: AppText(
                                        text: courseDetail.subject,
                                        textColor:
                                        ColorConstant.appBlack,
                                        maxLines: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      child: AppText(
                                        text: "Message: " ,
                                        textColor:
                                        ColorConstant.appBlack,
                                        maxLines: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: AppText(
                                        text: courseDetail.message,
                                        textColor:
                                        ColorConstant.appBlack,
                                        maxLines: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              );
            },
          ),
        );
      }
    );
  }
}
