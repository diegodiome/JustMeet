import 'package:flutter/material.dart';

enum ReportingType { Spam, Language, Content }

extension userStatusExtension on ReportingType {
  String get string {
    switch (this) {
      case ReportingType.Spam:
        return 'Spam';
      case ReportingType.Content:
        return 'Content';
      case ReportingType.Language:
        return 'Language';
      default:
        return null;
    }
  }
}

class Reporting {
  final String reportingId;
  final String reportingCreator;
  final ReportingType reportingType;

  Reporting({
    this.reportingId,
    @required this.reportingCreator,
    @required this.reportingType
  });
}
