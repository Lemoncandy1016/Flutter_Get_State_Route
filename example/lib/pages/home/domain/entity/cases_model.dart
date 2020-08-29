// To parse this JSON data, do
//
//     final CasesModel = CasesModelFromJson(jsonString);

import 'dart:convert';

class CasesModel {
  final Global global;
  final List<Country> countries;
  final String date;

  CasesModel({
    this.global,
    this.countries,
    this.date,
  });

  factory CasesModel.fromRawJson(String str) =>
      CasesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CasesModel.fromJson(Map<String, dynamic> json) => CasesModel(
        global: json["Global"] == null ? null : Global.fromJson(json["Global"]),
        countries: json["Countries"] == null
            ? null
            : List<Country>.from(
                json["Countries"].map((x) => Country.fromJson(x))),
        date: json["Date"] == null ? null : json["Date"],
      );

  Map<String, dynamic> toJson() => {
        "Global": global == null ? null : global.toJson(),
        "Countries": countries == null
            ? null
            : List<dynamic>.from(countries.map((x) => x.toJson())),
        "Date": date == null ? null : date,
      };
}

class Country {
  final String country;
  final String countryCode;
  final String slug;
  final int newConfirmed;
  final int totalConfirmed;
  final int newDeaths;
  final int totalDeaths;
  final int newRecovered;
  final int totalRecovered;
  final String date;

  Country({
    this.country,
    this.countryCode,
    this.slug,
    this.newConfirmed,
    this.totalConfirmed,
    this.newDeaths,
    this.totalDeaths,
    this.newRecovered,
    this.totalRecovered,
    this.date,
  });

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        country: json["Country"] == null ? null : json["Country"],
        countryCode: json["CountryCode"] == null ? null : json["CountryCode"],
        slug: json["Slug"] == null ? null : json["Slug"],
        newConfirmed:
            json["NewConfirmed"] == null ? null : json["NewConfirmed"],
        totalConfirmed:
            json["TotalConfirmed"] == null ? null : json["TotalConfirmed"],
        newDeaths: json["NewDeaths"] == null ? null : json["NewDeaths"],
        totalDeaths: json["TotalDeaths"] == null ? null : json["TotalDeaths"],
        newRecovered:
            json["NewRecovered"] == null ? null : json["NewRecovered"],
        totalRecovered:
            json["TotalRecovered"] == null ? null : json["TotalRecovered"],
        date: json["Date"] == null ? null : json["Date"],
      );

  Map<String, dynamic> toJson() => {
        "Country": country == null ? null : country,
        "CountryCode": countryCode == null ? null : countryCode,
        "Slug": slug == null ? null : slug,
        "NewConfirmed": newConfirmed == null ? null : newConfirmed,
        "TotalConfirmed": totalConfirmed == null ? null : totalConfirmed,
        "NewDeaths": newDeaths == null ? null : newDeaths,
        "TotalDeaths": totalDeaths == null ? null : totalDeaths,
        "NewRecovered": newRecovered == null ? null : newRecovered,
        "TotalRecovered": totalRecovered == null ? null : totalRecovered,
        "Date": date == null ? null : date,
      };
}

class Global {
  final int newConfirmed;
  final int totalConfirmed;
  final int newDeaths;
  final int totalDeaths;
  final int newRecovered;
  final int totalRecovered;

  Global({
    this.newConfirmed,
    this.totalConfirmed,
    this.newDeaths,
    this.totalDeaths,
    this.newRecovered,
    this.totalRecovered,
  });

  factory Global.fromRawJson(String str) => Global.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Global.fromJson(Map<String, dynamic> json) => Global(
        newConfirmed:
            json["NewConfirmed"] == null ? null : json["NewConfirmed"],
        totalConfirmed:
            json["TotalConfirmed"] == null ? null : json["TotalConfirmed"],
        newDeaths: json["NewDeaths"] == null ? null : json["NewDeaths"],
        totalDeaths: json["TotalDeaths"] == null ? null : json["TotalDeaths"],
        newRecovered:
            json["NewRecovered"] == null ? null : json["NewRecovered"],
        totalRecovered:
            json["TotalRecovered"] == null ? null : json["TotalRecovered"],
      );

  Map<String, dynamic> toJson() => {
        "NewConfirmed": newConfirmed == null ? null : newConfirmed,
        "TotalConfirmed": totalConfirmed == null ? null : totalConfirmed,
        "NewDeaths": newDeaths == null ? null : newDeaths,
        "TotalDeaths": totalDeaths == null ? null : totalDeaths,
        "NewRecovered": newRecovered == null ? null : newRecovered,
        "TotalRecovered": totalRecovered == null ? null : totalRecovered,
      };
}
