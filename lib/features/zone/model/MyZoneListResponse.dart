class MyZoneListResponse {
  String? status;
  int? page;
  List<ZoneList>? zones;

  MyZoneListResponse({this.status, this.page, this.zones});

  MyZoneListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    if (json['zones'] != null) {
      zones = <ZoneList>[];
      json['zones'].forEach((v) {
        zones!.add(ZoneList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['page'] = page;
    if (zones != null) {
      data['zones'] = zones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ZoneList {
  int? zoneId;
  String? name;
  String? purpose;
  double? lat;
  double? lng;
  int? membersCount;
  int? popularityScore;
  String? zoneType;
  String? role;
  String? createdAt;

  ZoneList({
    this.zoneId,
    this.name,
    this.purpose,
    this.lat,
    this.lng,
    this.membersCount,
    this.popularityScore,
    this.zoneType,
    this.role,
    this.createdAt,
  });

  ZoneList.fromJson(Map<String, dynamic> json) {
    zoneId = json['zone_id'];
    name = json['name'];
    purpose = json['purpose'];
    lat = (json['lat'] as num?)?.toDouble();
    lng = (json['lng'] as num?)?.toDouble();
    membersCount = json['members_count'];
    popularityScore = json['popularity_score'];
    zoneType = json['zone_type'];
    role = json['role'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['zone_id'] = zoneId;
    data['name'] = name;
    data['purpose'] = purpose;
    data['lat'] = lat;
    data['lng'] = lng;
    data['members_count'] = membersCount;
    data['popularity_score'] = popularityScore;
    data['zone_type'] = zoneType;
    data['role'] = role;
    data['created_at'] = createdAt;
    return data;
  }
}