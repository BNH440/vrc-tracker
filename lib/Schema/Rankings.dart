class Rankings {
  Meta? meta;
  List<Data>? data;

  Rankings({this.meta, this.data});

  Rankings.fromJson(Map<String, dynamic> json) {
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
  Division? division;
  int? rank;
  Division? team;
  int? wins;
  int? losses;
  int? ties;
  int? wp;
  int? ap;
  int? sp;
  int? highScore;
  num? averagePoints;
  int? totalPoints;

  Data(
      {this.id,
      this.event,
      this.division,
      this.rank,
      this.team,
      this.wins,
      this.losses,
      this.ties,
      this.wp,
      this.ap,
      this.sp,
      this.highScore,
      this.averagePoints,
      this.totalPoints});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    division = json['division'] != null ? new Division.fromJson(json['division']) : null;
    rank = json['rank'];
    team = json['team'] != null ? new Division.fromJson(json['team']) : null;
    wins = json['wins'];
    losses = json['losses'];
    ties = json['ties'];
    wp = json['wp'];
    ap = json['ap'];
    sp = json['sp'];
    highScore = json['high_score'];
    averagePoints = json['average_points'];
    totalPoints = json['total_points'];
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
    data['rank'] = this.rank;
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    data['wins'] = this.wins;
    data['losses'] = this.losses;
    data['ties'] = this.ties;
    data['wp'] = this.wp;
    data['ap'] = this.ap;
    data['sp'] = this.sp;
    data['high_score'] = this.highScore;
    data['average_points'] = this.averagePoints;
    data['total_points'] = this.totalPoints;
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
