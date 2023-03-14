import 'dart:convert';
import 'dart:io';
import 'package:easy_grade/widgets/app_loader.dart';
import 'package:easy_grade/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constant/color_constant.dart';
import '../generated/l10n.dart';
import '../model/community_model.dart';
import '../model/course_model.dart';
import '../services/rest_service.dart';
import '../utills/app_logs.dart';
import '../utills/app_validation.dart';
import '../widgets/app_button.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_photo_view.dart';
import '../widgets/app_text_field.dart';
import 'course_provider.dart';
import 'help_center_provider.dart';

class CommunityProvider extends ChangeNotifier {
  bool isLoading = false;
  List<UserCommunity> userCommunityList = [];
  List<GetAllCommunity> allCommunityList = [];
  List<GetAllCommunity> searchCommunityList = [];
  List<GetAllCommunity> answerList = [];
  List<CommunityAnswer> userAnswerList = [];
  List<GetAllCommunity> courseCommunityList = [];
  final formKey = GlobalKey<FormState>();
  final formEditDecKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController decController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController answerDecController = TextEditingController();
  TextEditingController searchCommunityController = TextEditingController();
  TextEditingController communityDecController = TextEditingController();
  File? image;
  File? answerImage;
  CourseDetail? dropDownValue;
  CommunityProfileData? communityProfile;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  onSearchCommunity(String text) async {
    searchCommunityList.clear();
    if (text.isEmpty) {
      notifyListeners();
      return;
    }
    for (var documentModel in allCommunityList) {
      if (documentModel.title!.toLowerCase().contains(text.toLowerCase())) {
        searchCommunityList.add(documentModel);
        print("--->searchCommunityList${searchCommunityList.length}");
      }
    }
    notifyListeners();
  }

  Future getImage({bool isAnswerImg = false}) async {
    var x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (isAnswerImg) {
      answerImage = File(x!.path);
    } else {
      image = File(x!.path);
    }
  }

