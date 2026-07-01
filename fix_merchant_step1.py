import re

file_path = r'lib\super_admin\modules\merchant_management\views\merchant_management_page.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. PERBESAR ICON DAN TEKS 6 KOTAK
# Perbesar icon dari size: 32 menjadi 40
content = re.sub(
    r'child: Icon\(icon, color: Colors\.white, size: 32\)',
    r'child: Icon(icon, color: Colors.white, size: 40)',
    content
)

# Perbesar container icon dari 60 menjadi 68
content = re.sub(
    r'width: 60,\n\s+height: 60,',
    r'width: 68,\n            height: 68,',
    content
)

# 2. PERBAIKI CHILDASPECTRATIO UNTUK OVERLAY MULUS
# Ubah childAspectRatio untuk menghindari overflow
content = re.sub(
    r'childAspectRatio: sidebarCollapsed \? 4\.2 : 4\.0,',
    r'childAspectRatio: sidebarCollapsed ? 3.8 : 4.2,',
    content
)

# Ubah crossAxisSpacing dan mainAxisSpacing
content = re.sub(
    r'crossAxisSpacing: 12,\n\s+mainAxisSpacing: 12,',
    r'crossAxisSpacing: 14,\n                        mainAxisSpacing: 14,',
    content
)

# 3. PERBAIKI ANIMASI DURATION
# Kurangi duration animation dari 900ms ke 600ms
content = re.sub(
    r'duration: const Duration\(milliseconds: 900\)',
    r'duration: const Duration(milliseconds: 600)',
    content
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Step 1: Icon, teks, dan animasi overlay diperbaiki!')
