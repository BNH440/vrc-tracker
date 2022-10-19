class TeamList {
  Meta? meta;
  List<Data>? data;

  TeamList({this.meta, this.data});

  TeamList.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? currentPage;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int? id;
  String? number;
  String? teamName;
  String? robotName;
  String? organization;
  Location? location;
  bool? registered;
  Program? program;
  String? grade;

  Data(
      {this.id,
      this.number,
      this.teamName,
      this.robotName,
      this.organization,
      this.location,
      this.registered,
      this.program,
      this.grade});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    teamName = json['team_name'];
    robotName = json['robot_name'];
    organization = json['organization'];
    location = json['location'] != null ? new Location.fromJson(json['location']) : null;
    registered = json['registered'];
    program = json['program'] != null ? new Program.fromJson(json['program']) : null;
    grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['team_name'] = this.teamName;
    data['robot_name'] = this.robotName;
    data['organization'] = this.organization;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['registered'] = this.registered;
    if (this.program != null) {
      data['program'] = this.program!.toJson();
    }
    data['grade'] = this.grade;
    return data;
  }
}

class Location {
  String? address1;
  String? city;
  String? region;
  String? postcode;
  String? country;
  Coordinates? coordinates;

  Location({this.address1, this.city, this.region, this.postcode, this.country, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    address1 = json['address_1'];
    city = json['city'];
    region = json['region'];
    postcode = json['postcode'];
    country = json['country'];
    coordinates = json['coordinates'] != null
      ? new Coordinates.fromJson(json['coordinates'])
      : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_1'] = this.address1;
    data['city'] = this.city;
    data['region'] = this.region;
    data['postcode'] = this.postcode;
    data['country'] = this.country;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates!.toJson();
    }
    return data;
  }
}

class Coordinates {
  num? lat;
  num? lon;

  Coordinates({this.lat, this.lon});

  Coordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}

class Program {
  int? id;
  String? name;
  String? code;

  Program({this.id, this.name, this.code});

  Program.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}
