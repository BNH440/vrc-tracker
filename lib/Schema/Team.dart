import 'package:vrc_ranks_app/Schema/EventListByTeam.dart' show EventListByTeam;
import 'package:vrc_ranks_app/Schema/Events.dart' show Location;

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
  EventListByTeam? _events;

  Team(
      {int? id,
      String? number,
      Program? program,
      String? teamName,
      String? robotName,
      String? organization,
      Location? location,
      bool? registered,
      String? grade,
      EventListByTeam? events}) {
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

  EventListByTeam? get events => _events;
  set events(EventListByTeam? events) => _events = events;

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
