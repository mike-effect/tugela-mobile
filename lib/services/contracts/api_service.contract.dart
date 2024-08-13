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

  Future<ApiResponse<Company>> createCompany(Company data);

  Future<ApiResponse<Company>> getCompany(String id);

  Future<ApiResponse<Company>> updateCompany(String id, Company data);

  Future<ApiResponse<bool>> deleteCompany(String id);

  Future<ApiResponse<Freelancer>> createFreelancer(Freelancer data);

  Future<ApiResponse<Freelancer>> getFreelancer(String id);

  Future<ApiResponse<Freelancer>> updateFreelancer(
    String id,
    Freelancer data,
  );
}
