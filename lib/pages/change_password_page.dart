import 'package:easy_grade/provider/profile_provider.dart';
import 'package:easy_grade/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/color_constant.dart';
import '../generated/l10n.dart';
import '../utills/app_validation.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text.dart';
import '../widgets/app_text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ProfileProvider profileProvider,_) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor:  ColorConstant.appWhite,
              appBar: AppBar(
                backgroundColor: ColorConstant.appWhite,
                iconTheme: const IconThemeData(
                  color: ColorConstant.appBlack,
                ),
                elevation: 0.0,
                titleSpacing: 0.0,
                title: AppText(
                    text:S.of(context).changePassword,
                    fontSize: 18,
                    textColor: ColorConstant.appBlack),

              ),
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => passwordValidator(value!,context),
                      controller: profileProvider.oldPassController,
                      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      focusedErrorBorder:AppTextField.appOutlineInputBorder(color: ColorConstant.appGrey),
                      hint: S.of(context).enterOldPassword,enabledBorder: AppTextField.appOutlineInputBorder(color: ColorConstant.appGrey),focusedBorder: AppTextField.appOutlineInputBorder(),
                      errorBorder: AppTextField.appOutlineInputBorder(color: Colors.red) ,
                    ),
                    AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: profileProvider.newPassController,
                      validator: (value) => passwordValidator(value!,context),
                      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      errorBorder: AppTextField.appOutlineInputBorder(color: Colors.red),
                      hint: S.of(context).enterNewPassword,focusedErrorBorder:AppTextField.appOutlineInputBorder(color: ColorConstant.appGrey),
                      enabledBorder: AppTextField.appOutlineInputBorder(color: ColorConstant.appGrey),focusedBorder: AppTextField.appOutlineInputBorder(),),
                    const SizedBox(height: 20),
                    AppButton(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            profileProvider.changePasswordUser(context);
                          }
                        },buttonText: S.of(context).submit,borderRadius: 30,fontSize: 14, fontWeight: FontWeight.w900),
                  ],
                ),
              ),
            ),
            profileProvider.isLoading ? const AppLoader(): Container()
          ],
        );
      }
    );
  }
}
