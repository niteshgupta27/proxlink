class DiscoveryModelResponse {
  final String status;
  final int clusterRadiusM;
  final List<Cluster> clusters;
  final Map<String, List<GroupedUser>> groupedUsers;

  DiscoveryModelResponse({
    required this.status,
    required this.clusterRadiusM,
    required this.clusters,
    required this.groupedUsers,
  });

  factory DiscoveryModelResponse.fromJson(Map<String, dynamic> json) {
    return DiscoveryModelResponse(
      status: json['status'] ?? '',
      clusterRadiusM: json['cluster_radius_m'] ?? 0,
      clusters: (json['clusters'] as List<dynamic>? ?? [])
          .map((e) => Cluster.fromJson(e))
          .toList(),
      groupedUsers: (json['grouped_users'] as Map<String, dynamic>? ?? {})
          .map(
            (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => GroupedUser.fromJson(e))
              .toList(),
        ),
      ),
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
class GroupedUser {
  final int userId;
  final String name;
  final String profession;
  final double lat;
  final double lng;
final int age;
final String gender;
final String companyname;
  GroupedUser({
    required this.userId,
    required this.name,
    required this.profession,
    required this.lat,
    required this.lng,
    required this.age,
    required this.companyname,
    required this.gender
  });

  factory GroupedUser.fromJson(Map<String, dynamic> json) {
    return GroupedUser(
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      profession: json['profession'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0, age: json['age'] ?? 0, companyname: json['companyname'] ?? '', gender: json['gender']=="M"?"M":"F",
    );
  }
}
