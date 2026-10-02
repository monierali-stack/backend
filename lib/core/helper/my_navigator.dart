import 'package:flutter/material.dart';

enum NavigatorType {push, replace, remove}


void goTo(context, { required Widget toPage, NavigatorType type = NavigatorType.push})
{
  var route = MaterialPageRoute(builder: (context)=> toPage);
  switch(type){
    case NavigatorType.push:
      Navigator.push(context, route);
    case NavigatorType.replace:
      Navigator.pushReplacement(context, route);
    case NavigatorType.remove:
      Navigator.pushAndRemoveUntil(context, route, (r)=> false);

  }
}