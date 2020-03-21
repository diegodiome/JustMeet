import 'package:justmeet_frontend/models/user.dart';

class ListenToUser {}

class OnUserStatusUpdate {
  final UserStatus status;

  OnUserStatusUpdate({this.status});
}