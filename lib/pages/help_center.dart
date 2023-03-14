import 'package:easy_grade/provider/help_center_provider.dart';
import 'package:easy_grade/utills/app_logs.dart';
import 'package:easy_grade/widgets/app_dialog.dart';
import 'package:easy_grade/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/color_constant.dart';
import '../generated/l10n.dart';
import '../utills/app_validation.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text.dart';
import 'chat_list_page.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    HelpCenterProvider helpCenterProvider =
    Provider.of<HelpCenterProvider>(context, listen: false);
    // if(helpCenterProvider.helpEmail == null || helpCenterProvider.helpNumber == null){
    helpCenterProvider.getHelpNumber(context);
   // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, HelpCenterProvider helpCenterProvider, _) {
      return Scaffold(
        backgroundColor: ColorConstant.appWhite,
        appBar: AppBar(
          backgroundColor: ColorConstant.appWhite,
          iconTheme: const IconThemeData(
            color: ColorConstant.appBlack,
          ),
          elevation: 0.0,
          titleSpacing: 0.0,
          title: AppText(
              text: S.of(context).helpCenter,
              fontSize: 18,
              textColor: ColorConstant.appBlack),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              ListTile(
                title:  AppText(text: S.of(context).email),
                leading: const Icon(
                  Icons.email,
                  color: ColorConstant.appThemeColor,
                  size: 22,
                ),
                horizontalTitleGap: -5,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AppDialog(
                            titleMsg: S.of(context).email,
                            alertWidget: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Column(
                                children: [
                                  AppText(
                                    text: helpCenterProvider.helpEmail,
                                  )
                                ],
                              ),
                            ),
                          ));
                },
              ),
              ListTile(
                title: AppText(text: S.of(context).mobileNo),
                leading: const Icon(
                  Icons.email,
                  color: ColorConstant.appThemeColor,
                  size: 22,
                ),
                horizontalTitleGap: -5,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AppDialog(
                        titleMsg: S.of(context).mobileNo,
                        alertWidget: Padding(
                          padding:
                          const EdgeInsets.only(top: 10, bottom: 20),
                          child: Column(
                            children: [
                              AppText(
                                text: helpCenterProvider.helpNumber,
                              )
                            ],
                          ),
                        ),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.library_books_sharp,
                  color: ColorConstant.appThemeColor,
                  size: 22,
                ),
                horizontalTitleGap: -5,
                title: AppText(text: S.of(context).form),
                onTap: () {
                  showDialog(
                      context: context,
                       barrierDismissible: false,
                      builder: (_) => AppDialog(
                            titleMsg: S.of(context).formDetails,
                            alertWidget: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  AppTextField(
                                    controller: helpCenterProvider.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) =>
                                        emailValidator(value!, context),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    hint: S.of(context).email,
                                    enabledBorder:
                                        AppTextField.appOutlineInputBorder(
                                            color: ColorConstant.appGrey),
                                    focusedBorder:
                                        AppTextField.appOutlineInputBorder(),
                                    errorBorder: AppTextField.appOutlineInputBorder(color: Colors.red),
                                    focusedErrorBorder: AppTextField.appOutlineInputBorder(),
                                  ),
                                  AppTextField(
                                    controller: helpCenterProvider.phoneController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) => mobileValidator(value!, context),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    hint: S.of(context).phoneNo,
                                    enabledBorder:
                                        AppTextField.appOutlineInputBorder(
                                            color: ColorConstant.appGrey),
                                    focusedBorder:
                                        AppTextField.appOutlineInputBorder(),
                                    errorBorder:
                                        AppTextField.appOutlineInputBorder(
                                            color: Colors.red),
                                    focusedErrorBorder: AppTextField.appOutlineInputBorder(),
                                  ),
                                  AppTextField(
                                    controller: helpCenterProvider.subjectController,
                                    validator: (value) => emptyValidator(value!,
                                        S.of(context).subjectIsRequired),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    hint: S.of(context).subject,
                                    enabledBorder:
                                        AppTextField.appOutlineInputBorder(
                                            color: ColorConstant.appGrey),
                                    focusedBorder:
                                        AppTextField.appOutlineInputBorder(),
                                    errorBorder: AppTextField.appOutlineInputBorder(color: Colors.red),
                                    focusedErrorBorder: AppTextField.appOutlineInputBorder(),
                                  ),
                                  AppTextField(
                                      controller: helpCenterProvider.messageController,
                                      validator: (value) => emptyValidator(
                                          value!,
                                          S.of(context).messageIsRequired),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      hint: S.of(context).message,
                                      enabledBorder:
                                          AppTextField.appOutlineInputBorder(
                                              color: ColorConstant.appGrey),
                                      focusedBorder:
                                          AppTextField.appOutlineInputBorder(),
                                      errorBorder: AppTextField.appOutlineInputBorder(color: Colors.red),
                                      focusedErrorBorder: AppTextField.appOutlineInputBorder(),
                                      maxLines: 3),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AppButton(
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          helpCenterProvider.addForm(context);
                                        }
                                      },
                                      buttonText: S.of(context).submit,
                                      borderRadius: 30,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900),
                                  AppWithoutBgButton(
                                    onTap: () {
                                      Navigator.pop(context);
                                      helpCenterProvider.emailController.clear();
                                      helpCenterProvider.phoneController.clear();
                                      helpCenterProvider.subjectController.clear();
                                      helpCenterProvider.messageController.clear();
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
                          ));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.chat_sharp,
                  color: ColorConstant.appThemeColor,
                  size: 22,
                ),
                horizontalTitleGap: -5,
                title: AppText(text: S.of(context).liveChat),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.chat_sharp,
                  color: ColorConstant.appThemeColor,
                  size: 22,
                ),
                horizontalTitleGap: -5,
                title: const AppText(text: "Chat List"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatListPage()));

                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
