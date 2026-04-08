class ZoneDetailResponse {
  String? status;
  Zone? zone;
  int? isMember;
  int? isOwner;
  String? role;
  int? distanceKm;
  List<String>? skills;

  ZoneDetailResponse({
    this.status,
    this.zone,
    this.isMember,
    this.isOwner,
    this.role,
    this.distanceKm,
    this.skills,
  });

  ZoneDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    zone = json['zone'] != null ? Zone.fromJson(json['zone']) : null;
    isMember = json['is_member'];
    isOwner = json['is_owner'];
    role = json['role'];
    distanceKm = json['distance_km'];
    skills = json['skills'] != null ? List<String>.from(json['skills']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (zone != null) {
      data['zone'] = zone!.toJson();
    }
    data['is_member'] = isMember;
    data['is_owner'] = isOwner;
    data['role'] = role;
    data['distance_km'] = distanceKm;
    data['skills'] = skills;
    return data;
  }
}

class Zone {
  int? zoneId;
  int? ownerUserId;
  String? name;
  String? purpose;
  String? skills;
  String? skillsHash;
  String? lat;
  String? lng;
  int? radiusKm;
  String? zoneType;
  int? moveWithOwner;
  int? membersCount;
  int? popularityScore;
  String? createdAt;

  Zone({
    this.zoneId,
    this.ownerUserId,
    this.name,
    this.purpose,
    this.skills,
    this.skillsHash,
    this.lat,
    this.lng,
    this.radiusKm,
    this.zoneType,
    this.moveWithOwner,
    this.membersCount,
    this.popularityScore,
    this.createdAt,
  });

  Zone.fromJson(Map<String, dynamic> json) {
    zoneId = json['zone_id'];
    ownerUserId = json['owner_user_id'];
    name = json['name'];
    purpose = json['purpose'];
    skills = json['skills'];
    skillsHash = json['skills_hash'];
    lat = json['lat'];
    lng = json['lng'];
    radiusKm = json['radius_km'];
    zoneType = json['zone_type'];
    moveWithOwner = json['move_with_owner'];
    membersCount = json['members_count'];
    popularityScore = json['popularity_score'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['zone_id'] = zoneId;
    data['owner_user_id'] = ownerUserId;
    data['name'] = name;
    data['purpose'] = purpose;
    data['skills'] = skills;
    data['skills_hash'] = skillsHash;
    data['lat'] = lat;
    data['lng'] = lng;
    data['radius_km'] = radiusKm;
    data['zone_type'] = zoneType;
    data['move_with_owner'] = moveWithOwner;
    data['members_count'] = membersCount;
    data['popularity_score'] = popularityScore;
    data['created_at'] = createdAt;
    return data;
  }
}