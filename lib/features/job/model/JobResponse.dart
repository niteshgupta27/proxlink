import 'dart:convert';

class JobResponse {
  final String status;
  final List<Cluster> clusters;
  final Map<String, List<JobDetail>> groupedDetails;

  JobResponse({
    required this.status,
    required this.clusters,
    required this.groupedDetails,
  });

  factory JobResponse.fromJson(Map<String, dynamic> json) {
    // Parsing clusters
    var clusterList = json['clusters'] as List? ?? [];
    List<Cluster> clustersModel = clusterList.map((i) => Cluster.fromJson(i)).toList();

    // Parsing grouped_details (Dynamic keys)
    Map<String, List<JobDetail>> detailsMap = {};
    if (json['grouped_details'] != null) {
      json['grouped_details'].forEach((key, value) {
        var list = value as List;
        detailsMap[key] = list.map((item) => JobDetail.fromJson(item)).toList();
      });
    }

    return JobResponse(
      status: json['status']?.toString() ?? '',
      clusters: clustersModel,
      groupedDetails: detailsMap,
    );
  }
}

class Cluster {
  final String groupId;
  final double lat;
  final double lng;
  final int count;

  Cluster({required this.groupId, required this.lat, required this.lng, required this.count});

  factory Cluster.fromJson(Map<String, dynamic> json) {
    return Cluster(
      groupId: json['group_id']?.toString() ?? '',
      lat: double.tryParse(json['lat']?.toString() ?? '') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? '') ?? 0.0,
      count: int.tryParse(json['count']?.toString() ?? '') ?? 0,
    );
  }
}

class JobDetail {
  final int jobId;
  final String title;
  final String companyName;
  final String skillsHash;
  final double salaryMin;
  final double salaryMax;
  final String salaryCurrency;
  final double lat;
  final double lng;
  final DateTime? createdAt;

  JobDetail({
    required this.jobId,
    required this.title,
    required this.companyName,
    required this.skillsHash,
    required this.salaryMin,
    required this.salaryMax,
    required this.salaryCurrency,
    required this.lat,
    required this.lng,
    required this.createdAt,
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) {
    return JobDetail(
      jobId: int.tryParse(json['job_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      skillsHash: json['skills_hash']?.toString() ?? '',
      salaryMin: double.tryParse(json['salary_min']?.toString() ?? '') ?? 0.0,
      salaryMax: double.tryParse(json['salary_max']?.toString() ?? '') ?? 0.0,
      salaryCurrency: json['salary_currency']?.toString() ?? 'INR',
      lat: double.tryParse(json['lat']?.toString() ?? '') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? '') ?? 0.0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }
}
