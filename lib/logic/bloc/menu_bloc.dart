import 'dart:async';

import 'package:repair_project/logic/viewmodel/menu_view_model.dart';
import 'package:repair_project/model/menu.dart';

class MenuBloc{

  final _menuVM = MenuViewMModel();
  final menuController = StreamController<List<Menu>>();

  Stream<List<Menu>> get menuItems => menuController.stream;

  MenuBloc(){
    menuController.add(_menuVM.getMenuItems());
  }
}