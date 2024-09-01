import 'package:tugela/models/api_response.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/models/freelancer_service.dart';
import 'package:tugela/models/paginated.dart';
import 'package:tugela/models/portfolio_item.dart';
import 'package:tugela/models/work_experience.dart';
import 'package:tugela/providers/contracts/freelancer_provider.contract.dart';
import 'package:tugela/utils.dart';

class FreelancerProvider extends FreelancerProviderContract {
  Freelancer? _profile;

  Map<String, Paginated<Freelancer>> freelancers = {};
  Map<String, Paginated<PortfolioItem>> portfolioItems = {};
  Map<String, Paginated<FreelancerService>> services = {};
  Map<String, Paginated<WorkExperience>> workExperiences = {};

  @override
  Freelancer? get profile => _profile;

  @override
  void reset() {
    _profile = null;
    portfolioItems.clear();
    workExperiences.clear();
    services.clear();
    freelancers.clear();
  }

  @override
  Future<ApiResponse<bool>?> createFreelancer(Freelancer data) async {
    try {
      final res = await apiService.createFreelancer(data);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<Freelancer>?> getFreelancer(String id) async {
    try {
      return await apiService.getFreelancer(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<bool>?> updateFreelancer(
    String id,
    Freelancer data,
  ) async {
    try {
      return await apiService.updateFreelancer(id, data);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<Paginated<Freelancer>?> getFreelancers({
    required String mapId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {'page_size': 100, ...params};
      final res = await paginatedQuery<Freelancer>(
        options: options,
        paginated: freelancers[mapId],
        initialRequest: () => apiService.getFreelancers(params: map),
        loadMoreRequest: () => apiService.getFreelancers(
          params: map..addAll({'page': freelancers[mapId]?.pagination?.next}),
        ),
      );
      if (res?.data != null) freelancers[mapId] = res!;
      notifyListeners();
      return freelancers[mapId];
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  // ------------------- Portfolio Item Methods -------------------

  Future<ApiResponse<bool>?> createFreelancerPortfolioItem(
    PortfolioItem data,
    //    {
    //   PlatformFile? portfolioFile,
    // }
  ) async {
    try {
      final res = await apiService.createPortfolioItem(
        data,
        // portfolioFile: portfolioFile,
      );
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<ApiResponse<PortfolioItem>?> getFreelancerPortfolioItem(
      String id) async {
    try {
      return await apiService.getPortfolioItem(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<ApiResponse<bool>?> updateFreelancerPortfolioItem(
    String id,
    PortfolioItem data,
    //   {
    //   PlatformFile? portfolioFile,
    // }
  ) async {
    try {
      return await apiService.updatePortfolioItem(
        id,
        data,
        // portfolioFile: portfolioFile,
      );
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<void> deleteFreelancerPortfolioItem(String id) async {
    try {
      await apiService.deletePortfolioItem(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
    }
  }

  Future<Paginated<PortfolioItem>?> getPortfolioItems({
    required String freelancerId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {'page_size': 100, ...params};
      final res = await paginatedQuery<PortfolioItem>(
        options: options,
        paginated: portfolioItems[freelancerId],
        initialRequest: () => apiService.getPortfolioItems(
            freelancerId: freelancerId, params: map),
        loadMoreRequest: () => apiService.getPortfolioItems(
          freelancerId: freelancerId,
          params: map
            ..addAll({
              'page': portfolioItems[freelancerId]?.pagination?.next,
            }),
        ),
      );
      if (res?.data != null) portfolioItems[freelancerId] = res!;
      notifyListeners();
      return portfolioItems[freelancerId];
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  // ------------------- Service Methods -------------------

  Future<ApiResponse<bool>?> createFreelancerService(
    FreelancerService data,
    //   {
    //   PlatformFile? serviceImage,
    // }
  ) async {
    try {
      final res = await apiService.createService(
        data,
        // serviceImage: serviceImage,
      );
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<ApiResponse<FreelancerService>?> getFreelancerService(
      String id) async {
    try {
      return await apiService.getService(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<ApiResponse<bool>?> updateFreelancerService(
    String id,
    FreelancerService data,
    //   {
    //   PlatformFile? serviceImage,
    // }
  ) async {
    try {
      return await apiService.updateService(
        id,
        data,
        // serviceImage: serviceImage,
      );
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<void> deleteFreelancerService(String id) async {
    try {
      await apiService.deleteService(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
    }
  }

  Future<Paginated<FreelancerService>?> getServices({
    required String mapId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {'page_size': 100, ...params};
      final res = await paginatedQuery<FreelancerService>(
        options: options,
        paginated: services[mapId],
        initialRequest: () =>
            apiService.getServices(freelancerId: mapId, params: map),
        loadMoreRequest: () => apiService.getServices(
          freelancerId: mapId,
          params: map..addAll({'page': services[mapId]?.pagination?.next}),
        ),
      );
      if (res?.data != null) services[mapId] = res!;
      notifyListeners();
      return services[mapId];
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  // ------------------- Work Experience Methods -------------------

  Future<ApiResponse<bool>?> createFreelancerWorkExperience(
      WorkExperience data) async {
    try {
      final res = await apiService.createWorkExperience(data);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<ApiResponse<WorkExperience>?> getFreelancerWorkExperience(
      String id) async {
    try {
      return await apiService.getWorkExperience(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<ApiResponse<bool>?> updateFreelancerWorkExperience(
      String id, WorkExperience data) async {
    try {
      return await apiService.updateWorkExperience(id, data);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  Future<void> deleteFreelancerWorkExperience(String id) async {
    try {
      await apiService.deleteWorkExperience(id);
    } catch (e, s) {
      handleError(e, stackTrace: s);
    }
  }

  Future<Paginated<WorkExperience>?> getWorkExperiences({
    required String freelancerId,
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {'page_size': 100, ...params};
      final res = await paginatedQuery<WorkExperience>(
        options: options,
        paginated: workExperiences[freelancerId],
        initialRequest: () => apiService.getWorkExperiences(
            freelancerId: freelancerId, params: map),
        loadMoreRequest: () => apiService.getWorkExperiences(
          freelancerId: freelancerId,
          params: map
            ..addAll({
              'page': workExperiences[freelancerId]?.pagination?.next,
            }),
        ),
      );
      if (res?.data != null) workExperiences[freelancerId] = res!;
      notifyListeners();
      return workExperiences[freelancerId];
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }
}
