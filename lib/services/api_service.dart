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
        // if (kDebugMode) handleError(e.response?.data);
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

  // ------------------- Auth endpoints -------------------
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

  // @override
  // Future<ApiResponse<ChangePasswordResponse>> changePassword(
  //     ChangePasswordRequest data) async {
  //   return post(
  //     '/auth/change-password/',
  //     data.toJson(),
  //     creator: ChangePasswordResponse.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<ForgotPasswordResponse>> forgotPassword(
  //     ForgotPasswordRequest data) async {
  //   return post(
  //     '/auth/forget-password/',
  //     data.toJson(),
  //     creator: ForgotPasswordResponse.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<ResetPasswordResponse>> resetPassword(
  //     ResetPasswordRequest data) async {
  //   return post(
  //     '/auth/reset-password/',
  //     data.toJson(),
  //     creator: ResetPasswordResponse.fromJson,
  //   );
  // }

  // // ------------------- Address endpoints -------------------
  // @override
  // Future<ApiResponse<List<Address>>> getAddresses({
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/address/',
  //     params: {
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => Address.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<Address>> createAddress(Address data) async {
  //   return post(
  //     '/address/',
  //     data.toJson(),
  //     creator: Address.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Address>> getAddress(String id) async {
  //   return get(
  //     '/address/$id/',
  //     creator: (json) => Address.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<Address>> updateAddress(String id, Address data) async {
  //   return patch(
  //     '/address/$id/',
  //     data.toJson(),
  //     creator: Address.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteAddress(String id) async {
  //   return delete(
  //     '/address/$id/',
  //     creator: (_) {},
  //   );
  // }

  // // ------------------- Category endpoints -------------------
  // @override
  // Future<ApiResponse<List<Category>>> getCategories({
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/category/',
  //     params: {
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => Category.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<Category>> createCategory(Category data) async {
  //   return post(
  //     '/category/',
  //     data.toJson(),
  //     creator: Category.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Category>> getCategory(String id) async {
  //   return get(
  //     '/category/$id/',
  //     creator: (json) => Category.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<Category>> updateCategory(String id, Category data) async {
  //   return patch(
  //     '/category/$id/',
  //     data.toJson(),
  //     creator: Category.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteCategory(String id) async {
  //   return delete(
  //     '/category/$id/',
  //     creator: (_) {},
  //   );
  // }

  // ------------------- Companies endpoints -------------------
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

  // // ------------------- Companies Managers endpoints -------------------
  // @override
  // Future<ApiResponse<List<CompanyManager>>> getCompanyManagers({
  //   String? user,
  //   String? company,
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/companies/managers/',
  //     params: {
  //       'user': user,
  //       'company': company,
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => CompanyManager.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<CompanyManager>> createCompanyManager(
  //     CompanyManager data) async {
  //   return post(
  //     '/companies/managers/',
  //     data.toJson(),
  //     creator: CompanyManager.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<CompanyManager>> getCompanyManager(String id) async {
  //   return get(
  //     '/companies/managers/$id/',
  //     creator: (json) => CompanyManager.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteCompanyManager(String id) async {
  //   return delete(
  //     '/companies/managers/$id/',
  //     creator: (_) {},
  //   );
  // }

  // ------------------- Freelancers endpoints -------------------
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

  // @override
  // Future<ApiResponse<void>> deleteFreelancer(String id) async {
  //   return delete(
  //     '/freelancers/$id/',
  //     creator: (_) {},
  //   );
  // }

  // ------------------- Freelancers Portfolio Items endpoints -------------------
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

  // ------------------- Freelancers Services endpoints -------------------
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

  // ------------------- Freelancers Work Experiences endpoints -------------------
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

  // ------------------- Jobs endpoints -------------------
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

  // ------------------- Jobs Applications endpoints -------------------
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

  // @override
  // Future<ApiResponse<JobApplication>> partialUpdateJobApplication(
  //     String id, JobApplication data) async {
  //   final res = await patch('/jobs/applications/$id/', data.toJson());
  //   return ApiResponse.fromJson(res.data, JobApplication.fromJson);
  // }

  @override
  Future<ApiResponse<bool>> deleteJobApplication(String id) async {
    final res = await delete('/jobs/applications/$id/');
    return ApiResponse.successful(res);
  }

  // ------------------- Job Submissions endpoints -------------------
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

  // // ------------------- Jobs Tags endpoints -------------------

  // @override
  // Future<ApiResponse<List<Tag>>> getJobsTags({
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/jobs/tags/',
  //     params: {
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => Tag.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<Tag>> createJobTag(Tag data) async {
  //   return post(
  //     '/jobs/tags/',
  //     data.toJson(),
  //     creator: Tag.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Tag>> getJobTag(String id) async {
  //   return get(
  //     '/jobs/tags/$id/',
  //     creator: (json) => Tag.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<Tag>> updateJobTag(String id, Tag data) async {
  //   return patch(
  //     '/jobs/tags/$id/',
  //     data.toJson(),
  //     creator: Tag.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteJobTag(String id) async {
  //   return delete(
  //     '/jobs/tags/$id/',
  //     creator: (_) {},
  //   );
  // }

  // // ------------------- Profile endpoints -------------------
  // @override
  // Future<ApiResponse<List<Profile>>> getProfiles({
  //   String? user,
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/profile/',
  //     params: {
  //       'user': user,
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => Profile.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<Profile>> createProfile(
  //   String user,
  //   String firstName,
  //   String lastName,
  //   String gender, {
  //   String? dob,
  //   String? phoneNumber,
  //   File? profileImage,
  // }) async {
  //   return multipartPost(
  //     '/profile/',
  //     fields: {
  //       'user': user,
  //       'first_name': firstName,
  //       'last_name': lastName,
  //       'gender': gender,
  //       'dob': dob ?? '',
  //       'phone_number': phoneNumber ?? '',
  //     },
  //     files: [
  //       if (profileImage != null)
  //         await MultipartFile.fromFile(profileImage.path,
  //             filename: profileImage.path.split('/').last),
  //     ],
  //     creator: Profile.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Profile>> getProfile(String id) async {
  //   return get(
  //     '/profile/$id/',
  //     creator: (json) => Profile.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<Profile>> updateProfile(
  //   String id,
  //   String user,
  //   String firstName,
  //   String lastName,
  //   String gender, {
  //   String? dob,
  //   String? phoneNumber,
  //   File? profileImage,
  // }) async {
  //   return multipartPatch(
  //     '/profile/$id/',
  //     files: [
  //       if (profileImage != null)
  //         await MultipartFile.fromFile(profileImage.path,
  //             filename: profileImage.path.split('/').last),
  //     ],
  //     fields: {
  //       'user': user,
  //       'first_name': firstName,
  //       'last_name': lastName,
  //       'gender': gender,
  //       'dob': dob ?? '',
  //       'phone_number': phoneNumber ?? '',
  //     },
  //     creator: Profile.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteProfile(String id) async {
  //   return delete(
  //     '/profile/$id/',
  //     creator: (_) {},
  //   );
  // }

  // // ------------------- Skill endpoints -------------------
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

  // @override
  // Future<ApiResponse<Skill>> createSkill(Skill data) async {
  //   return post(
  //     '/skill/',
  //     data.toJson(),
  //     creator: Skill.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Skill>> getSkill(String id) async {
  //   return get(
  //     '/skill/$id/',
  //     creator: (json) => Skill.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<Skill>> updateSkill(String id, Skill data) async {
  //   return patch(
  //     '/skill/$id/',
  //     data.toJson(),
  //     creator: Skill.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteSkill(String id) async {
  //   return delete(
  //     '/skill/$id/',
  //     creator: (_) {},
  //   );
  // }

  // // ------------------- Users endpoints -------------------
  // @override
  // Future<ApiResponse<List<User>>> getUsers({
  //   String? isActive,
  //   String? deleted,
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/users/',
  //     params: {
  //       'is_active': isActive,
  //       'deleted': deleted,
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => User.fromJson(e)).toList(),
  //   );
  // }

  @override
  Future<ApiResponse<User>> getUserMe() async {
    final res = await get('/users/me/');
    return ApiResponse.fromJson(res.data, User.fromJson);
  }

  // @override
  // Future<ApiResponse<User>> getUser(String id) async {
  //   return get(
  //     '/users/$id/',
  //     creator: User.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<User>> updateUser(String id, User data) async {
  //   return put(
  //     '/users/$id/',
  //     data.toJson(),
  //     creator: User.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<User>> partialUpdateUser(String id, User data) async {
  //   return patch(
  //     '/users/$id/',
  //     data.toJson(),
  //     creator: User.fromJson,
  //   );
  // }

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
}
