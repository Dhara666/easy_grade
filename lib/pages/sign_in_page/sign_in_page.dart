import 'dart:io';

import 'package:easy_grade/constant/color_constant.dart';
import 'package:easy_grade/provider/signin_provider.dart';
import 'package:easy_grade/widgets/app_dialog.dart';
import 'package:easy_grade/widgets/app_loader.dart';
import 'package:easy_grade/widgets/app_text.dart';
import 'package:easy_grade/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../utills/app_validation.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image_assets.dart';
import '../sign_up_page/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Consumer(
      builder: (context,SignInProvider signInProvider,_) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: ColorConstant.appWhite,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: ColorConstant.appWhite,
                elevation: 0,
                iconTheme: const IconThemeData(
                  color: ColorConstant.appThemeColor,
                  size: 30,
                ),
              ),
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       AppText(
                        text: S.of(context).welcome,
                        fontWeight: FontWeight.w600,
                        fontSize: 40,
                      ),
                      SizedBox(height: height * 0.01),
                       AppText(
                        text: S.of(context).signInToContinue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        textColor: ColorConstant.appThemeLight,
                      ),
                      SizedBox(height: height * 0.025),
                      AppTextField(
                          hint: S.of(context).enterEmail,
                          keyboardType: TextInputType.emailAddress,
                          controller: signInProvider.emailController,
                          validator: (value) => emailValidator(value!,context)),
                      SizedBox(height: height * 0.025),
                      AppTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: signInProvider.passwordController,
                        hint:S.of(context).enterPassword,
                        obscureText: true,
                        validator: (value) => passwordValidator(value!,context),
                      ),
                      SizedBox(height: height * 0.060),
                      AppButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                             signInProvider.signInUser(context);
                          }
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        buttonText: S.of(context).login,
                      ),
                      GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (_) =>  AppDialog(
                                titleMsg:  S.of(context).enterYourEmail,
                                alertWidget: Form(
                                  key: signInProvider.forgotFormKey,
                                  child: Column(
                                    children: [
                                      AppTextField(
                                        keyboardType: TextInputType.emailAddress,
                                        autofocus : true,
                                        validator: (value) => emailValidator(value!,context),
                                         controller: signInProvider.forgotPassController,
                                        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                        hint: S.of(context).enterEmail,
                                        enabledBorder: AppTextField.appOutlineInputBorder(color: ColorConstant.appGrey),
                                        focusedBorder: AppTextField.appOutlineInputBorder(),
                                        errorBorder: AppTextField.appOutlineInputBorder(color: Colors.red),
                                        focusedErrorBorder: AppTextField.appOutlineInputBorder(color: Colors.red),
                                      ),
                                      const SizedBox(height: 20,),
                                      AppButton(
                                          onTap: () async {
                                            if(signInProvider.forgotFormKey.currentState!.validate()){
                                             Navigator.pop(context);
                                             signInProvider.forgotPassword(context);
                                            }
                                          },buttonText: S.of(context).submit,borderRadius: 30,fontSize: 14, fontWeight: FontWeight.w900),
                                    ],
                                  ),
                                ),
                              )
                          );
                        },
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.015, bottom: height * 0.030),
                            child: AppText(
                              text: S.of(context).forgotPassword,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 1,
                            color: ColorConstant.appGrey,
                          )),
                           AppText(
                            text: S.of(context).or,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          Expanded(
                              child:
                                  Container(height: 1, color: ColorConstant.appGrey)),
                        ],
                      ),
                      SizedBox(height: height * 0.050),
                       Center(
                          child: AppText(
                        text: S.of(context).socialMediaLogin,
                        textColor: ColorConstant.appThemeLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            InkWell(
                              onTap: () async {
                               await signInProvider.signWithGoogle(context);
                              },
                              child: const AppImageAsset(
                               image: AppAsset.googleLogo,
                                height: 35.0,
                                width: 35,
                              ),
                            ),
                            const SizedBox(width: 25),
                            InkWell(
                              onTap: () async {
                                await signInProvider.signInWithFacebook(context);
                              },
                              child: const AppImageAsset(
                                image: AppAsset.facebookLogo,
                                height: 35.0,
                                width: 35,
                              ),
                            ),
                            SizedBox(width: Platform.isIOS ? 25 :0),
                            Platform.isIOS ?
                            InkWell(
                              onTap: () async {
                                print("----->Ios Login");
                                SignInProvider signInProvider =
                                Provider.of<SignInProvider>(context,
                                    listen: false);
                                await signInProvider.signInWithApple(context);
                              },
                              child: const AppImageAsset(
                                image: AppAsset.appleLogo,
                                height: 35.0,
                                width: 35,
                              ),
                            ) : SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.10),
                      Row(
                        children: [
                           AppText(
                              text: S.of(context).doNotHaveAccount,
                              textColor: ColorConstant.appThemeLight),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUpPage()));
                              },
                              child:  Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                                child: AppText(
                                  text: S.of(context).signUp1,
                                  textColor: ColorConstant.appBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            signInProvider.isLoading ? const AppLoader() : const SizedBox()
          ],
        );
      }
    );
  }
}
