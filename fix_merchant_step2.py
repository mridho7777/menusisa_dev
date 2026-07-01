import re

file_path = r'lib\super_admin\modules\merchant_management\views\merchant_management_page.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# UBAH STRUKTUR 2 GRAFIK - GABUNGKAN DALAM SATU GRID
# Cari pattern grafik pertama dan kedua, ubah agar dalam satu row/column terbungkus

# Pattern lama: 2 grafik terpisah dalam Row dengan Flex
old_pattern = r'''_PanelCard\(
                                title: 'Grafik Pendaftaran Merchant',
                                trailing: _FilterChip\(value: _chartFilter, onChanged: \(value\) => setState\(\(\) => _chartFilter = value\)\),
                                height: 320,
                                child: MerchantRegistrationChart\(progress: chartController\.value\),
                              \),
                              const SizedBox\(width: 14\),
                              Expanded\(flex: 3, child: _PanelCard\(title: 'Distribusi Status Merchant', height: 320, child: MerchantDistributionDonut\(progress: chartController\.value\)\)\),'''

# Ganti dengan container yang dibungkus grid
new_pattern = r'''_ChartGridCard(
                                title: 'Grafik Merchant',
                                trailing: _FilterChip(value: _chartFilter, onChanged: (value) => setState(() => _chartFilter = value)),
                                sidebarCollapsed: sidebarCollapsed,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _PanelCard(
                                        title: 'Grafik Pendaftaran Merchant',
                                        height: 320,
                                        child: MerchantRegistrationChart(progress: chartController.value),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      flex: 1,
                                      child: _PanelCard(title: 'Distribusi Status Merchant', height: 320, child: MerchantDistributionDonut(progress: chartController.value)),
                                    ),
                                  ],
                                ),
                              ),'''

content = re.sub(old_pattern, new_pattern, content, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Step 2: Struktur 2 grafik dibungkus dalam grid besar!')
