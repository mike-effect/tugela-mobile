import 'package:tugela/models.dart';
import 'package:tugela/providers/contracts/company_provider.contract.dart';
import 'package:tugela/utils.dart';

class CompanyProvider extends CompanyProviderContract {
  final Map<String?, Paginated<Company>> _companiesMap = {};
  final Map<String?, Company> _companyMap = {};
  Paginated<Industry> industries = Paginated();
  Paginated<CompanyValue> companyValues = Paginated();

  @override
  Map<String?, Paginated<Company>> get companies => _companiesMap;

  Map<String?, Company> get company => _companyMap;

  @override
  void initialize() {
    if (user?.id != null) getCompanies(mapId: user!.id!);
  }

  @override
  void reset() {
    _companiesMap.clear();
    _companyMap.clear();
    industries.clear();
    companyValues.clear();
  }

  @override
  Future<ApiResponse<bool>?> createCompany(Company data) async {
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
        initialRequest: () => apiService.getCompanies(params: map),
        loadMoreRequest: () => apiService.getCompanies(
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
      final res = await apiService.getCompany(id);
      if (res.data != null) {
        _companyMap[id] = res.data!;
        notifyListeners();
      }
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> updateCompany(
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

  Future<Paginated<Industry>?> getCompanyIndustries({
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {
        'page_size': 100,
        ...params,
      };
      final res = await paginatedQuery<Industry>(
        options: options,
        paginated: industries,
        initialRequest: () => apiService.getCompanyIndustries(params: map),
        loadMoreRequest: () => apiService.getCompanyIndustries(
          params: map
            ..addAll({
              'page': industries.pagination?.next,
            }),
        ),
      );
      if (res?.data != null) industries = res!;
      notifyListeners();
      return industries;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<Paginated<CompanyValue>?> getCompanyValues({
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {
        'page_size': 100,
        ...params,
      };
      final res = await paginatedQuery<CompanyValue>(
        options: options,
        paginated: companyValues,
        initialRequest: () => apiService.getCompanyValues(params: map),
        loadMoreRequest: () => apiService.getCompanyValues(
          params: map
            ..addAll({
              'page': industries.pagination?.next,
            }),
        ),
      );
      if (res?.data != null) companyValues = res!;
      notifyListeners();
      return companyValues;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }
}
