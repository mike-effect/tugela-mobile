import 'package:flutter/foundation.dart';
import 'package:tugela/constants/config.dart';
import 'package:tugela/models/api_response.dart';
import 'package:tugela/models/paginated.dart';
import 'package:tugela/models/user.dart';
import 'package:tugela/services/contracts/api_service.contract.dart';
import 'package:tugela/services/contracts/hive_service.contract.dart';
import 'package:tugela/services/contracts/local_auth.contract.dart';
import 'package:tugela/services/sl.dart';

abstract class BaseProvider extends ChangeNotifier {
  String get userUuid => config.userUuid;

  int defaultPageSize = 50;

  /// Call this method for initialize the state of the provider.
  void initialize() {}

  /// Method for resetting the state of the provider
  void reset();

  final config = sl.get<AppConfig>();
  final apiService = sl.get<ApiServiceContract>();
  final hiveService = sl.get<HiveServiceContract>();
  final localAuthService = sl.get<LocalAuthServiceContract>();

  User? get user => apiService.user;

  Future<Paginated<T>?> paginatedQuery<T>({
    PaginatedOptions options = const PaginatedOptions(),
    required Paginated<T>? paginated,
    required Future<ApiResponse<List<T>>> Function() initialRequest,
    required Future<ApiResponse<List<T>>> Function() loadMoreRequest,
  }) async {
    if (options.loadMore) {
      options = PaginatedOptions(
        keepCount: options.keepCount,
        loadMore: true,
        refresh: false,
      );
    }
    Paginated<T>? pagination = paginated;
    if (pagination == null || pagination.data == null || options.refresh) {
      final res = await initialRequest();
      pagination = Paginated<T>(
        data: res.data ?? [],
        pagination: res.pagination,
      );
    } else if (options.loadMore && pagination.canLoadMore) {
      final res = await loadMoreRequest();
      pagination.append(res);
    }
    return pagination;
  }
}
