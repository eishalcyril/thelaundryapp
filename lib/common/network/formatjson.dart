class FormatJsonClass {
  static Map<String, dynamic> formatJsonTriage({
    required String patientHashedID,
    required String edFindingsHashedID,
    required Map<String, dynamic> jsonValue,
    required String patientPhaseIDFromUI,
    required String patientPhaseParameterName,
  }) {
    List<Map<String, dynamic>> documentArray = [];

    jsonValue.forEach((key, value) {
      Map<String, dynamic> indicatorMap = {
        "patientTriageIndicatorProperty_patientStageSettings_Text": key,
        if (key.endsWith('_Boolean'))
          "patientFindingsIndicatorBooleanValue_patientFindings_Boolean": value,
        if (key.endsWith('_Double'))
          "patientFindingsIndicatorDoubleValue_patientFindings_Double": value,
        if (key.endsWith('_Integer'))
          "patientFindingsIndicatorIntegerValue_patientFindings_Integer": value,
        if (key.endsWith('_Text'))
          "patientFindingsIndicatorTextValue_patientFindings_Text": value,
        if (key.endsWith('_TextArray'))
          "patientFindingsIndicatorTextArrayValue_patientFindings_TextArray":
              value,
      };

      documentArray.add(indicatorMap);
    });

    return {
      "patientStageIDFromUI_patientStageSettings_Text": patientPhaseIDFromUI,
      "patientTriageParameterName_patientStageSettings_Text":
          patientPhaseParameterName,
      "patientHashedID_patientRegistration_Text": patientHashedID,
      "edFindingsHashedID_patientFindings_Text": edFindingsHashedID,
      "patientTriageIndicators_patientStageSettings_DocumentArray":
          documentArray,
    };
  }

  static Map<String, dynamic> formatJsonFastTrack({
    required String patientHashedID,
    required String edFindingsHashedID,
    required Map<String, dynamic> jsonValue,
    required String patientPhaseIDFromUI,
    required String patientPhaseParameterName,
  }) {
    List<Map<String, dynamic>> documentArray = [];

    jsonValue.forEach((key, value) {
      Map<String, dynamic> indicatorMap = {
        "fastTrackOPIndicatorProperty_doctorDiagnosis_Text": key,
        if (key.endsWith('_Boolean'))
          "fastTrackOPIndicatorBooleanValue_doctorDiagnosis_Boolean": value,
        if (key.endsWith('_Double'))
          "fastTrackOPIndicatorDoubleValue_doctorDiagnosis_Double": value,
        if (key.endsWith('_Integer'))
          "fastTrackOPIndicatorIntegerValue_doctorDiagnosis_Integer": value,
        if (key.endsWith('_Text'))
          "fastTrackOPIndicatorTextValue_doctorDiagnosis_Text": value,
        if (key.endsWith('_DateTime'))
          "fastTrackOPIndicatorDateTimeValue_doctorDiagnosis_DateTime": value,
      };

      documentArray.add(indicatorMap);
    });

    return {
      "doctorDiagnosisIDFromUI_doctorDiagnosis_Text": patientPhaseIDFromUI,
      "fastTrackOPParameterName_doctorDiagnosis_Text":
          patientPhaseParameterName,
      "patientHashedID_patientRegistration_Text": patientHashedID,
      "edFindingsHashedID_patientFindings_Text": edFindingsHashedID,
      "fastTrackOPIndicators_doctorDiagnosis_DocumentArray": documentArray,
    };
  }

  static Map<String, dynamic> formatJsonDocMed({
    required String patientHashedID,
    required String edFindingsHashedID,
    required Map<String, dynamic> jsonValue,
    required String patientPhaseIDFromUI,
    required String patientPhaseParameterName,
  }) 
  {
    List<Map<String, dynamic>> documentArray = [];

    jsonValue.forEach((key, value) {
      Map<String, dynamic> indicatorMap = {
        "medicalIndicatorProperty_doctorDiagnosis_Text": key,
        if (key.endsWith('_Boolean'))
          "medicalIndicatorBooleanValue_doctorDiagnosis_Boolean": value,
        if (key.endsWith('_Double'))
          "medicalIndicatorDoubleValue_doctorDiagnosis_Double": value,
        if (key.endsWith('_Integer'))
          "medicalIndicatorIntegerValue_doctorDiagnosis_Integer": value,
        if (key.endsWith('_Text'))
          "medicalIndicatorTextValue_doctorDiagnosis_Text": value,
        if (key.endsWith('_TextArray'))
          "medicalIndicatorTextArrayValue_doctorDiagnosis_TextArray": value,
        if (key.endsWith('_DateTime'))
          "medicalIndicatorDateTimeValue_doctorDiagnosis_DateTime": value,
      };
      documentArray.add(indicatorMap);
    });

    return {
      "doctorDiagnosisIDFromUI_doctorDiagnosis_Text": patientPhaseIDFromUI,
      "medicalParameterName_doctorDiagnosis_Text": patientPhaseParameterName,
      "patientHashedID_patientRegistration_Text": patientHashedID,
      "edFindingsHashedID_patientFindings_Text": edFindingsHashedID,
      "medicalIndicators_doctorDiagnosis_DocumentArray":
          documentArray,
    };
  }

  static Map<String, dynamic> formatJsonNia({
    required String patientHashedID,
    required String edFindingsHashedID,
    required Map<String, dynamic> jsonValue,
    required String patientPhaseIDFromUI,
    required String patientPhaseParameterName,
  }) 
  {
    List<Map<String, dynamic>> documentArray = [];

    jsonValue.forEach((key, value) {
      Map<String, dynamic> indicatorMap = {
        "niaIndicatorProperty_niaSettings_Text": key,
        if (key.endsWith('_Boolean'))
          "niaIndicatorBooleanValue_niaSettings_Boolean": value,
        if (key.endsWith('_Double'))
          "niaIndicatorDoubleValue_doctorDiagnosis_Double": value,
        if (key.endsWith('_Integer'))
          "niaIndicatorIntegerValue_doctorDiagnosis_Integer": value,
        if (key.endsWith('_Text'))
          "niaIndicatorTextValue_doctorDiagnosis_Text": value,
        if (key.endsWith('_TextArray'))
          "niaIndicatorTextArrayValue_niaSettings_TextArray":
              value,
        if (key.endsWith('_DateTime'))
          "niaIndicatorDateTimeValue_doctorDiagnosis_DateTime": value,
      };

      documentArray.add(indicatorMap);
    });

    return {
      "niaIDFromUI_niaSettings_Text": patientPhaseIDFromUI,
      "niaParameterName_niaSettings_Text":
          patientPhaseParameterName,
      "patientHashedID_patientRegistration_Text": patientHashedID,
      "edFindingsHashedID_patientFindings_Text": edFindingsHashedID,
      "niaIndicators_niaSettings_DocumentArray":
          documentArray,
    };
  }
}
