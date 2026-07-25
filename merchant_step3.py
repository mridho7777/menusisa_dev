import re

file_path = r'lib\super_admin\modules\merchant_management\widgets\merchant_content_widgets.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# UBAH DATA GRAFIK DARI 11 POINTS (0-10) MENJADI 7 POINTS (1-7)
old_spots = r'''static const _spots = <FlSpot>\[
    FlSpot\(0, 8\),
    FlSpot\(1, 20\),
    FlSpot\(2, 15\),
    FlSpot\(3, 25\),
    FlSpot\(4, 16\),
    FlSpot\(5, 21\),
    FlSpot\(6, 26\),
    FlSpot\(7, 24\),
    FlSpot\(8, 38\),
    FlSpot\(9, 35\),
    FlSpot\(10, 45\),
  \];'''

new_spots = r'''static const _spots = <FlSpot>[
    FlSpot(1, 12),
    FlSpot(2, 24),
    FlSpot(3, 18),
    FlSpot(4, 30),
    FlSpot(5, 22),
    FlSpot(6, 28),
    FlSpot(7, 35),
  ];'''

content = re.sub(old_spots, new_spots, content, flags=re.DOTALL)

# UBAH MINX DARI 0 KE 1
content = re.sub(r'minX: 0,', r'minX: 1,', content)

# UBAH MAXX DARI 10 KE 7
content = re.sub(r'maxX: 10,', r'maxX: 7,', content)

# UPDATE LABEL HARI (1-7)
# Cari dan ubah getTitlesWidget di bottomTitles
old_labels = r'''final labels = <int, String>\{
                      0: '0',
                      1: '1',
                      2: '2',
                      3: '3',
                      4: '4',
                      5: '5',
                      6: '6',
                      7: '7',
                      8: '8',
                      9: '9',
                      10: '10',
                    \};'''

new_labels = r'''final labels = <int, String>{
                      1: '1',
                      2: '2',
                      3: '3',
                      4: '4',
                      5: '5',
                      6: '6',
                      7: '7',
                    };'''

content = re.sub(old_labels, new_labels, content, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Step 3 complete: Grafik diubah menjadi 1-7 hari!')
