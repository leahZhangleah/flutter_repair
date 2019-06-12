import 'dart:async';

import 'package:repair_project/logic/viewmodel/personal_view_model.dart';
import 'package:repair_project/model/personalmodel.dart';

class PersonalBloc{

  final _menuVM = PersonalViewMModel();
  final menuController = StreamController<List<PersonalModel>>();

  Stream<List<PersonalModel>> get menuItems => menuController.stream;

  PersonalBloc(){
    menuController.add(_menuVM.getPersonalItems());
  }
}