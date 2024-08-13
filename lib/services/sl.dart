import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tugela/constants/config.dart';
import 'package:tugela/services/api_service.dart';
import 'package:tugela/services/contracts/api_service.contract.dart';
import 'package:tugela/services/contracts/hive_service.contract.dart';
import 'package:tugela/services/contracts/local_auth.contract.dart';
import 'package:tugela/services/hive_service.dart';
import 'package:tugela/services/local_auth_service.dart';

final sl = GetIt.instance;

final _localAuth = LocalAuthentication();

setupServiceLocator() {
  sl.allowReassignment = true;
  sl.registerLazySingleton<HiveServiceContract>(() => HiveService());
  sl.registerLazySingleton<ApiServiceContract>(() {
    return ApiService(Dio(BaseOptions(baseUrl: AppConfig.apiHost)));
  });
  sl.registerLazySingleton<LocalAuthServiceContract>(
      () => LocalAuthService(_localAuth));
}
