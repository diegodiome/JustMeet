
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/reporting.dart';

class EventReporting extends Reporting {
  final String eventId;

  EventReporting({@required this.eventId, reportingId, reportingCreator, reportingType}) : super(
    reportingId: reportingId,
    reportingType: reportingType,
    reportingCreator: reportingCreator
  );

  String toJson() {
    return jsonEncode({
      "eventId": eventId,
      "reportingCreator": reportingCreator,
      "reportingType": reportingType.string
    });
  }
}