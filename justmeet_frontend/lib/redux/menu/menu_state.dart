import 'package:justmeet_frontend/widgets/home/menu_scaffold.dart';

class MenuState {
  final MenuController menuController;

  MenuState({this.menuController});

  factory MenuState.initial() {
    return MenuState(
      menuController: null
    );
  }

  MenuState copyWith(
      {MenuController menuController}) {
    return MenuState(
        menuController: menuController ?? this.menuController);
  }
}
