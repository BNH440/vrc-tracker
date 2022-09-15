class MatchListByTeam {
  Meta? _meta;
  List<Data>? _data;

  MatchListByTeam({Meta? meta, List<Data>? data}) {
    if (meta != null) {
      this._meta = meta;
    }
    if (data != null) {
      this._data = data;
    }
  }

  Meta? get meta => _meta;
  set meta(Meta? meta) => _meta = meta;
  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;

  MatchListByTeam.fromJson(Map<String, dynamic> json) {
    _meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._meta != null) {
      data['meta'] = this._meta!.toJson();
    }
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? _currentPage;
  String? _firstPageUrl;
  int? _from;
  int? _lastPage;
  String? _lastPageUrl;
  String? _nextPageUrl;
  String? _path;
  int? _perPage;
  Null? _prevPageUrl;
  int? _to;
  int? _total;

  Meta(
      {int? currentPage,
      String? firstPageUrl,
      int? from,
      int? lastPage,
      String? lastPageUrl,
      String? nextPageUrl,
      String? path,
      int? perPage,
      Null? prevPageUrl,
      int? to,
      int? total}) {
    if (currentPage != null) {
      this._currentPage = currentPage;
    }
    if (firstPageUrl != null) {
      this._firstPageUrl = firstPageUrl;
    }
    if (from != null) {
      this._from = from;
    }
    if (lastPage != null) {
      this._lastPage = lastPage;
    }
    if (lastPageUrl != null) {
      this._lastPageUrl = lastPageUrl;
    }
    if (nextPageUrl != null) {
      this._nextPageUrl = nextPageUrl;
    }
    if (path != null) {
      this._path = path;
    }
    if (perPage != null) {
      this._perPage = perPage;
    }
    if (prevPageUrl != null) {
      this._prevPageUrl = prevPageUrl;
    }
    if (to != null) {
      this._to = to;
    }
    if (total != null) {
      this._total = total;
    }
  }

  int? get currentPage => _currentPage;
  set currentPage(int? currentPage) => _currentPage = currentPage;
  String? get firstPageUrl => _firstPageUrl;
  set firstPageUrl(String? firstPageUrl) => _firstPageUrl = firstPageUrl;
  int? get from => _from;
  set from(int? from) => _from = from;
  int? get lastPage => _lastPage;
  set lastPage(int? lastPage) => _lastPage = lastPage;
  String? get lastPageUrl => _lastPageUrl;
  set lastPageUrl(String? lastPageUrl) => _lastPageUrl = lastPageUrl;
  String? get nextPageUrl => _nextPageUrl;
  set nextPageUrl(String? nextPageUrl) => _nextPageUrl = nextPageUrl;
  String? get path => _path;
  set path(String? path) => _path = path;
  int? get perPage => _perPage;
  set perPage(int? perPage) => _perPage = perPage;
  Null? get prevPageUrl => _prevPageUrl;
  set prevPageUrl(Null? prevPageUrl) => _prevPageUrl = prevPageUrl;
  int? get to => _to;
  set to(int? to) => _to = to;
  int? get total => _total;
  set total(int? total) => _total = total;

  Meta.fromJson(Map<String, dynamic> json) {
    _currentPage = json['current_page'];
    _firstPageUrl = json['first_page_url'];
    _from = json['from'];
    _lastPage = json['last_page'];
    _lastPageUrl = json['last_page_url'];
    _nextPageUrl = json['next_page_url'];
    _path = json['path'];
    _perPage = json['per_page'];
    _prevPageUrl = json['prev_page_url'];
    _to = json['to'];
    _total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this._currentPage;
    data['first_page_url'] = this._firstPageUrl;
    data['from'] = this._from;
    data['last_page'] = this._lastPage;
    data['last_page_url'] = this._lastPageUrl;
    data['next_page_url'] = this._nextPageUrl;
    data['path'] = this._path;
    data['per_page'] = this._perPage;
    data['prev_page_url'] = this._prevPageUrl;
    data['to'] = this._to;
    data['total'] = this._total;
    return data;
  }
}

class Data {
  int? _id;
  String? _number;
  String? _teamName;
  String? _robotName;
  String? _organization;
  Location? _location;
  bool? _registered;
  Program? _program;
  String? _grade;

  Data(
      {int? id,
      String? number,
      String? teamName,
      String? robotName,
      String? organization,
      Location? location,
      bool? registered,
      Program? program,
      String? grade}) {
    if (id != null) {
      this._id = id;
    }
    if (number != null) {
      this._number = number;
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
    if (program != null) {
      this._program = program;
    }
    if (grade != null) {
      this._grade = grade;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get number => _number;
  set number(String? number) => _number = number;
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
  Program? get program => _program;
  set program(Program? program) => _program = program;
  String? get grade => _grade;
  set grade(String? grade) => _grade = grade;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _number = json['number'];
    _teamName = json['team_name'];
    _robotName = json['robot_name'];
    _organization = json['organization'];
    _location = json['location'] != null ? new Location.fromJson(json['location']) : null;
    _registered = json['registered'];
    _program = json['program'] != null ? new Program.fromJson(json['program']) : null;
    _grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['number'] = this._number;
    data['team_name'] = this._teamName;
    data['robot_name'] = this._robotName;
    data['organization'] = this._organization;
    if (this._location != null) {
      data['location'] = this._location!.toJson();
    }
    data['registered'] = this._registered;
    if (this._program != null) {
      data['program'] = this._program!.toJson();
    }
    data['grade'] = this._grade;
    return data;
  }
}

class Location {
  Null? _venue;
  String? _address1;
  Null? _address2;
  String? _city;
  String? _region;
  String? _postcode;
  String? _country;
  Coordinates? _coordinates;

  Location(
      {Null? venue,
      String? address1,
      Null? address2,
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

  Null? get venue => _venue;
  set venue(Null? venue) => _venue = venue;
  String? get address1 => _address1;
  set address1(String? address1) => _address1 = address1;
  Null? get address2 => _address2;
  set address2(Null? address2) => _address2 = address2;
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
    _lat = json['lat'];
    _lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this._lat;
    data['lon'] = this._lon;
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
