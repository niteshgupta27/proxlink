
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
  final String job_type;
  final String experience_text;
  final String education;

  final String salaryCurrency;
  final double lat;
  final double lng;
 // final DateTime? createdAt;
final int posted_by_user_id;
  JobDetail({
    required this.jobId,
    required this.title,
    required this.companyName,
    required this.skillsHash,
    required this.job_type,
    required this.experience_text,required this.education,
    required this.salaryCurrency,
    required this.lat,
    required this.lng,
   // required this.createdAt,
    required this.posted_by_user_id
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) {
    print("job detail$json");
    return JobDetail(
      jobId: int.tryParse(json['job_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      skillsHash: json['skills_text']?.toString() ?? '',
        job_type: json['job_type']?.toString() ?? '',
        experience_text: json['experience_text']?.toString() ?? '',
        education: json['education']?.toString() ?? '',
      salaryCurrency: json['salary_text']?.toString() ?? 'INR',
      lat: double.tryParse(json['lat']?.toString() ?? '') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? '') ?? 0.0,
      //createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      posted_by_user_id: json['posted_by_user_id']??0
    );
  }
}
