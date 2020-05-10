
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/reporting.dart';

class UserReporting extends Reporting {
  final String userId;

  UserReporting({@required this.userId, reportingId, reportingCreator, reportingType}) : super(
      reportingId: reportingId,
      reportingType: reportingType,
      reportingCreator: reportingCreator
  );

  String toJson() {
    return jsonEncode({
      "userId": userId,
      "reportingCreator": reportingCreator,
      "reportingType": reportingType.string
    });
  }
}