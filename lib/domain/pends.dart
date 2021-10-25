// To parse this JSON data, do
//
//     final pends = pendsFromJson(jsonString);

import 'dart:convert';

Pends pendsFromJson(String str) => Pends.fromJson(json.decode(str));

class Pends {
  Pends({
    this.atts,
  });

  List<Att> atts;

  factory Pends.fromJson(Map<String, dynamic> json) => Pends(
    atts: List<Att>.from(json["attendances"].map((x) => Att.fromJson(x))),
  );

}

class Att {
  Att({
    this.id,
    this.userId,
    this.date,
    this.timeIn,
    this.timeOut,
    this.description,
    this.workStatusId,
    this.stateId,
    this.statusId,
    this.approverId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  String userId;
  String date;
  DateTime timeIn;
  dynamic timeOut;
  dynamic description;
  String workStatusId;
  String stateId;
  String statusId;
  dynamic approverId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory Att.fromJson(Map<String, dynamic> json) => Att(
    id: json["id"],
    userId: json["user_id"],
    date: json["date"],
    timeIn: DateTime.parse(json["time_in"]),
    timeOut: json["time_out"],
    description: json["description"],
    workStatusId: json["work_status_id"],
    stateId: json["state_id"],
    statusId: json["status_id"],
    approverId: json["approver_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

}
