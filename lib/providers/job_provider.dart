import 'package:dio/dio.dart' as dio;
import 'package:tugela/models.dart';
import 'package:tugela/providers/contracts/job_provider.contract.dart';
import 'package:tugela/utils.dart';

class JobProvider extends JobsProviderContract {
  final Map<String?, Paginated<Job>> _jobsMap = {};
  final Map<String?, Job> _jobMap = {};
  final Map<String?, Paginated<JobApplication>> _applicationsMap = {};
  final Map<String?, Paginated<JobSubmission>> _submissionsMap = {};

  @override
  Map<String?, Paginated<Job>> get jobs => _jobsMap;

  Map<String?, Job> get job => _jobMap;

  @override
  Map<String?, Paginated<JobApplication>> get applications => _applicationsMap;

  Map<String?, Paginated<JobSubmission>> get jobSubmissions => _submissionsMap;

  @override
  void initialize() {
    getJobs();
    super.initialize();
  }

  @override
  void reset() {
    _jobMap.clear();
    _jobsMap.clear();
    _applicationsMap.clear();
    _submissionsMap.clear();
  }

  @override
  Future<ApiResponse<bool>?> createJob(Job data) async {
    try {
      final res = await apiService.createJob(data);
      getJobs();
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
      final res = await apiService.getJob(id);
      if (res.data != null) {
        _jobMap[id] = res.data!;
        notifyListeners();
      }
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> updateJob(String id, Job data) async {
    try {
      final res = await apiService.updateJob(id, data);
      getJob(id);
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
      await getJobApplications();
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
      getJobApplications();
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<Paginated<JobApplication>?> getJobApplications({
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
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> updateApplicationStatus(
    String id,
    ApplicationStatus status,
  ) async {
    try {
      final res = await apiService.updateJobApplicationStatus(id, status);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  // ------------------- Job Submissions endpoints -------------------
  @override
  Future<ApiResponse<bool>?> createJobSubmission(
    JobSubmission data,
    dio.MultipartFile? file,
  ) async {
    try {
      final res = await apiService.createJobSubmission(data, file);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> deleteJobSubmission(String id) async {
    try {
      final res = await apiService.deleteJobSubmission(id);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<Paginated<JobSubmission>?> getJobSubmissions({
    String? mapId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {
        'page_size': defaultPageSize,
        ...params,
      };
      // map["ordering"] = "-created_at";
      final res = await paginatedQuery<JobSubmission>(
        options: options,
        paginated: _submissionsMap[mapId],
        initialRequest: () => apiService.getJobSubmissions(params: map),
        loadMoreRequest: () => apiService.getJobSubmissions(
          params: map
            ..addAll({
              'page': _submissionsMap[mapId]?.pagination?.next,
            }),
        ),
      );
      if (res?.data != null) _submissionsMap[mapId ?? ''] = res!;
      notifyListeners();
      return _submissionsMap[mapId ?? ''];
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<JobSubmission>?> getJobSubmission(String id) async {
    try {
      final res = await apiService.getJobSubmission(id);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> updateJobSubmission(
    String id,
    JobSubmission data,
    dio.MultipartFile? file,
  ) async {
    try {
      final res = await apiService.updateJobSubmission(id, data, file);
      getJobSubmission(id);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }
}
