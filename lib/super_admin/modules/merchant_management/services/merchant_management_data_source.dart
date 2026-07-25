abstract class MerchantManagementDataSource {
  Future<void> syncMerchants();
  Future<void> saveAction(String action, String merchantId);
}

class MerchantManagementRemoteContract implements MerchantManagementDataSource {
  const MerchantManagementRemoteContract();

  @override
  Future<void> saveAction(String action, String merchantId) async {}

  @override
  Future<void> syncMerchants() async {}
}
