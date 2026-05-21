class UserModel {
  String provider;
  String apiKey;
  String pin;

  Map<String, dynamic> profile;
  Map<String, dynamic> measurements;
  Map<String, dynamic> dailyTip;

  UserModel({
    required this.provider,
    required this.apiKey,
    required this.pin,
    required this.profile,
    required this.measurements,
    required this.dailyTip,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      provider: json['provider'],
      apiKey: json['api_key'],
      pin: json['pin'],
      profile: json['profile'] ?? {},
      measurements:
          json['measurements'] ?? {"weight_history": [], "target_weight": null},
      dailyTip: json['daily_tip'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "provider": provider,
      "api_key": apiKey,
      "pin": pin,
      "profile": profile,
      "measurements": measurements,
      "daily_tip": dailyTip,
    };
  }
}
