import 'package:tugela/models.dart';
import 'package:tugela/providers/base_provider.dart';

abstract class CompanyProviderContract extends BaseProvider {
  Map<String?, Paginated<Company>> get companies;

  Future<Paginated<Company>?> getCompanies({
    required String mapId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  });

  Future<ApiResponse<Company>?> createCompany(Company data);

  Future<ApiResponse<Company>?> getCompany(String id);

  Future<ApiResponse<Company>?> updateCompany(String id, Company data);

  Future<ApiResponse<bool>?> deleteCompany(String id);
}
