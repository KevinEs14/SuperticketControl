import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

import '../../values/values.dart';

class ImageHeader extends StatelessWidget {
  static const double _paddingImage = 32;
  final String image;
  final Widget info;

  const ImageHeader({Key key, @required this.image, @required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _widthScreen = MediaQuery.of(context).size.width;
    final _widthImage = _widthScreen/3;
    final _heightImage = _widthImage*1.5;

    return Align(
      alignment: Alignment.topRight,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: _widthImage*1.8,
            height: _heightImage + (_paddingImage*2),
            decoration: BoxDecoration(
                color: colorSecondary.withOpacity(0.06),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimens.normal), bottomLeft: Radius.circular(Dimens.normal))
            ),
          ),
          Container(
            width: _widthImage*2,
            height: _heightImage + (_paddingImage),
            decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.25),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimens.normal), bottomLeft: Radius.circular(Dimens.normal))
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: _paddingImage),
            child: ExtendedImage.network(
                image,
                width: _widthImage*2.2,
                height: _heightImage,
                fit: BoxFit.cover,
                cache: true,
                shape: BoxShape.rectangle,
                // border: Border.all(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimens.normal), bottomLeft: Radius.circular(Dimens.normal))
              //cancelToken: cancellationToken,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Card(
              elevation: 10,
              // shadowColor: colorPrimary,
              color: Color(0xF0FFFFFF),
              margin: const EdgeInsets.only(left: Dimens.medium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(Dimens.little)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimens.little),
                child: info,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
