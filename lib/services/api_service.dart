import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:tugela/models.dart';
import 'package:tugela/services/contracts/api_service.contract.dart';
import 'package:tugela/services/contracts/hive_service.contract.dart';
import 'package:tugela/services/sl.dart';
import 'package:tugela/utils.dart';

class ApiService implements ApiServiceContract {
  final dio.Dio _client;
  ApiService(this._client);

  User? _user;

  final _sessionController = StreamController<SessionState>.broadcast();

  final _hiveService = sl.get<HiveServiceContract>();

  static String _appVersion = "";

  @override
  User? get user => _user;

  @override
  Sink<SessionState> get sink => _sessionController.sink;

  @override
  Stream<SessionState> get stream => _sessionController.stream;

  @override
  void closeStream() => _sessionController.close();

  @override
  String get appVersion => _appVersion;

  @override
  String setAppVersion(String version) {
    _appVersion = version;
    return _appVersion;
  }

  @override
  User? setUser(User? user) {
    _user = user;
    return _user;
  }

  bool _isSuccessful(dio.Response res) {
    if (res.statusCode == 401) {
      _hiveService.logout();
      _sessionController.sink.add(SessionState.unauthenticated);
    }
    return res.statusCode! >= 200 && res.statusCode! < 400;
  }

  Future<dio.Response> _makeRequest(
    String method,
    String url, {
    Map<String, dynamic>? payload,
    Map<String, dynamic>? queryParams,
    bool auth = true,
    dio.FormData? formData,
  }) async {
    final version = sl.get<ApiServiceContract>().appVersion;
    final ua = 'Tugela/$version '
        '(${osNameForPlatform(defaultTargetPlatform)}; ${Platform.operatingSystemVersion})';

    String? token;
    if (auth) {
      token = await sl.get<HiveServiceContract>().getAccessToken();
    }
    final options = dio.Options(
      method: method,
      contentType: "application/json",
      responseType: dio.ResponseType.json,
      headers: {
        if (token != null) "Authorization": "Bearer $token",
        "User-Agent": ua,
        "Mobile-Version": version,
      },
    );

    try {
      final response = await _client.request(
        url,
        data: formData ?? payload,
        queryParameters: queryParams,
        options: options,
      );
      if (_isSuccessful(response)) {
      } else {}
      return response;
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _hiveService.logout();
        _sessionController.sink.add(SessionState.unauthenticated);
      } else {
        if (e.response?.data == null) rethrow;
      }
      return e.response!;
    }
  }

  @override
  Future<dio.Response> post(
    String url,
    Map<String, dynamic> payload, {
    bool auth = true,
  }) async {
    return await _makeRequest('POST', url, payload: payload, auth: auth);
  }

  @override
  Future<dio.Response> put(
    String url,
    Map<String, dynamic> payload, {
    bool auth = true,
  }) async {
    return await _makeRequest('PUT', url, payload: payload, auth: auth);
  }

  @override
  Future<dio.Response> get(
    String url, {
    Map<String, dynamic>? params,
    bool auth = true,
  }) async {
    params?.removeWhere((k, v) => v == null || v == "");
    return await _makeRequest('GET', url, queryParams: params, auth: auth);
  }

  @override
  Future<dio.Response> delete(
    String url, {
    Map<String, dynamic>? params,
  }) async {
    params?.removeWhere((k, v) => v == null);
    return await _makeRequest('DELETE', url, queryParams: params);
  }

  @override
  Future<dio.Response> patch(
    String url,
    Map<String, dynamic> payload,
  ) async {
    return await _makeRequest(
      'PATCH',
      url,
      payload: payload,
    );
  }

  @override
  Future<dio.Response> multipartPatch(
    String url, {
    Map<String, dynamic> fields = const {},
    Map<String, dio.MultipartFile> files = const {},
  }) async {
    final formData = dio.FormData.fromMap({
      ...fields,
      ...files,
    });
    return await _makeRequest('PATCH', url, formData: formData);
  }

  @override
  Future<dio.Response> multipartPost(
    String url, {
    Map<String, dynamic> fields = const {},
    Map<String, dio.MultipartFile> files = const {},
  }) async {
    final formData = dio.FormData.fromMap({
      ...fields,
      ...files,
    });

    return await _makeRequest('POST', url, formData: formData);
  }

  @override
  Future<ApiResponse<TokenObtainPairResponse>> login(
    TokenObtainPairRequest data,
  ) async {
    final res = await post(
      '/auth/login/',
      data.toJson(),
      auth: false,
    );
    return ApiResponse.fromJson(res.data, TokenObtainPairResponse.fromJson);
  }

  @override
  Future<ApiResponse<TokenRefreshResponse>> refreshToken(String refresh) async {
    final res = await post(
      '/auth/refresh-token/',
      {"refresh": refresh},
    );
    return ApiResponse.fromJson(res.data, TokenRefreshResponse.fromJson);
  }

  @override
  Future<ApiResponse<SignUpResponse>> signUp(SignUpRequest data) async {
    final res = await post(
      '/auth/signup/',
      data.toJson(),
      auth: false,
    );
    return ApiResponse.fromJson(res.data, SignUpResponse.fromJson);
  }

  @override
  Future<ApiResponse<List<Company>>> getCompanies({
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get(
      '/companies/',
      params: params,
    );
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => Company.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<bool>> createCompany(
    Company data, {
    dio.MultipartFile? imageUpload,
  }) async {
    final res = await multipartPost(
      '/companies/',
      fields: data.toInputJson(),
      files: {if (imageUpload != null) "logo": imageUpload},
    );
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<Company>> getCompany(String id) async {
    final res = await get('/companies/$id/');
    return ApiResponse.fromJson(res.data, Company.fromJson);
  }

  @override
  Future<ApiResponse<bool>> updateCompany(
    String id,
    Company data, {
    dio.MultipartFile? imageUpload,
  }) async {
    final res = await multipartPatch(
      '/companies/$id/',
      fields: data.toInputJson(),
      files: {if (imageUpload != null) "logo": imageUpload},
    );
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<bool>> deleteCompany(String id) async {
    final res = await delete('/companies/$id/');
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<List<Freelancer>>> getFreelancers({
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get('/freelancers/', params: params);
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => Freelancer.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<bool>> createFreelancer(
    Freelancer data, {
    dio.MultipartFile? imageUpload,
  }) async {
    final res = await multipartPost(
      '/freelancers/',
      fields: data.toInputJson(),
      files: {if (imageUpload != null) "profile_image": imageUpload},
    );
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<Freelancer>> getFreelancer(String id) async {
    final res = await get('/freelancers/$id/');
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<bool>> updateFreelancer(
    String id,
    Freelancer data, {
    dio.MultipartFile? imageUpload,
  }) async {
    final res = await multipartPatch(
      '/freelancers/$id/',
      fields: data.toInputJson(),
      files: {if (imageUpload != null) "profile_image": imageUpload},
    );
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<List<PortfolioItem>>> getPortfolioItems({
    required String freelancerId,
    Map<String, dynamic> params = const {},
  }) async {
    params['ordering'] = "-start_date";
    final res = await get(
      '/freelancers/portfolio-items/',
      params: {
        "freelancer": freelancerId,
        ...params,
      },
    );
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => PortfolioItem.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<bool>> createPortfolioItem(
    PortfolioItem data,
  ) async {
    final res = await post('/freelancers/portfolio-items/', data.toInputJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<PortfolioItem>> getPortfolioItem(String id) async {
    final res = await get('/freelancers/portfolio-items/$id/');
    return ApiResponse.fromJson(res.data, PortfolioItem.fromJson);
  }

  @override
  Future<ApiResponse<bool>> updatePortfolioItem(
    String id,
    PortfolioItem data,
  ) async {
    final res =
        await patch('/freelancers/portfolio-items/$id/', data.toInputJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<bool>> deletePortfolioItem(String id) async {
    final res = await delete('/freelancers/portfolio-items/$id/');
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<List<FreelancerService>>> getServices({
    required String freelancerId,
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get(
      '/freelancers/services/',
      params: {'freelancer': freelancerId, ...params},
    );
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => FreelancerService.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<bool>> createService(
    FreelancerService data,
  ) async {
    final res = await post('/freelancers/services/', data.toJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<FreelancerService>> getService(String id) async {
    final res = await get('/freelancers/services/$id/');
    return ApiResponse.fromJson(res.data, FreelancerService.fromJson);
  }

  @override
  Future<ApiResponse<bool>> updateService(
      String id, FreelancerService data) async {
    final res = await patch('/freelancers/services/$id/', data.toJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<bool>> deleteService(String id) async {
    final res = await delete('/freelancers/services/$id/');
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<List<WorkExperience>>> getWorkExperiences({
    required String freelancerId,
    Map<String, dynamic> params = const {},
  }) async {
    params['ordering'] = "-start_date";
    final res = await get(
      '/freelancers/work-experiences/',
      params: {'freelancer': freelancerId, ...params},
    );
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => WorkExperience.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<bool>> createWorkExperience(WorkExperience data) async {
    final res = await post('/freelancers/work-experiences/', data.toJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<WorkExperience>> getWorkExperience(String id) async {
    final res = await get('/freelancers/work-experiences/$id/');
    return ApiResponse.fromJson(res.data, WorkExperience.fromJson);
  }

  @override
  Future<ApiResponse<bool>> updateWorkExperience(
    String id,
    WorkExperience data,
  ) async {
    final res =
        await patch('/freelancers/work-experiences/$id/', data.toJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<bool>> deleteWorkExperience(String id) async {
    final res = await delete('/freelancers/work-experiences/$id/');
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<List<Job>>> getJobs({
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get('/jobs/', params: params);
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => Job.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<bool>> createJob(Job data) async {
    final res = await post('/jobs/', data.toJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<Job>> getJob(String id) async {
    final res = await get('/jobs/$id/');
    return ApiResponse.fromJson(res.data, Job.fromJson);
  }

  @override
  Future<ApiResponse<bool>> updateJob(String id, Job data) async {
    final res = await put('/jobs/$id/', data.toJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<bool>> deleteJob(String id) async {
    final res = await delete('/jobs/$id/');
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<List<JobApplication>>> getJobApplications({
    String? jobId,
    String? freelancerId,
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get('/jobs/applications/', params: {
      'job': jobId,
      'freelancer': freelancerId,
      ...params,
    });
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => JobApplication.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<bool>> createJobApplication(JobApplication data) async {
    final res = await post('/jobs/applications/', data.toInputJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<JobApplication>> getJobApplication(String id) async {
    final res = await get('/jobs/applications/$id/');
    return ApiResponse.fromJson(res.data, JobApplication.fromJson);
  }

  @override
  Future<ApiResponse<bool>> updateJobApplication(
      String id, JobApplication data) async {
    final res = await put('/jobs/applications/$id/', data.toInputJson());
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<bool>> updateJobApplicationStatus(
    String id,
    ApplicationStatus status,
  ) async {
    final res = await post(
      '/jobs/applications/$id/update-status/',
      {"id": id, "status": status.name},
    );
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<bool>> deleteJobApplication(String id) async {
    final res = await delete('/jobs/applications/$id/');
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<List<JobSubmission>>> getJobSubmissions({
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get('/jobs/submissions/', params: params);
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => JobSubmission.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<bool>> createJobSubmission(
    JobSubmission data,
    dio.MultipartFile? file,
  ) async {
    final res = await multipartPost(
      '/jobs/submissions/',
      fields: data.toInputJson(),
      files: {if (file != null) "file": file},
    );
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<JobSubmission>> getJobSubmission(String id) async {
    final res = await get('/jobs/submissions/$id/');
    return ApiResponse.fromJson(res.data, JobSubmission.fromJson);
  }

  @override
  Future<ApiResponse<bool>> updateJobSubmission(
    String id,
    JobSubmission data,
    dio.MultipartFile? file,
  ) async {
    final res = await multipartPatch(
      '/jobs/submissions/$id/',
      fields: data.toInputJson(),
      files: {if (file != null) "file": file},
    );
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<bool>> deleteJobSubmission(String id) async {
    final res = await delete('/jobs/submissions/$id/');
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<List<Skill>>> getSkills({
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get('/skills/', params: params);
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => Skill.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<User>> getUserMe() async {
    final res = await get('/users/me/');
    return ApiResponse.fromJson(res.data, User.fromJson);
  }

  @override
  Future<ApiResponse<List<Industry>>> getCompanyIndustries({
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get('/companies/industries/', params: params);
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => Industry.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<List<CompanyValue>>> getCompanyValues({
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get('/companies/values/', params: params);
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => CompanyValue.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<List<Currency>>> getCurrencies({
    Map<String, dynamic> params = const {},
  }) async {
    final res = await get('/extras/currencies/', params: {"type": "fiat"});
    return ApiResponse.fromJsonList(
      res.data,
      paginated: false,
      (json) => (json).map((e) => Currency.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<XRPBalance>> getBalance(String address) async {
    final res = await post(
      '/extras/get-balance/',
      {"xrp_address": address},
    );
    return ApiResponse.fromJson(res.data, XRPBalance.fromJson);
  }

  @override
  Future<ApiResponse<List<PaymentService>>> getPaymentServices() async {
    final res = await get('/extras/get-payment-services/');
    return ApiResponse.fromJsonList(
      res.data,
      (l) => l.map((j) => PaymentService.fromJson(j)).toList(),
    );
  }

  @override
  Future<ApiResponse<bool>> withdrawXrp({
    required String address,
    required String amount,
  }) async {
    final type = user?.accountType;
    final res = await post('/extras/withdraw-xrp/', {
      "xrp_address": address,
      "xrp_amount": amount,
      if (type != null)
        type == AccountType.freelancer ? 'freelancer' : 'company':
            type == AccountType.freelancer
                ? user?.freelancer?.id
                : user?.company?.id,
    });
    return ApiResponse.successful(res);
  }

  @override
  Future<ApiResponse<JobScore>> getJobScore({
    required String freelancerId,
    required String jobId,
  }) async {
    final res = await post('/recommendations/job-score/', {
      "freelancer": freelancerId,
      "job": jobId,
    });
    return ApiResponse.fromJson(res.data, JobScore.fromJson);
  }
}
