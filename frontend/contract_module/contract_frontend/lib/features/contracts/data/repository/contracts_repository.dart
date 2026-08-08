import '../model/contract_model.dart';
import 'package:sasheco_dashboard_web/core/shared/network/network_service.dart';

class ContractsRepository {
  final NetworkService _networkService;

  ContractsRepository(this._networkService);

  Future<List<ContractModel>> getContracts() async {
    try {
      final response = await _networkService.get('/api/contracts');
      final data = response.data as List;
      return data.map((e) => ContractModel.fromJson(e)).toList();
    } catch (e) {
      // Mock data in case API is unavailable
      return [
        ContractModel(id: '1', title: 'Office Building A', clientName: 'Tech Corp', status: 'Draft', amount: 500000),
        ContractModel(id: '2', title: 'Mall Renovation', clientName: 'Retail Inc', status: 'Active', amount: 1200000),
        ContractModel(id: '3', title: 'Road Expansion', clientName: 'City Council', status: 'Completed', amount: 3500000),
        ContractModel(id: '4', title: 'Villa Complex', clientName: 'Private Investor', status: 'Terminated', amount: 800000),
        ContractModel(id: '5', title: 'Hospital Wing', clientName: 'Health Ministry', status: 'Active', amount: 4500000),
      ];
    }
  }

  Future<void> updateContractStatus(String id, String newStatus) async {
    try {
      await _networkService.put('/api/contracts/$id/status', data: {'status': newStatus});
    } catch (e) {
      // Silently ignore mock API error
    }
  }
}
