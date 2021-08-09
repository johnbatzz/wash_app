import 'package:flutter/cupertino.dart';

class CustomSpacer extends StatelessWidget {
	final double height;
	final double width;
	CustomSpacer({this.height = 20, this.width = 20});
  @override
  Widget build(BuildContext context) {
      return SizedBox(
		      width: width,
		      height: height,
      );
  }
	
}