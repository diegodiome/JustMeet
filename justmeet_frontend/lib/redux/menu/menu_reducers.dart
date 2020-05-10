
import 'package:justmeet_frontend/redux/menu/menu_action.dart';
import 'package:redux/redux.dart';
import 'menu_state.dart';

final menuReducers = combineReducers<MenuState>([
  TypedReducer<MenuState, OnMenuControllerUpdate>(_onMenuControllerUpdate),
]);

MenuState _onMenuControllerUpdate(MenuState state, OnMenuControllerUpdate action) {
  return state.copyWith(
    menuController: action.menuController
  );
}