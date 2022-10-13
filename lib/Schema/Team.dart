class Team {
  int? _id;
  String? _number;
  Program? _program;
  String? _teamName;
  String? _robotName;
  String? _organization;
  Location? _location;
  bool? _registered;
  String? _grade;

  Team(
      {int? id,
      String? number,
      Program? program,
      String? teamName,
      String? robotName,
      String? organization,
      Location? location,
      bool? registered,
      String? grade}) {
    if (id != null) {
      this._id = id;
    }
    if (number != null) {
      this._number = number;
    }
    if (program != null) {
      this._program = program;
    }
    if (teamName != null) {
      this._teamName = teamName;
    }
    if (robotName != null) {
      this._robotName = robotName;
    }
    if (organization != null) {
      this._organization = organization;
    }
    if (location != null) {
      this._location = location;
    }
    if (registered != null) {
      this._registered = registered;
    }
    if (grade != null) {
      this._grade = grade;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get number => _number;
  set number(String? number) => _number = number;
  Program? get program => _program;
  set program(Program? program) => _program = program;
  String? get teamName => _teamName;
  set teamName(String? teamName) => _teamName = teamName;
  String? get robotName => _robotName;
  set robotName(String? robotName) => _robotName = robotName;
  String? get organization => _organization;
  set organization(String? organization) => _organization = organization;
  Location? get location => _location;
  set location(Location? location) => _location = location;
  bool? get registered => _registered;
  set registered(bool? registered) => _registered = registered;
  String? get grade => _grade;
  set grade(String? grade) => _grade = grade;

  Team.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _number = json['number'];
    _program = json['program'] != null ? new Program.fromJson(json['program']) : null;
    _teamName = json['team_name'];
    _robotName = json['robot_name'];
    _organization = json['organization'];
    _location = json['location'] != null ? new Location.fromJson(json['location']) : null;
    _registered = json['registered'];
    _grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['number'] = this._number;
    if (this._program != null) {
      data['program'] = this._program!.toJson();
    }
    data['team_name'] = this._teamName;
    data['robot_name'] = this._robotName;
    data['organization'] = this._organization;
    if (this._location != null) {
      data['location'] = this._location!.toJson();
    }
    data['registered'] = this._registered;
    data['grade'] = this._grade;
    return data;
  }
}

class Program {
  int? _id;
  String? _name;
  String? _code;

  Program({int? id, String? name, String? code}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (code != null) {
      this._code = code;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get code => _code;
  set code(String? code) => _code = code;

  Program.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['code'] = this._code;
    return data;
  }
}

class Location {
  String? _venue;
  String? _address1;
  String? _address2;
  String? _city;
  String? _region;
  String? _postcode;
  String? _country;
  Coordinates? _coordinates;

  Location(
      {String? venue,
      String? address1,
      String? address2,
      String? city,
      String? region,
      String? postcode,
      String? country,
      Coordinates? coordinates}) {
    if (venue != null) {
      this._venue = venue;
    }
    if (address1 != null) {
      this._address1 = address1;
    }
    if (address2 != null) {
      this._address2 = address2;
    }
    if (city != null) {
      this._city = city;
    }
    if (region != null) {
      this._region = region;
    }
    if (postcode != null) {
      this._postcode = postcode;
    }
    if (country != null) {
      this._country = country;
    }
    if (coordinates != null) {
      this._coordinates = coordinates;
    }
  }

  String? get venue => _venue;
  set venue(String? venue) => _venue = venue;
  String? get address1 => _address1;
  set address1(String? address1) => _address1 = address1;
  String? get address2 => _address2;
  set address2(String? address2) => _address2 = address2;
  String? get city => _city;
  set city(String? city) => _city = city;
  String? get region => _region;
  set region(String? region) => _region = region;
  String? get postcode => _postcode;
  set postcode(String? postcode) => _postcode = postcode;
  String? get country => _country;
  set country(String? country) => _country = country;
  Coordinates? get coordinates => _coordinates;
  set coordinates(Coordinates? coordinates) => _coordinates = coordinates;

  Location.fromJson(Map<String, dynamic> json) {
    _venue = json['venue'];
    _address1 = json['address_1'];
    _address2 = json['address_2'];
    _city = json['city'];
    _region = json['region'];
    _postcode = json['postcode'];
    _country = json['country'];
    _coordinates =
        json['coordinates'] != null ? new Coordinates.fromJson(json['coordinates']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['venue'] = this._venue;
    data['address_1'] = this._address1;
    data['address_2'] = this._address2;
    data['city'] = this._city;
    data['region'] = this._region;
    data['postcode'] = this._postcode;
    data['country'] = this._country;
    if (this._coordinates != null) {
      data['coordinates'] = this._coordinates!.toJson();
    }
    return data;
  }
}

class Coordinates {
  double? _lat;
  double? _lon;

  Coordinates({double? lat, double? lon}) {
    if (lat != null) {
      this._lat = lat;
    }
    if (lon != null) {
      this._lon = lon;
    }
  }

  double? get lat => _lat;
  set lat(double? lat) => _lat = lat;
  double? get lon => _lon;
  set lon(double? lon) => _lon = lon;

  Coordinates.fromJson(Map<String, dynamic> json) {
    _lat = json['lat'].toDouble();
    _lon = json['lon'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this._lat;
    data['lon'] = this._lon;
    return data;
  }
}
