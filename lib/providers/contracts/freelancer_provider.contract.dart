import 'package:tugela/models.dart';
import 'package:tugela/providers/base_provider.dart';

abstract class FreelancerProviderContract extends BaseProvider {
  Freelancer? get profile;

  Future<ApiResponse<Freelancer>?> createFreelancer(Freelancer data);

  Future<ApiResponse<Freelancer>?> getFreelancer(String id);

  Future<ApiResponse<Freelancer>?> updateFreelancer(
    String id,
    Freelancer data,
  );
}
