import re

file_path = r'lib\super_admin\modules\merchant_management\views\merchant_management_page.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# UBAH STRUKTUR 2 GRAFIK
# Pattern untuk kondisi stacked (sidebar ada)
old_stacked = r'''if \(stacked\) \{
                          return Column\(
                            children: \[
                              _PanelCard\(
                                title: 'Grafik Pendaftaran Merchant',
                                trailing: _FilterChip\(value: _chartFilter, onChanged: \(value\) => setState\(\(\) => _chartFilter = value\)\),
                                height: 320,
                                child: MerchantRegistrationChart\(progress: chartController\.value\),
                              \),
                              const SizedBox\(height: 14\),
                              Row\(
                                children: \[
                                  Expanded\(child: _PanelCard\(title: 'Distribusi Status Merchant', height: 320, child: MerchantDistributionDonut\(progress: chartController\.value\)\)\),'''

new_stacked = r'''if (stacked) {
                          return Column(
                            children: [
                              // GRID BESAR UNTUK 2 GRAFIK (VERTICAL SAAT SIDEBAR ADA)
                              _PanelCard(
                                title: 'Grafik Analisis Merchant',
                                height: null,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 320,
                                      child: _PanelCard(
                                        title: 'Grafik Pendaftaran Merchant',
                                        trailing: _FilterChip(value: _chartFilter, onChanged: (value) => setState(() => _chartFilter = value)),
                                        child: MerchantRegistrationChart(progress: chartController.value),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    SizedBox(
                                      height: 320,
                                      child: _PanelCard(
                                        title: 'Distribusi Status Merchant',
                                        child: MerchantDistributionDonut(progress: chartController.value),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(child: _PanelCard(title: 'Merchant Terlaris', actionLabel: 'Lihat Semua', height: 320, child: MerchantTopList(items: merchantTopMerchants))),'''

content = re.sub(old_stacked, new_stacked, content, flags=re.DOTALL)

# Pattern untuk kondisi tidak stacked (sidebar collapse)
old_horizontal = r'''return Column\(
                          children: \[
                            Row\(
                              children: \[
                                Expanded\(flex: 6, child: _PanelCard\(title: 'Grafik Pendaftaran Merchant', trailing: _FilterChip\(value: _chartFilter, onChanged: \(value\) => setState\(\(\) => _chartFilter = value\)\), height: 320, child: MerchantRegistrationChart\(progress: chartController\.value\)\)\),
                                const SizedBox\(width: 14\),
                                Expanded\(flex: 3, child: _PanelCard\(title: 'Distribusi Status Merchant', height: 320, child: MerchantDistributionDonut\(progress: chartController\.value\)\)\),'''

new_horizontal = r'''return Column(
                          children: [
                            // GRID BESAR UNTUK 2 GRAFIK (HORIZONTAL SAAT SIDEBAR COLLAPSE)
                            _PanelCard(
                              title: 'Grafik Analisis Merchant',
                              height: 340,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text('Grafik Pendaftaran Merchant', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                            const Spacer(),
                                            _FilterChip(value: _chartFilter, onChanged: (value) => setState(() => _chartFilter = value)),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Expanded(child: MerchantRegistrationChart(progress: chartController.value)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Distribusi Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 12),
                                        Expanded(child: MerchantDistributionDonut(progress: chartController.value)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(child: _PanelCard(title: 'Merchant Terlaris', actionLabel: 'Lihat Semua', height: 320, child: MerchantTopList(items: merchantTopMerchants))),'''

content = re.sub(old_horizontal, new_horizontal, content, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Step 2 complete: 2 grafik dibungkus dalam 1 grid besar!')
