import 'package:hive/hive.dart';
import 'package:vrc_ranks_app/Schema/Division.dart';
import 'package:vrc_ranks_app/Schema/Rankings.dart';
import 'package:vrc_ranks_app/Schema/TeamList.dart';

part 'Events.g.dart';

class Events {
  Meta? meta;
  List<Event>? data;

  Events({this.meta, this.data});

  Events.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Event>[];
      json['data'].forEach((v) {
        data!.add(new Event.fromJson(v));
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
  String? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
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
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Event {
  int? id;
  String? sku;
  String? name;
  String? start;
  String? end;
  Season? season;
  Program? program;
  Location? location;
  List<Divisions>? divisions;
  TeamList? teams;
  String? level;
  bool? ongoing;
  bool? awardsFinalized;
  Null? eventType;
  bool isLocal = false;
  double distance = double.maxFinite;

  Event(
      {this.id,
      this.sku,
      this.name,
      this.start,
      this.end,
      this.season,
      this.program,
      this.location,
      this.divisions,
      this.teams,
      this.level,
      this.ongoing,
      this.awardsFinalized,
      this.eventType,
      this.isLocal = false,
      this.distance = double.maxFinite});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    name = json['name'];
    start = json['start'];
    end = json['end'];
    season = json['season'] != null ? new Season.fromJson(json['season']) : null;
    program = json['program'] != null ? new Program.fromJson(json['program']) : null;
    location = json['location'] != null ? new Location.fromJson(json['location']) : null;
    if (json['divisions'] != null) {
      divisions = <Divisions>[];
      json['divisions'].forEach((v) {
        divisions!.add(new Divisions.fromJson(v));
      });
    }
    level = json['level'];
    ongoing = json['ongoing'];
    awardsFinalized = json['awards_finalized'];
    eventType = json['event_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sku'] = this.sku;
    data['name'] = this.name;
    data['start'] = this.start;
    data['end'] = this.end;
    if (this.season != null) {
      data['season'] = this.season!.toJson();
    }
    if (this.program != null) {
      data['program'] = this.program!.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.divisions != null) {
      data['divisions'] = this.divisions!.map((v) => v.toJson()).toList();
    }
    data['level'] = this.level;
    data['ongoing'] = this.ongoing;
    data['awards_finalized'] = this.awardsFinalized;
    data['event_type'] = this.eventType;
    return data;
  }
}

class Season {
  int? id;
  String? name;
  Null? code;

  Season({this.id, this.name, this.code});

  Season.fromJson(Map<String, dynamic> json) {
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

@HiveType(typeId: 2)
class Location {
  @HiveField(0)
  String? _venue;
  @HiveField(1)
  String? _address1;
  @HiveField(2)
  String? _address2;
  @HiveField(3)
  String? _city;
  @HiveField(4)
  String? _region;
  @HiveField(5)
  String? _postcode;
  @HiveField(6)
  String? _country;
  @HiveField(7)
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

@HiveType(typeId: 3)
class Coordinates {
  @HiveField(0)
  num? lat;
  @HiveField(1)
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

@HiveType(typeId: 5)
class Divisions {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? order;
  @HiveField(3)
  Div? data;

  Rankings? rankings;

  Divisions({this.id, this.name, this.order});

  Divisions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    return data;
  }
}
