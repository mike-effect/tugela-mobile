import 'package:tugela/models.dart';
import 'package:tugela/providers/contracts/company_provider.contract.dart';
import 'package:tugela/utils.dart';

class CompanyProvider extends CompanyProviderContract {
  final Map<String?, Paginated<Company>> _companiesMap = {};

  @override
  Map<String?, Paginated<Company>> get companies => _companiesMap;

  @override
  void initialize() {
    if (user?.id != null) getCompanies(mapId: user!.id!);
  }

  @override
  void reset() {
    _companiesMap.clear();
  }

  @override
  Future<ApiResponse<Company>?> createCompany(Company data) async {
    try {
      final res = await apiService.createCompany(data);
      if (user?.id != null) await getCompanies(mapId: user!.id!);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> deleteCompany(String id) async {
    try {
      final res = await apiService.deleteCompany(id);
      if (user?.id != null) getCompanies(mapId: user!.id!);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<Paginated<Company>?> getCompanies({
    required String mapId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {
        'page_size': defaultPageSize,
        ...params,
      };
      final res = await paginatedQuery<Company>(
        options: options,
        paginated: _companiesMap[mapId],
        initialRequest: apiService.getCompanies(params: map),
        loadMoreRequest: apiService.getCompanies(
          params: map
            ..addAll({
              'page': _companiesMap[mapId]?.pagination?.next,
            }),
        ),
      );
      if (res?.data != null) _companiesMap[mapId] = res!;
      notifyListeners();
      return _companiesMap[mapId];
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<Company>?> getCompany(String id) async {
    try {
      return await apiService.getCompany(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<Company>?> updateCompany(
    String id,
    Company data,
  ) async {
    try {
      final res = await apiService.updateCompany(id, data);
      if (user?.id != null) getCompanies(mapId: user!.id!);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }
}
