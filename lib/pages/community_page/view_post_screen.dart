import 'dart:io';
import 'package:easy_grade/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../constant/color_constant.dart';
import '../../generated/l10n.dart';
import '../../provider/community_provider.dart';
import '../../utills/app_logs.dart';
import '../../widgets/app_button.dart';
import '../../model/community_model.dart';
import '../../widgets/app_photo_view.dart';

class ViewPostScreen extends StatefulWidget {
  final GetAllCommunity? question;
  final String? topicId;

  const ViewPostScreen({Key? key, this.question,this.topicId}) : super(key: key);

  @override
  ViewPostScreenState createState() => ViewPostScreenState();
}

class ViewPostScreenState extends State<ViewPostScreen> {
  File? image;

  TextEditingController messageSendingController = TextEditingController();
  List<String>? contentsList;

  @override
  void initState() {
    // TODO: implement initState
    contentsList = widget.question?.tags.toString().split(',');
    print("------->${widget.question?.id}");
    CommunityProvider communityProvider =
        Provider.of<CommunityProvider>(context, listen: false);
    communityProvider.getAnswerCommunity(context,
        communityId: widget.question?.id.toString());
    communityProvider.communityView(context,
        communityId: widget.question?.id.toString(),topicId: widget.topicId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, CommunityProvider communityProvider, _) {
      return Scaffold(
        backgroundColor: ColorConstant.appWhite,
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: ColorConstant.appBlack,
          ),
          titleSpacing: 0,
          backgroundColor: ColorConstant.appWhite,
          title: AppText(
            text: S.of(context).viewQuestion,
            textColor: ColorConstant.appThemeColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 60,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  widget.question!.profile !=
                                          'https://easygrade.online/public/uploads/profile/'
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              widget.question!.profile!),
                                          radius: 22,
                                        )
                                      : const CircleAvatar(
                                          radius: 22,
                                          backgroundColor:
                                              ColorConstant.appBlue,
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        AppText(
                                            text: widget.question!.name,
                                            fontSize: 15,
                                            textColor: ColorConstant.appBlack,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: .4),
                                        const SizedBox(height: 2.0),
                                        AppText(
                                          text: widget.question?.createdAt!
                                              .toString()
                                              .substring(0, 10),
                                          textColor:
                                              Colors.grey.withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              // Icon(
                              //   CupertinoIcons.bookmark,
                              //   color: Colors.grey.withOpacity(0.6),
                              //   size: 26,
                              // )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: AppText(
                            text: widget.question!.title,
                            fontSize: 17,
                            maxLines: 5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.question!.description.toString(),
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14,
                              letterSpacing: .2),
                        ),
                        if (widget.question!.files != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap :()
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AppPhotoView(
                                              url: widget.question!.files,
                                            )));
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                widget.question!.files!),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        (widget.question?.tags == null)
                            ? SizedBox()
                            : Container(
                                height: 40,
                                margin: EdgeInsets.only(
                                    top:
                                        widget.question!.files == null ? 15 : 5,
                                    bottom: 10),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: contentsList!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          left: index == 0 ? 0 : 10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: AppText(
                                          text: contentsList![index],
                                          textColor: Colors.black38,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 5.0),
                  child: AppText(
                    text:
                        "${S.of(context).replies1}  (${communityProvider.answerList.length})",
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.black,
                  ),
                ),
                Column(
                  children: communityProvider.answerList
                      .map((GetAllCommunity reply) => Container(
                          margin: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26.withOpacity(0.15),
                                  offset: const Offset(0.0, 6.0),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.10)
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          reply.profile !=
                                                  'https://easygrade.online/public/uploads/profile/'
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      reply.profile.toString()),
                                                  radius: 18,
                                                )
                                              : const CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      ColorConstant.appBlue,
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
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
                                                      0.6,
                                                  child: AppText(
                                                    text: reply.name.toString(),
                                                    letterSpacing: .4,
                                                    textColor:
                                                        ColorConstant.appBlack,
                                                  ),
                                                ),
                                                const SizedBox(height: 2.0),
                                                AppText(
                                                  text: reply.createdAt!
                                                      .toString()
                                                      .substring(0, 10),
                                                  textColor: Colors.grey
                                                      .withOpacity(0.8),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      if (reply.userId == userInfo?.id)
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                communityProvider
                                                    .updateAnswerCommunity(
                                                        context,
                                                        netWorkImage:
                                                            reply.files,
                                                        editId:
                                                            reply.id.toString(),
                                                        editDec:
                                                            reply.description,
                                                        answerId: widget
                                                            .question!.id
                                                            .toString());
                                              },
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color: Colors.grey
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            const SizedBox(width: 3.0),
                                            GestureDetector(
                                              onTap: () async {
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              titlePadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30)),
                                                              title: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: const BoxDecoration(
                                                                    color: ColorConstant
                                                                        .appLightBlue,
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                30),
                                                                        topLeft:
                                                                            Radius.circular(30))),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: AppText(
                                                                  text: S
                                                                      .of(context)
                                                                      .delete,
                                                                  textColor:
                                                                      ColorConstant
                                                                          .appWhite,
                                                                ),
                                                              ),
                                                              content: AppText(
                                                                text: S
                                                                    .of(context)
                                                                    .deleteAnswerMsg,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 3,
                                                              ),
                                                              actions: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    AppButton(
                                                                      height:
                                                                          40,
                                                                      width: 80,
                                                                      buttonText: S
                                                                          .of(context)
                                                                          .no,
                                                                      fontSize:
                                                                          12,
                                                                      borderRadius:
                                                                          10,
                                                                      onTap: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                    ),
                                                                    AppButton(
                                                                      height:
                                                                          40,
                                                                      width: 80,
                                                                      buttonText: S
                                                                          .of(context)
                                                                          .yes,
                                                                      fontSize:
                                                                          12,
                                                                      borderRadius:
                                                                          10,
                                                                      onTap:
                                                                          () {
                                                                        communityProvider.deleteAnswerCommunity(
                                                                            context,
                                                                            communityId:
                                                                                reply.id.toString(),
                                                                            getAnsId: widget.question!.id.toString());
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
                                                color: Colors.grey
                                                    .withOpacity(0.6),
                                                // size: 26,
                                              ),
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: AppText(
                                      text: reply.description,
                                      textColor: Colors.black.withOpacity(0.7),
                                      maxLines: 2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: .2),
                                ),
                                InkWell(
                                  onTap: () {
                                    communityProvider.likeCommunity(context,
                                        communityId: "0",
                                        communityAnsId: reply.id.toString(),
                                        getListAnswerId:
                                            widget.question!.id.toString());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        CupertinoIcons.hand_thumbsup,
                                        color: Colors.grey.withOpacity(0.5),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        "${reply.liked}",
                                        style: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )))
                      .toList(),
                ),
                const SizedBox(height: 170)
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                height: image == null ? 80 : 170,
                alignment: Alignment.bottomCenter,
                color: ColorConstant.appWhite,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AppPhotoView(
                                            fileImage: image,
                                            url: '',
                                          )));
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(0.5),
                                    image: DecorationImage(
                                      image: FileImage(image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -20,
                                  top: -5,
                                  child: GestureDetector(
                                    onTap: () async {
                                      image = null;
                                      setState(() => image);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      color: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5,horizontal: 5),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: const Icon(Icons.close,size: 15,color: ColorConstant.appWhite,),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Container(
                            //   height: 70,
                            //   width: 70,
                            //   margin: const EdgeInsets.symmetric(vertical: 10),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10),
                            //     color: Colors.grey.withOpacity(0.5),
                            //     image: DecorationImage(
                            //       image: FileImage(image!),
                            //       fit: BoxFit.cover,
                            //     ),
                            //   ),
                            // ),
                          )
                        : Container(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            autofocus: false,
                            controller: messageSendingController,
                            decoration: InputDecoration(
                              hintText: S.of(context).replyMessage,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: ColorConstant.appBlue, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: GestureDetector(
                                onTap: () async {
                                  await getImageFromCamera();
                                  setState(() => image);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.attach_file_sharp,
                                    color: ColorConstant.appThemeColor,
                                  ),
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  await communityProvider.addAnswerCommunity(
                                      context,
                                      communityId:
                                          widget.question!.id.toString(),
                                      ansImage: image?.path,
                                      dec: messageSendingController.text);
                                  image = null;
                                  messageSendingController.clear();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorConstant.appBlue),
                                    child: const Icon(
                                      Icons.send,
                                      size: 20,
                                      color: ColorConstant.appWhite,
                                    )),
                              ),
                              hintStyle: TextStyle(
                                color: ColorConstant.appThemeColor
                                    .withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Future getImageFromCamera() async {
    var x = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = File(x!.path);
  }
}
