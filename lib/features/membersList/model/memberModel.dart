import '../../discovery/model/discovery_Model.dart';

class MemberModelResponse {
  final String status;
  //final int clusterRadiusM;
 // final List<Cluster> clusters;
  final  List<GroupedUser> groupedUsers;

  MemberModelResponse({
    required this.status,
   // required this.clusterRadiusM,
   // required this.clusters,
    required this.groupedUsers,
  });

  factory MemberModelResponse.fromJson(Map<String, dynamic> json) {
    return MemberModelResponse(
      status: json['status'] ?? '',
      // clusterRadiusM: json['cluster_radius_m'] ?? 0,
      // clusters: (json['clusters'] as List<dynamic>? ?? [])
      //     .map((e) => Cluster.fromJson(e))
      //     .toList(),
      groupedUsers:json['members'] != null
          ? List<GroupedUser>.from(
        json['members'].map((x) => GroupedUser.fromJson(x)),
      )
          : [],
    );
  }
}

