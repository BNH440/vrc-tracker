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
  Null? _nextPageUrl;
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
      Null? nextPageUrl,
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
  Null? get nextPageUrl => _nextPageUrl;
  set nextPageUrl(Null? nextPageUrl) => _nextPageUrl = nextPageUrl;
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
  Event? _event;
  Division? _division;
  int? _round;
  int? _instance;
  int? _matchnum;
  String? _scheduled;
  String? _started;
  String? _field;
  bool? _scored;
  String? _name;
  List<Alliances>? _alliances;

  Data(
      {int? id,
      Event? event,
      Division? division,
      int? round,
      int? instance,
      int? matchnum,
      String? scheduled,
      String? started,
      String? field,
      bool? scored,
      String? name,
      List<Alliances>? alliances}) {
    if (id != null) {
      this._id = id;
    }
    if (event != null) {
      this._event = event;
    }
    if (division != null) {
      this._division = division;
    }
    if (round != null) {
      this._round = round;
    }
    if (instance != null) {
      this._instance = instance;
    }
    if (matchnum != null) {
      this._matchnum = matchnum;
    }
    if (scheduled != null) {
      this._scheduled = scheduled;
    }
    if (started != null) {
      this._started = started;
    }
    if (field != null) {
      this._field = field;
    }
    if (scored != null) {
      this._scored = scored;
    }
    if (name != null) {
      this._name = name;
    }
    if (alliances != null) {
      this._alliances = alliances;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  Event? get event => _event;
  set event(Event? event) => _event = event;
  Division? get division => _division;
  set division(Division? division) => _division = division;
  int? get round => _round;
  set round(int? round) => _round = round;
  int? get instance => _instance;
  set instance(int? instance) => _instance = instance;
  int? get matchnum => _matchnum;
  set matchnum(int? matchnum) => _matchnum = matchnum;
  String? get scheduled => _scheduled;
  set scheduled(String? scheduled) => _scheduled = scheduled;
  String? get started => _started;
  set started(String? started) => _started = started;
  String? get field => _field;
  set field(String? field) => _field = field;
  bool? get scored => _scored;
  set scored(bool? scored) => _scored = scored;
  String? get name => _name;
  set name(String? name) => _name = name;
  List<Alliances>? get alliances => _alliances;
  set alliances(List<Alliances>? alliances) => _alliances = alliances;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    _division = json['division'] != null ? new Division.fromJson(json['division']) : null;
    _round = json['round'];
    _instance = json['instance'];
    _matchnum = json['matchnum'];
    _scheduled = json['scheduled'];
    _started = json['started'];
    _field = json['field'];
    _scored = json['scored'];
    _name = json['name'];
    if (json['alliances'] != null) {
      _alliances = <Alliances>[];
      json['alliances'].forEach((v) {
        _alliances!.add(new Alliances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    if (this._event != null) {
      data['event'] = this._event!.toJson();
    }
    if (this._division != null) {
      data['division'] = this._division!.toJson();
    }
    data['round'] = this._round;
    data['instance'] = this._instance;
    data['matchnum'] = this._matchnum;
    data['scheduled'] = this._scheduled;
    data['started'] = this._started;
    data['field'] = this._field;
    data['scored'] = this._scored;
    data['name'] = this._name;
    if (this._alliances != null) {
      data['alliances'] = this._alliances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  int? _id;
  String? _name;
  String? _code;

  Event({int? id, String? name, String? code}) {
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

  Event.fromJson(Map<String, dynamic> json) {
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

class Division {
  int? _id;
  String? _name;
  Null? _code;

  Division({int? id, String? name, Null? code}) {
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
  Null? get code => _code;
  set code(Null? code) => _code = code;

  Division.fromJson(Map<String, dynamic> json) {
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

class Alliances {
  String? _color;
  int? _score;
  List<Teams>? _teams;

  Alliances({String? color, int? score, List<Teams>? teams}) {
    if (color != null) {
      this._color = color;
    }
    if (score != null) {
      this._score = score;
    }
    if (teams != null) {
      this._teams = teams;
    }
  }

  String? get color => _color;
  set color(String? color) => _color = color;
  int? get score => _score;
  set score(int? score) => _score = score;
  List<Teams>? get teams => _teams;
  set teams(List<Teams>? teams) => _teams = teams;

  Alliances.fromJson(Map<String, dynamic> json) {
    _color = json['color'];
    _score = json['score'];
    if (json['teams'] != null) {
      _teams = <Teams>[];
      json['teams'].forEach((v) {
        _teams!.add(new Teams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this._color;
    data['score'] = this._score;
    if (this._teams != null) {
      data['teams'] = this._teams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teams {
  Division? _team;
  bool? _sitting;

  Teams({Division? team, bool? sitting}) {
    if (team != null) {
      this._team = team;
    }
    if (sitting != null) {
      this._sitting = sitting;
    }
  }

  Division? get team => _team;
  set team(Division? team) => _team = team;
  bool? get sitting => _sitting;
  set sitting(bool? sitting) => _sitting = sitting;

  Teams.fromJson(Map<String, dynamic> json) {
    _team = json['team'] != null ? new Division.fromJson(json['team']) : null;
    _sitting = json['sitting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._team != null) {
      data['team'] = this._team!.toJson();
    }
    data['sitting'] = this._sitting;
    return data;
  }
}
