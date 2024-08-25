import 'package:dio/dio.dart' as dio;
import 'package:tugela/models.dart';

enum SessionState { none, unauthenticated, unauthorized, hardLogout }

abstract class ApiServiceContract {
  Stream<SessionState> get stream;

  Sink<SessionState> get sink;

  User? get user;

  User? setUser(User? user);

  void closeStream();

  String get appVersion;

  String setAppVersion(String version);

  Future<dio.Response> get(String url, {bool auth = true});

  Future<dio.Response> post(
    String url,
    Map<String, dynamic> payload, {
    bool auth = true,
  });

  Future<dio.Response> put(
    String url,
    Map<String, dynamic> payload, {
    bool auth = true,
  });

  Future<dio.Response> delete(String url);

  Future<dio.Response> patch(String url, Map<String, dynamic> payload);

  Future<dio.Response> multipartPost(
    String url, {
    Map<String, String> fields = const {},
    List<dio.MultipartFile> files = const [],
  });

  Future<dio.Response> multipartPatch(
    String url, {
    Map<String, String> fields = const {},
    List<dio.MultipartFile> files = const [],
  });

  Future<ApiResponse<TokenObtainPairResponse>> login(
    TokenObtainPairRequest data,
  );

  Future<ApiResponse<TokenRefreshResponse>> refreshToken(String refresh);

  Future<ApiResponse<SignUpResponse>> signUp(SignUpRequest data);

  Future<ApiResponse<User>> getUserMe();

  Future<ApiResponse<List<Company>>> getCompanies({
    Map<String, dynamic> params = const {},
  });

  Future<ApiResponse<List<Industry>>> getCompanyIndustries({
    Map<String, dynamic> params = const {},
  });

  Future<ApiResponse<List<CompanyValue>>> getCompanyValues({
    Map<String, dynamic> params = const {},
  });

  Future<ApiResponse<bool>> createCompany(Company data);

  Future<ApiResponse<Company>> getCompany(String id);

  Future<ApiResponse<bool>> updateCompany(String id, Company data);

  Future<ApiResponse<bool>> deleteCompany(String id);

  Future<ApiResponse<bool>> createFreelancer(Freelancer data);

  Future<ApiResponse<Freelancer>> getFreelancer(String id);

  Future<ApiResponse<bool>> updateFreelancer(
    String id,
    Freelancer data,
  );

  Future<ApiResponse<List<Freelancer>>> getFreelancers({
    Map<String, dynamic> params = const {},
  });

  Future<ApiResponse<bool>> createJobApplication(JobApplication data);

  Future<ApiResponse<JobApplication>> getJobApplication(
    String jobApplicationId,
  );

  Future<ApiResponse<bool>> updateJobApplication(
    String jobApplicationId,
    JobApplication data,
  );

  Future<ApiResponse<bool>> deleteJobApplication(String jobApplicationId);

  Future<ApiResponse<List<JobApplication>>> getJobApplications({
    String? jobId,
    String? freelancerId,
    Map<String, dynamic> params = const {},
  });

  // Portfolio Item Management
  Future<ApiResponse<bool>> createPortfolioItem(PortfolioItem data);

  Future<ApiResponse<PortfolioItem>> getPortfolioItem(String portfolioItemId);

  Future<ApiResponse<bool>> updatePortfolioItem(
    String portfolioItemId,
    PortfolioItem data,
  );
  Future<ApiResponse<bool>> deletePortfolioItem(String portfolioItemId);

  Future<ApiResponse<List<PortfolioItem>>> getPortfolioItems({
    required String freelancerId,
    Map<String, dynamic> params = const {},
  });

  // Service Management
  Future<ApiResponse<bool>> createService(FreelancerService data);

  Future<ApiResponse<FreelancerService>> getService(String serviceId);

  Future<ApiResponse<bool>> updateService(
      String serviceId, FreelancerService data);

  Future<ApiResponse<bool>> deleteService(String serviceId);

  Future<ApiResponse<List<FreelancerService>>> getServices({
    required String freelancerId,
    Map<String, dynamic> params = const {},
  });

  // Work Experience Management
  Future<ApiResponse<bool>> createWorkExperience(WorkExperience data);

  Future<ApiResponse<WorkExperience>> getWorkExperience(String experienceId);

  Future<ApiResponse<bool>> updateWorkExperience(
    String experienceId,
    WorkExperience data,
  );

  Future<ApiResponse<bool>> deleteWorkExperience(String experienceId);

  Future<ApiResponse<List<WorkExperience>>> getWorkExperiences({
    required String freelancerId,
    Map<String, dynamic> params = const {},
  });

  // Job Management
  Future<ApiResponse<bool>> createJob(Job data);

  Future<ApiResponse<Job>> getJob(String jobId);

  Future<ApiResponse<bool>> updateJob(String jobId, Job data);

  Future<ApiResponse<bool>> deleteJob(String jobId);

  Future<ApiResponse<List<Job>>> getJobs({
    Map<String, dynamic> params = const {},
  });
}
