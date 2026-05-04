class MacroMicronutrientCal {
  MacroMicronutrientCal({
    required this.success,
    required this.error,
    required this.status,
    required this.SHRTStatus,
    required this.season,
    required this.data,
    required this.message,
  });

  late final int success;
  late final int error;
  late final int status;
  late final String SHRTStatus;
  late final String season;
  late final MacroMicronutrientCalData data;
  late final String message;

  MacroMicronutrientCal.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    SHRTStatus = json['SHRT_status'];
    season = json['season'];
    data = MacroMicronutrientCalData.fromJson(json['data']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['SHRT_status'] = SHRTStatus;
    _data['season'] = season;
    _data['data'] = data.toJson();
    _data['message'] = message;
    return _data;
  }
}

class MacroMicronutrientCalData {
  MacroMicronutrientCalData({
    required this.macronutrient,
    required this.micronutrient,
    required this.dayWiseMultiplicationFactor,
  });

  late final Macronutrient? macronutrient;
  late final Micronutrient? micronutrient;
  late final List<DayWiseMultiplicationFactor> dayWiseMultiplicationFactor;

  MacroMicronutrientCalData.fromJson(Map<String, dynamic> json) {
    if (json['macronutrient'] != null) {
      macronutrient = Macronutrient.fromJson(json['macronutrient']);
    }
    if (json['micronutrient'] != null) {
      micronutrient = Micronutrient.fromJson(json['micronutrient']);
    }
    dayWiseMultiplicationFactor = List.from(json['day_wise_multiplication_factor']).map((e) => DayWiseMultiplicationFactor.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (macronutrient != null) {
      _data['macronutrient'] = macronutrient!.toJson();
    }
    if (micronutrient != null) {
      _data['micronutrient'] = micronutrient!.toJson();
    }
    _data['day_wise_multiplication_factor'] = dayWiseMultiplicationFactor.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Macronutrient {
  Macronutrient({
    required this.impression,
    required this.recommendation,
  });

  late final Impression impression;
  late final Recommendation recommendation;

  Macronutrient.fromJson(Map<String, dynamic> json) {
    impression = Impression.fromJson(json['Impression']);
    recommendation = Recommendation.fromJson(json['Recommendation']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Impression'] = impression.toJson();
    _data['Recommendation'] = recommendation.toJson();
    return _data;
  }
}

class Impression {
  Impression({
    required this.n,
    required this.p,
    required this.k,
    required this.s,
  });

  late final String n;
  late final String p;
  late final String k;
  late final String s;

  Impression.fromJson(Map<String, dynamic> json) {
    n = json['n'].toString();
    p = json['p'].toString();
    k = json['k'].toString();
    s = json['s'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['n'] = n;
    _data['p'] = p;
    _data['k'] = k;
    _data['s'] = s;
    return _data;
  }
}

class Recommendation {
  Recommendation({
    required this.n,
    required this.p,
    required this.k,
    required this.s,
  });

  late final String n;
  late final String p;
  late final String k;
  late final String s;

  Recommendation.fromJson(Map<String, dynamic> json) {
    n = json['n'].toString();
    p = json['p'].toString();
    k = json['k'].toString();
    s = json['s'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['n'] = n;
    _data['p'] = p;
    _data['k'] = k;
    _data['s'] = s;
    return _data;
  }
}

class Micronutrient {
  Micronutrient({
    required this.impression,
    required this.recommendation,
  });

  late final MicrImpression impression;
  late final MicrRecommendation recommendation;

  Micronutrient.fromJson(Map<String, dynamic> json) {
    impression = MicrImpression.fromJson(json['Impression']);
    recommendation = MicrRecommendation.fromJson(json['Recommendation']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Impression'] = impression.toJson();
    _data['Recommendation'] = recommendation.toJson();
    return _data;
  }
}

class MicrImpression {
  MicrImpression({
    required this.i,
    required this.m,
    required this.z,
    required this.c,
    required this.b,
  });

  late final String i;
  late final String m;
  late final String z;
  late final String c;
  late final String b;

  MicrImpression.fromJson(Map<String, dynamic> json) {
    i = json['i'].toString();
    m = json['m'].toString();
    z = json['z'].toString();
    c = json['c'].toString();
    b = json['b'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['i'] = i;
    _data['m'] = m;
    _data['z'] = z;
    _data['c'] = c;
    _data['b'] = b;
    return _data;
  }
}

class MicrRecommendation {
  MicrRecommendation({
    required this.i,
    required this.m,
    required this.z,
    required this.c,
    required this.b,
  });

  late final String i;
  late final String m;
  late final String z;
  late final String c;
  late final String b;

  MicrRecommendation.fromJson(Map<String, dynamic> json) {
    i = json['i'].toString();
    m = json['m'].toString();
    z = json['z'].toString();
    c = json['c'].toString();
    b = json['b'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['i'] = i;
    _data['m'] = m;
    _data['z'] = z;
    _data['c'] = c;
    _data['b'] = b;
    return _data;
  }
}

class DayWiseMultiplicationFactor {
  DayWiseMultiplicationFactor({
    required this.days,
    required this.n,
    required this.p,
    required this.k,
    required this.s,
  });

  late final String days;
  late final String? n;
  late final String? p;
  late final String k;
  late final String? s;

  DayWiseMultiplicationFactor.fromJson(Map<String, dynamic> json) {
    days = json['days'].toString();
    n = json['n'].toString();
    p = json['p'].toString();
    k = json['k'].toString();
    if (json['s'].toString().isNotEmpty) {
      s = json['s'].toString();
    } else {
      s = "0";
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['days'] = days;
    _data['n'] = n;
    _data['p'] = p;
    _data['k'] = k;
    _data['s'] = s;
    return _data;
  }
}
