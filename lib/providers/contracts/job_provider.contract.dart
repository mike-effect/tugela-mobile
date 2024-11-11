import 'package:dio/dio.dart' as dio;
import 'package:tugela/models.dart';
import 'package:tugela/providers/base_provider.dart';

abstract class JobsProviderContract extends BaseProvider {
  Map<String?, Paginated<Job>> get jobs;
  Map<String?, JobScore> get jobScores;

  Map<String?, Paginated<JobApplication>> get applications;

  Future<ApiResponse<bool>?> createJob(Job data);

  Future<ApiResponse<bool>?> deleteJob(String id);

  Future<Paginated<Job>?> getJobs({
    String? mapId,
    Map<String, dynamic> params,
    PaginatedOptions options,
  });

  Future<ApiResponse<Job>?> getJob(String id);

  Future<ApiResponse<bool>?> updateJob(String id, Job data);

  Future<ApiResponse<bool>?> createApplication(JobApplication data);

  Future<ApiResponse<bool>?> deleteApplication(String id);

  Future<Paginated<JobApplication>?> getJobApplications({
    String? mapId,
    Map<String, dynamic> params,
    PaginatedOptions options,
  });

  Future<ApiResponse<JobApplication>?> getApplication(String id);

  Future<ApiResponse<bool>?> updateApplication(
    String id,
    JobApplication data,
  );

  Future<ApiResponse<bool>?> createJobSubmission(
    JobSubmission data,
    dio.MultipartFile? file,
  );

  Future<ApiResponse<bool>?> deleteJobSubmission(String id);

  Future<Paginated<JobSubmission>?> getJobSubmissions({
    String? mapId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  });

  Future<ApiResponse<JobSubmission>?> getJobSubmission(String id);

  Future<ApiResponse<bool>?> updateJobSubmission(
    String id,
    JobSubmission data,
    dio.MultipartFile? file,
  );

  Future<ApiResponse<bool>?> updateApplicationStatus(
    String id,
    ApplicationStatus status,
  );

  Future<ApiResponse<JobScore>?> getJobScore({
    required String freelancerId,
    required String jobId,
  });
}
