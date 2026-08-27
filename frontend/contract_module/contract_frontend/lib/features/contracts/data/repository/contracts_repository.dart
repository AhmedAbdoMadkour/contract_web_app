import '../model/contract_model.dart';
import '../model/contract_template_model.dart';
import 'package:sasheco_dashboard_web/core/shared/network/network_service.dart';

class ContractsRepository {
  final NetworkService _networkService;

  ContractsRepository(this._networkService);

  Future<List<ContractModel>> getContracts() async {
    final response = await _networkService.get('/api/contracts');
    final data = response.data as List;
    return data.map((e) => ContractModel.fromJson(e)).toList();
  }

  Future<void> updateContractStatus(String id, String newStatus) async {
    await _networkService.put('/api/contracts/$id/status', data: {'status': newStatus});
  }

  Future<List<ContractTemplateModel>> getTemplates() async {
    final response = await _networkService.get('/api/templates');
    final data = response.data as List;
    return data.map((e) => ContractTemplateModel.fromJson(e)).toList();
  }

  Future<ContractTemplateModel> createTemplate(ContractTemplateModel template) async {
    final response = await _networkService.post('/api/templates', data: template.toJson());
    return ContractTemplateModel.fromJson(response.data);
  }

  Future<void> createContract(String projectId, String vendorId, String termsAndConditions) async {
    await _networkService.post(
      '/api/contracts', 
      data: {
        'projectId': projectId,
        'vendorId': vendorId,
        'termsAndConditions': termsAndConditions,
      }
    );
  }
}
