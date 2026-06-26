import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_base_client.dart';
import '../../event/model/addeventmodel.dart';
import '../model/JobResponse.dart';

class JobService {
  String TAG = "JobService";

  Future<JobResponse> getJobsMap({required Map<String, dynamic> body}) async {
    try {
      print("Job request body: $body");
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.jobs_map,
        body: body,
      );
      print("Job response: $response");
      return JobResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("Job response exception: $exception");
      rethrow;
    }
  }

  Future<AddeventModelResponse> postJob({required Map<String, dynamic> body}) async {
    try {
      print("Post Job request body: $body");
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.jobs_post,
        body: body,
      );
      print("Post Job response: $response");
      return AddeventModelResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      print("Post Job response exception: $exception");
      rethrow;
    }
  }
}
