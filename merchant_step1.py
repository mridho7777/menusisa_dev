import re

file_path = r'lib\super_admin\modules\merchant_management\views\merchant_management_page.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. PERBESAR ICON dari 32 menjadi 40
content = re.sub(
    r'Icon\(icon, color: Colors\.white, size: 32\)',
    r'Icon(icon, color: Colors.white, size: 40)',
    content
)

# 2. PERBESAR CONTAINER ICON dari 60x60 menjadi 68x68
content = re.sub(
    r'width: 60,\n\s+height: 60,',
    r'width: 68,\n            height: 68,',
    content
)

# 3. PERBAIKI CHILDASPECTRATIO untuk layout yang lebih baik
content = re.sub(
    r'childAspectRatio: sidebarCollapsed \? 4\.2 : 4\.0,',
    r'childAspectRatio: sidebarCollapsed ? 3.6 : 4.0,',
    content
)

# 4. PERBAIKI SPACING untuk overlay mulus
content = re.sub(
    r'crossAxisSpacing: 12,\n\s+mainAxisSpacing: 12,',
    r'crossAxisSpacing: 14,\n                        mainAxisSpacing: 14,',
    content
)

# 5. PERBAIKI ANIMATION DURATION dari 900ms ke 600ms
content = re.sub(
    r'Duration\(milliseconds: 900\)',
    r'Duration(milliseconds: 600)',
    content
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Step 1 complete: Icon dan animasi diperbaiki!')
