class TeamsSearch {
  Item? item;
  int? refIndex;

  TeamsSearch({this.item, this.refIndex});

  TeamsSearch.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
    refIndex = json['refIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    data['refIndex'] = this.refIndex;
    return data;
  }
}

class Item {
  int? id;
  String? teamName;
  String? organization;
  String? grade;
  String? number;

  Item({this.id, this.teamName, this.organization, this.grade, this.number});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    organization = json['organization'];
    grade = json['grade'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_name'] = this.teamName;
    data['organization'] = this.organization;
    data['grade'] = this.grade;
    data['number'] = this.number;
    return data;
  }
}
