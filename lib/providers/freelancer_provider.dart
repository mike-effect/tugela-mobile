import 'package:tugela/models/api_response.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/providers/contracts/freelancer_provider.contract.dart';
import 'package:tugela/utils.dart';

class FreelancerProvider extends FreelancerProviderContract {
  Freelancer? _profile;

  @override
  Freelancer? get profile => _profile;

  @override
  void reset() {
    _profile = null;
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
}
