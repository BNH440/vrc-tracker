class MatchPrediction {
  String? blue1;
  String? blue2;
  String? predictionMsg;
  String? red1;
  String? red2;
  double? redWinProbability;

  MatchPrediction(
      {this.blue1, this.blue2, this.predictionMsg, this.red1, this.red2, this.redWinProbability});

  MatchPrediction.fromJson(Map<String, dynamic> json) {
    blue1 = json['blue1'];
    blue2 = json['blue2'];
    predictionMsg = json['prediction_msg'];
    red1 = json['red1'];
    red2 = json['red2'];
    redWinProbability = json['red_win_probability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blue1'] = this.blue1;
    data['blue2'] = this.blue2;
    data['prediction_msg'] = this.predictionMsg;
    data['red1'] = this.red1;
    data['red2'] = this.red2;
    data['red_win_probability'] = this.redWinProbability;
    return data;
  }
}
