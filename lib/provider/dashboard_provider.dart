import 'package:flutter/cupertino.dart';

class DashBoardProvider extends ChangeNotifier {
  int selectedIndex = 0;

  changeIndex(int index){
    selectedIndex = index;
    notifyListeners();
  }
}