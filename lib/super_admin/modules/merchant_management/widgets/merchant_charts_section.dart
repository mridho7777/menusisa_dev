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
    return Column(
      children: [
        _buildChartCard(
          title: 'Grafik Pendaftaran Merchant',
          child: MerchantRegistrationChart(progress: chartProgress),
          showFilter: true,
        ),
        const SizedBox(height: 16),
        _buildChartCard(
          title: 'Distribusi Status Merchant',
          child: const MerchantDistributionDonut(progress: 1),
          showFilter: false,
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildChartCard(
            title: 'Grafik Pendaftaran Merchant',
            child: MerchantRegistrationChart(progress: chartProgress),
            showFilter: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: _buildChartCard(
            title: 'Distribusi Status Merchant',
            child: const MerchantDistributionDonut(progress: 1),
            showFilter: false,
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required Widget child,
    required bool showFilter,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              if (showFilter)
                _FilterDropdown(
                  value: chartFilter,
                  onChanged: onFilterChanged,
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          items: const [
            '30 Hari Terakhir',
            '7 Hari Terakhir',
            '1 Hari Terakhir',
          ]
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }
}
