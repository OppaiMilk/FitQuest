import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenHeightHelper {
  late BuildContext context;
  ScreenHeightHelper(this.context,);

  getScreenHeight(){
    return MediaQuery.of(context).size.height - (AppBar().preferredSize.height + MediaQuery.of(context).padding.top);
  }
}