  addCommunity(
    context,CourseProvider courseProvider, {
    bool isEdit = false,
    String? editTitle,
    String? editDec,
    String? netWorkImage,
    String? editId,
  }) async {
    if (isEdit) {
      titleController.text = editTitle ?? '';
      decController.text = editDec ?? '';
    }
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return AppDialog(
                titleMsg: isEdit
                    ? S.of(context).editCommunity
                    : S.of(context).addCommunity,
                alertWidget: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              validator: (value) => emptyValidator(
                                  value!, S.of(context).validCommunityTitle),
                              controller: titleController,
                              margin: const EdgeInsets.only(bottom: 5),
                              fillColor:
                                  ColorConstant.appBlue.withOpacity(0.06),
                              hint: S.of(context).enterTitle,
                              enabledBorder: AppTextField.appOutlineInputBorder(
                                  color: ColorConstant.appGrey),
                              focusedBorder:
                                  AppTextField.appOutlineInputBorder(),
                              focusedErrorBorder:
                                  AppTextField.appOutlineInputBorder(
                                      color: Colors.red),
                              errorBorder: AppTextField.appOutlineInputBorder(
                                  color: Colors.red),
                            ),
                            AppTextField(
                              validator: (value) => emptyValidator(
                                  value!, S.of(context).validCommunityDec),
                              controller: decController,
                              margin: const EdgeInsets.only(top: 5),
                              fillColor:
                                  ColorConstant.appBlue.withOpacity(0.06),
                              hint: S.of(context).enterDec,
                              enabledBorder: AppTextField.appOutlineInputBorder(
                                  color: ColorConstant.appGrey),
                              focusedBorder:
                                  AppTextField.appOutlineInputBorder(),
                              focusedErrorBorder:
                                  AppTextField.appOutlineInputBorder(
                                      color: Colors.red),
                              errorBorder: AppTextField.appOutlineInputBorder(
                                  color: Colors.red),
                              maxLines: 3,
                            ),
                            editId != null  ? const SizedBox() : AppTextField(
                              validator: (value) => emptyValidator(
                                  value!, S.of(context).validCommunityDec),
                              controller: tagController,
                              margin: const EdgeInsets.only(top: 5),
                              fillColor:
                              ColorConstant.appBlue.withOpacity(0.06),
                              hint: S.of(context).enterTag,
                              enabledBorder: AppTextField.appOutlineInputBorder(
                                  color: ColorConstant.appGrey),
                              focusedBorder:
                              AppTextField.appOutlineInputBorder(),
                              focusedErrorBorder:
                              AppTextField.appOutlineInputBorder(
                                  color: Colors.red),
                              errorBorder: AppTextField.appOutlineInputBorder(
                                  color: Colors.red),
                              maxLines: 2,
                            ),
                            SizedBox(height:  editId != null  ? 0:15 ),
                            editId != null  ? const SizedBox() :
                            DropdownButtonFormField<CourseDetail>(
                              isExpanded: true,
                               decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),),
                                hint: const Text('Select course'),
                                validator: (value) {
                                  if (value  == null) {
                                    return 'Please select course';
                                  }
                                },
                                items: courseProvider.myCourseDetail.map((CourseDetail lang) {
                                  return DropdownMenuItem<CourseDetail>(
                                    value: lang,
                                    child: Text(lang.topicName!),
                                  );
                                }).toList(),
                                value: dropDownValue,
                                onChanged: (val) {
                                  dropDownValue = val;
                                  setState(() => dropDownValue);
                                },
                            ),
                            netWorkImage != null
                                ? GestureDetector(
                                 onTap: (){
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                           builder: (context) => AppPhotoView(
                                             url: netWorkImage,
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
                                            image:  NetworkImage(netWorkImage!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: -20,
                                        top: -5,
                                        child: GestureDetector(
                                          onTap: () async {
                                            netWorkImage = null;
                                            setState(() => netWorkImage);
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
                                      )
                                    ],
                                  ),
                                )
                                : image != null
                                    ? GestureDetector(
                                   onTap: (){
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
                                    )
                                    : GestureDetector(
                                        onTap: () async {
                                          await getImage();
                                          setState(() => image);
                                        },
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          child: const Icon(
                                            Icons.file_present_outlined,
                                            color: ColorConstant.appThemeColor,
                                          ),
                                        ),
                                      )
                          ],
                        ),
                      ),
                      AppButton(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              if (editId != null) {
                                await addUserCommunity(context,
                                    communityId: editId);
                              } else {
                                await addUserCommunity(context);
                                dropDownValue = null;
                              }
                            }
                          },
                          buttonText: isEdit
                              ? S.of(context).update
                              : S.of(context).save,
                          borderRadius: 30,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                      AppWithoutBgButton(
                        onTap: () {
                          image = null;
                          netWorkImage = null;
                          titleController.clear();
                          decController.clear();
                          tagController.clear();
                          Navigator.pop(context);
                        },
                        textColor: ColorConstant.appBlue,
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        buttonColor: ColorConstant.appBlue.withOpacity(0.2),
                        buttonText: S.of(context).cancel,
                      )
                    ],
                  ),
                ),
              );
            })
    );
  }

  Future<void> getUserCommunity(context) async {
    userCommunityList.clear();
    isLoading = true;
    // userCommunityList.clear();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getUserCommunity, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          UserCommunityModel userCommunityModel =
              userCommunityModelFromJson(validateUser);
          if (userCommunityModel.userCommunity != null &&
              userCommunityModel.userCommunity!.isNotEmpty) {
              userCommunityList = userCommunityModel.userCommunity!;
            notifyListeners();
            logs("---->userCommunityList ${userCommunityList.length}");
          }
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getUserAnswerCommunity(context) async {
    userAnswerList.clear();
    isLoading = true;
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getUserAnswerCommunity, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          CommunityAnswerModel communityAnswerModel = communityAnswerModelFromJson(validateUser);
          if (communityAnswerModel.communityAnswer != null &&
              communityAnswerModel.communityAnswer!.isNotEmpty) {
            userAnswerList = communityAnswerModel.communityAnswer!;
            notifyListeners();
            logs("---->userAnswerList ${userAnswerList.length}");
          }
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addUserCommunity(context, {String? communityId}) async {
    if(dropDownValue == null){}
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body;
      communityId != null
          ? body = {
              'user_token': userInfo!.userToken!,
              'user_id': userInfo!.id!.toString(),
              'title': titleController.text,
              'description': decController.text,
              'community_id': communityId,
            }
          : body = {
              'user_token': userInfo!.userToken!,
              'user_id': userInfo!.id!.toString(),
              'title': titleController.text,
              'description': decController.text,
              'topic_id': dropDownValue!.id.toString(),
              'tags': tagController.text,
            };

      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: communityId != null
              ? RestConstants.updateUserCommunity
              : RestConstants.addUserCommunity,
          body: body,
          isImage: true,
          filePath: image?.path,
          fileParam: 'files');
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppDialog(
                    titleMsg:S.of(context).success,
                    alertWidget: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          AppText(
                            text: validateUserMap['message'],
                            maxLines: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppButton(
                              width: 100,
                              onTap: () {
                                getUserCommunity(context);
                                getAllCommunity(context);
                                if(communityId == null)
                                {
                                  getCommunityProfile(context);
                                }
                                Navigator.pop(context);
                                Navigator.pop(context);
                                image = null;
                                titleController.clear();
                                decController.clear();
                                tagController.clear();
                              },
                              buttonText: S.of(context).ok,
                              borderRadius: 10,
                              fontSize: 14,
                              fontWeight: FontWeight.w900),
                        ],
                      ),
                    ),
                  ));
        }
        else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
        else {
          errorDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteUserCommunity(context, {String? communityId}) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'community_id': communityId!
      };

      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(
        context,
        endpoint: RestConstants.deleteUserCommunity,
        body: body,
      );
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppDialog(
                    titleMsg: S.of(context).success,
                    alertWidget: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          AppText(
                            text: validateUserMap['message'],
                            maxLines: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppButton(
                              width: 100,
                              onTap: () {
                                getUserCommunity(context);
                                getAllCommunity(context);
                                getCommunityProfile(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              buttonText: S.of(context).ok,
                              borderRadius: 10,
                              fontSize: 14,
                              fontWeight: FontWeight.w900),
                        ],
                      ),
                    ),
                  ));
        }
        else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
        else {
          errorDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAllCommunity(context) async {
    isLoading = true;
    allCommunityList.clear();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getAllCommunity, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          CommunityModel communityModel = communityModelFromJson(validateUser);
          if (communityModel.getAllCommunity != null &&
              communityModel.getAllCommunity!.isNotEmpty) {
            allCommunityList = communityModel.getAllCommunity!;
            allCommunityList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            notifyListeners();
            logs("---->allCommunityList ${allCommunityList.length}");
          }
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAnswerCommunity(context, {String? communityId}) async {
    isLoading = true;
    answerList.clear();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'community_id': communityId!
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getAnswerCommunity, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          CommunityModel communityModel = communityModelFromJson(validateUser);
          if (communityModel.getAllCommunity != null &&
              communityModel.getAllCommunity!.isNotEmpty) {
            answerList = communityModel.getAllCommunity!;
            answerList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            notifyListeners();
            logs("---->getAllCommunity ${userCommunityList.length}");
          }
        }  else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addAnswerCommunity(context,
      {String? communityId, String? ansImage, String? dec,bool isUpdate =false,String? getAnswerId}) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'description': dec!,
        'community_id': communityId!
      };

      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: isUpdate ? RestConstants.updateAnswerCommunity : RestConstants.addAnswerCommunity,
          body: body,
          isImage: true,
          filePath: ansImage,
          fileParam: 'files');
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppDialog(
                    titleMsg: S.of(context).success,
                    alertWidget: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          AppText(
                            text: validateUserMap['message'],
                            maxLines: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppButton(
                              width: 100,
                              onTap: () {
                                getAnswerCommunity(context,
                                    communityId: isUpdate ? getAnswerId:communityId);
                                Navigator.pop(context);
                                if(isUpdate){
                                  Navigator.pop(context);
                                }
                              },
                              buttonText: S.of(context).ok,
                              borderRadius: 10,
                              fontSize: 14,
                              fontWeight: FontWeight.w900),
                        ],
                      ),
                    ),
                  ));
        }
        else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
        else {
          errorDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAnswerCommunity(context,
      {String? communityId, String? getAnsId}) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'community_id': communityId!
      };

      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(
        context,
        endpoint: RestConstants.deleteAnswerCommunity,
        body: body,
      );
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppDialog(
                    titleMsg:S.of(context).success,
                    alertWidget: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          AppText(
                            text: validateUserMap['message'],
                            maxLines: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppButton(
                              width: 100,
                              onTap: () {
                                getAnswerCommunity(context,
                                    communityId: getAnsId);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              buttonText: S.of(context).ok,
                              borderRadius: 10,
                              fontSize: 14,
                              fontWeight: FontWeight.w900),
                        ],
                      ),
                    ),
                  ));
        }
        else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
        else {
          errorDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  updateAnswerCommunity(
    context, {
    String? editDec,
    String? netWorkImage,
    String? editId,
    String? answerId,
  }) async {
    answerDecController.text = editDec ?? '';
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return AppDialog(
                titleMsg: "Update Answer",
                alertWidget: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              validator: (value) => emptyValidator(
                                  value!, S.of(context).validCommunityDec),
                              controller: answerDecController,
                              margin: const EdgeInsets.only(top: 5),
                              fillColor:
                                  ColorConstant.appBlue.withOpacity(0.06),
                              hint: "Enter description",
                              enabledBorder: AppTextField.appOutlineInputBorder(
                                  color: ColorConstant.appGrey),
                              focusedBorder:
                                  AppTextField.appOutlineInputBorder(),
                              focusedErrorBorder:
                                  AppTextField.appOutlineInputBorder(
                                      color: Colors.red),
                              errorBorder: AppTextField.appOutlineInputBorder(
                                  color: Colors.red),
                              maxLines: 3,
                            ),
                            netWorkImage != null
                                ? GestureDetector(
                                    onTap: () async {
                                      await getImage(isAnswerImg: true);
                                      setState(() => answerImage);
                                      if (answerImage != null) {
                                        netWorkImage = null;
                                      }
                                    },
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(0.5),
                                        image: DecorationImage(
                                          image: NetworkImage(netWorkImage!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : answerImage != null
                                    ? GestureDetector(
                                        onTap: () async {
                                          await getImage(isAnswerImg: true);
                                          setState(() => answerImage);
                                        },
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.withOpacity(0.5),
                                            image: DecorationImage(
                                              image: FileImage(answerImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          await getImage(isAnswerImg: true);
                                          setState(() => answerImage);
                                        },
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          child: const Icon(
                                            Icons.file_present_outlined,
                                            color: ColorConstant.appThemeColor,
                                          ),
                                        ),
                                      )
                          ],
                        ),
                      ),
                      AppButton(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await addAnswerCommunity(context,communityId: editId,dec: answerDecController.text,ansImage: answerImage?.path,getAnswerId: answerId,isUpdate: true);
                            }
                          },
                          buttonText: S.of(context).update,
                          borderRadius: 30,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                      AppWithoutBgButton(
                        onTap: () {
                          answerImage = null;
                          netWorkImage = null;
                          answerDecController.clear();
                          Navigator.pop(context);
                        },
                        textColor: ColorConstant.appBlue,
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        buttonColor: ColorConstant.appBlue.withOpacity(0.2),
                        buttonText: S.of(context).cancel,
                      )
                    ],
                  ),
                ),
              );
            }));
  }


  Future<void> likeCommunity(context,
      {String? communityId, String? communityAnsId,String? getListAnswerId,String? getCourseId}) async {
    isLoading = true;
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'community_id': communityId!,
        'community_ans_id':communityAnsId!
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.like, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppDialog(
                titleMsg:S.of(context).success,
                alertWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    children: [
                      AppText(
                        text: validateUserMap['message'],
                        maxLines: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                          width: 100,
                          onTap: () {
                            if(communityId != "0"){
                              getAllCommunity(context);
                              if(getCourseId != null){
                                 getCourseCommunity(context,topicId:getCourseId);
                              }
                            }
                            else{
                              getAnswerCommunity(context,
                                  communityId: getListAnswerId);
                            }

                            Navigator.pop(context);

                          },
                          buttonText: S.of(context).ok,
                          borderRadius: 10,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    ],
                  ),
                ),
              ));
        }
        else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }


  Future<void> getCourseCommunity(context,{String? topicId}) async {
    courseCommunityList.clear();
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'topic_id':topicId!
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.getCourseCommunity, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          CommunityModel communityModel = communityModelFromJson(validateUser);
          if (communityModel.getAllCommunity != null &&
              communityModel.getAllCommunity!.isNotEmpty) {
            courseCommunityList = communityModel.getAllCommunity!;
            courseCommunityList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            notifyListeners();
            logs("---->courseCommunityList ${courseCommunityList.length}");
          }
        }  else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getCommunityProfile(context) async {
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.communityProfile, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          CommunityProfileModel communityProfileModel = communityProfileModelFromJson(validateUser);
          if (communityProfileModel.communityProfileData != null) {
            communityProfile = communityProfileModel.communityProfileData!;
            notifyListeners();
            logs("---->userCommunityList ${communityProfile}");
          }
        }  else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
        else {
          errorDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
  }

 updateCommDescription(
      context, {
        String? editDec,
      }) async {
      communityDecController.text = ((editDec == "null" || editDec == null) ? "" : editDec) ;
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
          return AppDialog(
            titleMsg:  S.of(context).editDec,
            alertWidget: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: formEditDecKey,
                child: Column(
                  children: [
                    AppTextField(
                      maxLines: 5,
                      validator: (value) => emptyValidator(
                          value!, S.of(context).validCommunityTitle),
                      controller: communityDecController,
                      margin: const EdgeInsets.only(bottom: 5),
                      fillColor:
                      ColorConstant.appBlue.withOpacity(0.06),
                      hint: S.of(context).enterDec,
                      enabledBorder: AppTextField.appOutlineInputBorder(
                          color: ColorConstant.appGrey),
                      focusedBorder:
                      AppTextField.appOutlineInputBorder(),
                      focusedErrorBorder:
                      AppTextField.appOutlineInputBorder(
                          color: Colors.red),
                      errorBorder: AppTextField.appOutlineInputBorder(
                          color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                     AppButton(
                        onTap: ()  async {
                          if (formEditDecKey.currentState!.validate()) {
                             FocusScope.of(context).requestFocus(FocusNode());
                             await updateCommDescriptionApi(context);
                           }
                        },
                        buttonText: S.of(context).update,
                        borderRadius: 30,
                        fontSize: 14,
                        fontWeight: FontWeight.w900),
                    AppWithoutBgButton(
                      onTap: () {
                        communityDecController.clear();
                        Navigator.pop(context);
                      },
                      textColor: ColorConstant.appBlue,
                      borderColor: Colors.transparent,
                      borderRadius: 30,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      buttonColor: ColorConstant.appBlue.withOpacity(0.2),
                      buttonText: S.of(context).cancel,
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  Future<void> updateCommDescriptionApi(context) async {
    isLoading = true;
    notifyListeners();
    print("---->isLoading $isLoading");
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'comm_desc': communityDecController.text
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.communityDescription, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppDialog(
                titleMsg: S.of(context).success,
                alertWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0,left: 5,right: 5),
                  child: Column(
                    children: [
                      AppText(
                        textAlign: TextAlign.center,
                        text: validateUserMap['message'],
                        maxLines: 10,
                      ),
                      const SizedBox(height: 15,),
                      SizedBox(
                        width: 150,
                        child: AppButton(
                          buttonText:S.of(context).ok,
                          onTap: (){
                            getCommunityProfile(context);
                            Navigator.pop(context);
                            Navigator.pop(context);

                          },
                        ),
                      )
                    ],
                  ),
                ),
              ));
        }
        else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
        else {
          errorDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> communityView(context, {String? communityId,String? topicId}) async {
    print("---->communityId ${communityId}");
    isLoading = true;
    try {
      Map<String, String> body = {
        'user_token': userInfo!.userToken!,
        'user_id': userInfo!.id!.toString(),
        'community_id': communityId!
      };
      logs('body --> $body');
      String? validateUser = await RestServices.postRestCall(context,
          endpoint: RestConstants.communityView, body: body);
      if (validateUser != null && validateUser.isNotEmpty) {
        Map<String, dynamic> validateUserMap = jsonDecode(validateUser);
        if (validateUserMap.isNotEmpty && validateUserMap['status'] == true) {
          getAllCommunity(context);
          if(topicId != null){
            getCourseCommunity(context,topicId:topicId);
          }
         } else if(validateUserMap['status'] == false && validateUserMap['message'] == "Unauthorized access!") {
          logOutDialog(context, validateUserMap['message']);
        }
      }
    } on SocketException catch (e) {
      logs('Socket exception -------> ${e.message}');
    }
    isLoading = false;
    notifyListeners();
  }


}
