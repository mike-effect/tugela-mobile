import 'package:tugela/models.dart';
import 'package:tugela/providers/base_provider.dart';

abstract class JobsProviderContract extends BaseProvider {
  Map<String?, Paginated<Job>> get jobs;

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

  Future<Paginated<JobApplication>?> getJobsApplications({
    String? mapId,
    Map<String, dynamic> params,
    PaginatedOptions options,
  });

  Future<ApiResponse<JobApplication>?> getApplication(String id);

  Future<ApiResponse<bool>?> updateApplication(
    String id,
    JobApplication data,
  );
}
