class Skills {
  Meta? meta;
  List<Data>? data;

  Skills({this.meta, this.data});

  Skills.fromJson(Map<String, dynamic> json) {
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

class Data {
  int? id;
  Event? event;
  Team? team;
  String? type;
  Team? season;
  Null? division;
  int? rank;
  int? score;
  int? attempts;

  Data(
      {this.id,
      this.event,
      this.team,
      this.type,
      this.season,
      this.division,
      this.rank,
      this.score,
      this.attempts});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
    type = json['type'];
    season = json['season'] != null ? new Team.fromJson(json['season']) : null;
    division = json['division'];
    rank = json['rank'];
    score = json['score'];
    attempts = json['attempts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    data['type'] = this.type;
    if (this.season != null) {
      data['season'] = this.season!.toJson();
    }
    data['division'] = this.division;
    data['rank'] = this.rank;
    data['score'] = this.score;
    data['attempts'] = this.attempts;
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

class Team {
  int? id;
  String? name;
  Null? code;

  Team({this.id, this.name, this.code});

  Team.fromJson(Map<String, dynamic> json) {
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
