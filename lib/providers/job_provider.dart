import 'package:tugela/models.dart';
import 'package:tugela/providers/contracts/job_provider.contract.dart';
import 'package:tugela/utils.dart';

class JobProvider extends JobsProviderContract {
  final Map<String?, Paginated<Job>> _jobsMap = {};
  final Map<String?, Paginated<JobApplication>> _applicationsMap = {};

  @override
  Map<String?, Paginated<Job>> get jobs => _jobsMap;

  @override
  Map<String?, Paginated<JobApplication>> get applications => _applicationsMap;

  @override
  void initialize() {
    getJobs();
    super.initialize();
  }

  @override
  void reset() {
    _jobsMap.clear();
    _applicationsMap.clear();
  }

  @override
  Future<ApiResponse<bool>?> createJob(Job data) async {
    try {
      final res = await apiService.createJob(data);
      await getJobs();
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> deleteJob(String id) async {
    try {
      final res = await apiService.deleteJob(id);
      getJobs();
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<Paginated<Job>?> getJobs({
    String? mapId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {
        'page_size': defaultPageSize,
        ...params,
      };
      map["ordering"] = "-created_at";
      final res = await paginatedQuery<Job>(
        options: options,
        paginated: _jobsMap[mapId],
        initialRequest: () => apiService.getJobs(params: map),
        loadMoreRequest: () => apiService.getJobs(
          params: map
            ..addAll({
              'page': _jobsMap[mapId]?.pagination?.next,
            }),
        ),
      );
      if (res?.data != null) _jobsMap[mapId ?? ''] = res!;
      notifyListeners();
      return _jobsMap[mapId ?? ''];
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<Job>?> getJob(String id) async {
    try {
      return await apiService.getJob(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> updateJob(
    String id,
    Job data,
  ) async {
    try {
      final res = await apiService.updateJob(id, data);
      getJobs();
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> createApplication(JobApplication data) async {
    try {
      final res = await apiService.createJobApplication(data);
      await getJobsApplications();
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> deleteApplication(String id) async {
    try {
      final res = await apiService.deleteJobApplication(id);
      getJobsApplications();
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<Paginated<JobApplication>?> getJobsApplications({
    String? mapId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {
        'page_size': defaultPageSize,
        ...params,
      };
      final res = await paginatedQuery<JobApplication>(
        options: options,
        paginated: _applicationsMap[mapId],
        initialRequest: () => apiService.getJobApplications(params: map),
        loadMoreRequest: () => apiService.getJobApplications(
          params: map
            ..addAll({
              'page': _applicationsMap[mapId]?.pagination?.next,
            }),
        ),
      );
      if (res?.data != null) _applicationsMap[mapId ?? ''] = res!;
      notifyListeners();
      return _applicationsMap[mapId ?? ''];
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<JobApplication>?> getApplication(String id) async {
    try {
      return await apiService.getJobApplication(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> updateApplication(
    String id,
    JobApplication data,
  ) async {
    try {
      final res = await apiService.updateJobApplication(id, data);
      getJobsApplications();
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }
}
