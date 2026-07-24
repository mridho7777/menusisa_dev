import 'package:flutter/material.dart';
import 'merchant_content_widgets.dart';

class MerchantChartsSection extends StatelessWidget {
  const MerchantChartsSection({
    super.key,
    required this.chartFilter,
    required this.onFilterChanged,
    required this.chartProgress,
    required this.isStacked,
  });

  final String chartFilter;
  final ValueChanged<String> onFilterChanged;
  final double chartProgress;
  final bool isStacked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: isStacked ? _buildStackedLayout() : _buildHorizontalLayout(),
    );
  }

  Widget _buildStackedLayout() {
    final chartHeight = chartFilter == '30 Hari Terakhir' ? 176.0 : 170.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Grafik Pendaftaran & Status Merchant',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            _FilterDropdown(value: chartFilter, onChanged: onFilterChanged),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          height: chartHeight,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Grafik Pendaftaran Merchant',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: MerchantRegistrationChart(progress: chartProgress),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: chartHeight,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status Merchant',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Expanded(child: const MerchantDistributionDonut(progress: 1)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Grafik Pendaftaran & Status Merchant',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            _FilterDropdown(value: chartFilter, onChanged: onFilterChanged),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 176,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Grafik Pendaftaran Merchant',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: MerchantRegistrationChart(progress: chartProgress),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: Container(
                height: 176,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Merchant',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: const MerchantDistributionDonut(progress: 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w500,
          ),
          items:
              const ['30 Hari Terakhir', '7 Hari Terakhir', '1 Hari Terakhir']
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }
}
