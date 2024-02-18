class Div {
  Meta? meta;
  List<Data>? data;

  Div({this.meta, this.data});

  Div.fromJson(Map<String, dynamic> json) {
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
    // prevPageUrl = json['prev_page_url'];
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

class Data {
  int? id;
  Event? event;
  Division? division;
  int? round;
  int? instance;
  int? matchnum;
  String? scheduled;
  String? started;
  String? field;
  bool? scored;
  String? name;
  List<Alliances>? alliances;

  Data(
      {this.id,
      this.event,
      this.division,
      this.round,
      this.instance,
      this.matchnum,
      this.scheduled,
      this.started,
      this.field,
      this.scored,
      this.name,
      this.alliances});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    division = json['division'] != null ? new Division.fromJson(json['division']) : null;
    round = json['round'];
    instance = json['instance'];
    matchnum = json['matchnum'];
    scheduled = json['scheduled'];
    started = json['started'];
    field = json['field'];
    scored = json['scored'];
    name = json['name'];
    if (json['alliances'] != null) {
      alliances = <Alliances>[];
      json['alliances'].forEach((v) {
        alliances!.add(new Alliances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    if (this.division != null) {
      data['division'] = this.division!.toJson();
    }
    data['round'] = this.round;
    data['instance'] = this.instance;
    data['matchnum'] = this.matchnum;
    data['scheduled'] = this.scheduled;
    data['started'] = this.started;
    data['field'] = this.field;
    data['scored'] = this.scored;
    data['name'] = this.name;
    if (this.alliances != null) {
      data['alliances'] = this.alliances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  int? id;
  String? name;
  String? code;

  Event({this.id, this.name, this.code});

  Event.fromJson(Map<String, dynamic> json) {
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

class Division {
  int? id;
  String? name;
  Null? code;

  Division({this.id, this.name, this.code});

  Division.fromJson(Map<String, dynamic> json) {
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

class Alliances {
  String? color;
  int? score;
  List<Teams>? teams;

  Alliances({this.color, this.score, this.teams});

  Alliances.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    score = json['score'];
    if (json['teams'] != null) {
      teams = <Teams>[];
      json['teams'].forEach((v) {
        teams!.add(new Teams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['score'] = this.score;
    if (this.teams != null) {
      data['teams'] = this.teams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teams {
  Division? team;
  bool? sitting;

  Teams({this.team, this.sitting});

  Teams.fromJson(Map<String, dynamic> json) {
    team = json['team'] != null ? new Division.fromJson(json['team']) : null;
    sitting = json['sitting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    data['sitting'] = this.sitting;
    return data;
  }
}
