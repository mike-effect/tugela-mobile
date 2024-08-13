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
      // if (kDebugMode) handleError(e.response?.data);
      if (e.response?.data == null) rethrow;
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
    return await _makeRequest('GET', url, queryParams: params, auth: auth);
  }

  @override
  Future<dio.Response> delete(
    String url, {
    Map<String, dynamic>? params,
  }) async {
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
    Map<String, String> fields = const {},
    List<dio.MultipartFile> files = const [],
  }) async {
    final formData = dio.FormData.fromMap({
      ...fields,
      'files': files,
    });
    return await _makeRequest('PATCH', url, formData: formData);
  }

  @override
  Future<dio.Response> multipartPost(
    String url, {
    Map<String, String> fields = const {},
    List<dio.MultipartFile> files = const [],
  }) async {
    final formData = dio.FormData.fromMap({
      ...fields,
      'files': files,
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
      params: params..removeWhere((k, v) => v == null),
    );
    return ApiResponse.fromJsonList(
      res.data,
      (json) => (json).map((e) => Company.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<Company>> createCompany(Company data) async {
    final res = await post('/companies/', data.toJson());
    return ApiResponse.fromJson(res.data, Company.fromJson);
  }

  @override
  Future<ApiResponse<Company>> getCompany(String id) async {
    final res = await get('/companies/$id/');
    return ApiResponse.fromJson(res.data, Company.fromJson);
  }

  @override
  Future<ApiResponse<Company>> updateCompany(String id, Company data) async {
    final res = await patch('/companies/$id/', data.toJson());
    return ApiResponse.fromJson(res.data, Company.fromJson);
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
  // @override
  // Future<ApiResponse<List<Freelancer>>> getFreelancers({
  //   String? user,
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/freelancers/',
  //     params: {
  //       'user': user,
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => Freelancer.fromJson(e)).toList(),
  //   );
  // }

  @override
  Future<ApiResponse<Freelancer>> createFreelancer(Freelancer data) async {
    final res = await post('/freelancers/', data.toJson());
    return ApiResponse.fromJson(res.data, Freelancer.fromJson);
  }

  @override
  Future<ApiResponse<Freelancer>> getFreelancer(String id) async {
    final res = await get('/freelancers/$id/');
    return ApiResponse.fromJson(res.data, Freelancer.fromJson);
  }

  @override
  Future<ApiResponse<Freelancer>> updateFreelancer(
    String id,
    Freelancer data,
  ) async {
    final res = await patch('/freelancers/$id/', data.toJson());
    return ApiResponse.fromJson(res.data, Freelancer.fromJson);
  }

  // @override
  // Future<ApiResponse<void>> deleteFreelancer(String id) async {
  //   return delete(
  //     '/freelancers/$id/',
  //     creator: (_) {},
  //   );
  // }

  // // ------------------- Freelancers Portfolio Items endpoints -------------------
  // @override
  // Future<ApiResponse<List<PortfolioItem>>> getFreelancersPortfolioItems({
  //   String? user,
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/freelancers/portfolio-items/',
  //     params: {
  //       'user': user,
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => PortfolioItem.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<PortfolioItem>> createFreelancerPortfolioItem(
  //     PortfolioItem data) async {
  //   return post(
  //     '/freelancers/portfolio-items/',
  //     data.toJson(),
  //     creator: PortfolioItem.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<PortfolioItem>> getFreelancerPortfolioItem(
  //     String id) async {
  //   return get(
  //     '/freelancers/portfolio-items/$id/',
  //     creator: (json) => PortfolioItem.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<PortfolioItem>> updateFreelancerPortfolioItem(
  //     String id, PortfolioItem data) async {
  //   return patch(
  //     '/freelancers/portfolio-items/$id/',
  //     data.toJson(),
  //     creator: PortfolioItem.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteFreelancerPortfolioItem(String id) async {
  //   return delete(
  //     '/freelancers/portfolio-items/$id/',
  //     creator: (_) {},
  //   );
  // }

  // // ------------------- Freelancers Services endpoints -------------------
  // @override
  // Future<ApiResponse<List<Service>>> getFreelancersServices({
  //   String? user,
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/freelancers/services/',
  //     params: {
  //       'user': user,
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => Service.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<Service>> createFreelancerService(Service data) async {
  //   return post(
  //     '/freelancers/services/',
  //     data.toJson(),
  //     creator: Service.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Service>> getFreelancerService(String id) async {
  //   return get(
  //     '/freelancers/services/$id/',
  //     creator: (json) => Service.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<Service>> updateFreelancerService(
  //     String id, Service data) async {
  //   return patch(
  //     '/freelancers/services/$id/',
  //     data.toJson(),
  //     creator: Service.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteFreelancerService(String id) async {
  //   return delete(
  //     '/freelancers/services/$id/',
  //     creator: (_) {},
  //   );
  // }

  // // ------------------- Freelancers Work Experiences endpoints -------------------
  // @override
  // Future<ApiResponse<List<WorkExperience>>> getFreelancersWorkExperiences({
  //   String? user,
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/freelancers/work-experiences/',
  //     params: {
  //       'user': user,
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => WorkExperience.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<WorkExperience>> createFreelancerWorkExperience(
  //     WorkExperience data) async {
  //   return post(
  //     '/freelancers/work-experiences/',
  //     data.toJson(),
  //     creator: WorkExperience.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<WorkExperience>> getFreelancerWorkExperience(
  //     String id) async {
  //   return get(
  //     '/freelancers/work-experiences/$id/',
  //     creator: (json) => WorkExperience.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<WorkExperience>> updateFreelancerWorkExperience(
  //     String id, WorkExperience data) async {
  //   return patch(
  //     '/freelancers/work-experiences/$id/',
  //     data.toJson(),
  //     creator: WorkExperience.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteFreelancerWorkExperience(String id) async {
  //   return delete(
  //     '/freelancers/work-experiences/$id/',
  //     creator: (_) {},
  //   );
  // }

  // // ------------------- Jobs endpoints -------------------
  // @override
  // Future<ApiResponse<List<Job>>> getJobs({
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/jobs/',
  //     params: {
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => Job.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<Job>> createJob(Job data) async {
  //   return post(
  //     '/jobs/',
  //     data.toJson(),
  //     creator: Job.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Job>> getJob(String id) async {
  //   return get(
  //     '/jobs/$id/',
  //     creator: (json) => Job.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<Job>> updateJob(String id, Job data) async {
  //   return put(
  //     '/jobs/$id/',
  //     data.toJson(),
  //     creator: Job.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Job>> partialUpdateJob(String id, Job data) async {
  //   return patch(
  //     '/jobs/$id/',
  //     data.toJson(),
  //     creator: Job.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteJob(String id) async {
  //   return delete(
  //     '/jobs/$id/',
  //     creator: (_) {},
  //   );
  // }

  // // ------------------- Jobs Applications endpoints -------------------
  // @override
  // Future<ApiResponse<List<Application>>> getJobsApplications({
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/jobs/applications/',
  //     params: {
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => Application.fromJson(e)).toList(),
  //   );
  // }

  // @override
  // Future<ApiResponse<Application>> createJobApplication(
  //     Application data) async {
  //   return post(
  //     '/jobs/applications/',
  //     data.toJson(),
  //     creator: Application.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Application>> getJobApplication(String id) async {
  //   return get(
  //     '/jobs/applications/$id/',
  //     creator: (json) => Application.fromJson(json),
  //   );
  // }

  // @override
  // Future<ApiResponse<Application>> updateJobApplication(
  //     String id, Application data) async {
  //   return put(
  //     '/jobs/applications/$id/',
  //     data.toJson(),
  //     creator: Application.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<Application>> partialUpdateJobApplication(
  //     String id, Application data) async {
  //   return patch(
  //     '/jobs/applications/$id/',
  //     data.toJson(),
  //     creator: Application.fromJson,
  //   );
  // }

  // @override
  // Future<ApiResponse<void>> deleteJobApplication(String id) async {
  //   return delete(
  //     '/jobs/applications/$id/',
  //     creator: (_) {},
  //   );
  // }

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
  // @override
  // Future<ApiResponse<List<Skill>>> getSkills({
  //   String? search,
  //   String? ordering,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   return get<List(
  //     '/skill/',
  //     params: {
  //       'search': search,
  //       'ordering': ordering,
  //       'page': page?.toString(),
  //       'page_size': pageSize?.toString(),
  //     },
  //     creator: (json) => (json).map((e) => Skill.fromJson(e)).toList(),
  //   );
  // }

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
}
