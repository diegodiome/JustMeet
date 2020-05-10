
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:justmeet_frontend/redux/location/location_action.dart';
import 'package:justmeet_frontend/repositories/map_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createLocationMiddleware(
    MapRepository mapRepository
    ) {
  return [
    TypedMiddleware<AppState, VerifyCurrentLocationState>(_verifyLocationState(mapRepository)),
  ];
}

void Function(
    Store<AppState> store,
    VerifyCurrentLocationState action,
    NextDispatcher next
    ) _verifyLocationState(
    MapRepository mapRepository
    ) {
  return (store, action, next) async {
    next(action);
    if (await Permission.location.request().isGranted) {
      mapRepository.getLocationStateChange().listen((location) async {
        store.dispatch(OnLocationChanged(newLocation: location));
        store.dispatch(OnFilterEventUpdate());
      });
    }
  };
}