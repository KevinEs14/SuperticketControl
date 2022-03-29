import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../values/values.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              alignment: Alignment(-1, 1),
              image: ExactAssetImage(Assets.imgBgLogin),
              fit: BoxFit.cover),
        ),
        child: Align(
          alignment: Alignment(0.0, -0.4),
          child: Card(
            margin: const EdgeInsets.all(Dimens.large),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Dimens.normal, Dimens.medium, Dimens.normal, Dimens.large),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.little),
                      child: SvgPicture.asset(
                        Assets.svgLogoAbbr,
                        fit: BoxFit.contain,
                        height: Dimens.xLarge*2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.normal),
                      child: Text(Strings.accessControl, style: Styles.titleAppbar,),
                    ),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}