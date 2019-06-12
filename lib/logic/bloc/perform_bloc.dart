import 'dart:async';
import 'package:repair_project/logic/viewmodel/perform_viewmodel.dart';
import 'package:repair_project/model/menu.dart';

class PerformBloc{

  final _menuVM = PerformViewModel();
  final menuController = StreamController<List<Menu>>();

  Stream<List<Menu>> get menuItems => menuController.stream;

  PerformBloc(){
    menuController.add(_menuVM.getMenuItems());
  }
}