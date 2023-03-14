import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constant/color_constant.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: ColorConstant.appWhite.withOpacity(0.8),
        child: SpinKitFadingCircle(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven
                    ? ColorConstant.appBlue
                    : ColorConstant.appThemeLight,
              ),
            );
          },
        ),
      )
    );
  }
}
