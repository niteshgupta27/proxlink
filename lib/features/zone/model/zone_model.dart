class ZoneModelResponse {
  final String status;
  final List<Cluster> clusters;
  final Map<String, List<ZoneData>> groupedZones;
  final int membershipCount;
  final int ownershipCount;

  ZoneModelResponse({
    required this.status,
    required this.clusters,
    required this.groupedZones,
    required this.membershipCount,
    required this.ownershipCount,
  });

  factory ZoneModelResponse.fromJson(Map<String, dynamic> json) {
    var clustersList = (json['clusters'] as List<dynamic>? ?? [])
        .map((e) => Cluster.fromJson(e))
        .toList();

    Map<String, List<ZoneData>> grouped = {};
    if (json['grouped_zones'] != null) {
      json['grouped_zones'].forEach((key, value) {
        grouped[key] = (value as List<dynamic>)
            .map((e) => ZoneData.fromJson(e))
            .toList();
      });
    }

    return ZoneModelResponse(
      status: json['status'] ?? '',
      membershipCount: json['membership_count'] ?? 0,
      ownershipCount: json['ownership_count'] ?? 0,
      clusters: clustersList,
      groupedZones: grouped,
    );
  }
}

class Cluster {
  final String groupId;
  final double lat;
  final double lng;
  final int count;

  Cluster({
    required this.groupId,
    required this.lat,
    required this.lng,
    required this.count,
  });

  factory Cluster.fromJson(Map<String, dynamic> json) {
    return Cluster(
      groupId: json['group_id'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] ?? 0,
    );
  }
}

class ZoneData {
  final int zoneId;
  final String name;
  final String purpose;
  final String skillsHash;
  final double lat;
  final double lng;
  final int latBucket;
  final int lngBucket;
  final int membersCount;
  final int popularityScore;
  final String zoneType;
  final double distanceM;
  final List<String> skills;
  final bool isMember;

  ZoneData({
    required this.zoneId,
    required this.name,
    required this.purpose,
    required this.skillsHash,
    required this.lat,
    required this.lng,
    required this.latBucket,
    required this.lngBucket,
    required this.membersCount,
    required this.popularityScore,
    required this.zoneType,
    required this.distanceM,
    required this.skills,
    required this.isMember,
  });

  factory ZoneData.fromJson(Map<String, dynamic> json) {
    return ZoneData(
      zoneId: json['zone_id'] ?? 0,
      name: json['name'] ?? '',
      purpose: json['purpose'] ?? '',
      skillsHash: json['skills_hash'] ?? '',
      lat: double.tryParse(json['lat']?.toString() ?? '0.0') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? '0.0') ?? 0.0,
      latBucket: json['lat_bucket'] ?? 0,
      lngBucket: json['lng_bucket'] ?? 0,
      membersCount: json['members_count'] ?? 0,
      popularityScore: json['popularity_score'] ?? 0,
      zoneType: json['zone_type'] ?? '',
      distanceM: (json['distance_m'] as num?)?.toDouble() ?? 0.0,
      skills: json['skills'] is List ? List<String>.from(json['skills']) : [],
      isMember: json['is_member'] == 1?true:false,
    );
  }
}
