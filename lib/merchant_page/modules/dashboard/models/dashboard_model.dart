class DashboardMetric {
  final String id;
  final String title;
  final String value;
  final String subtitle;
  final double amount;

  DashboardMetric({required this.id, required this.title, required this.value, required this.subtitle, required this.amount});
}

class DashboardOrder {
  final String id;
  final String customer;
  final String status;
  final double total;

  DashboardOrder({required this.id, required this.customer, required this.status, required this.total});
}

class DashboardProduct {
  final String id;
  final String name;
  final int sold;
  final double price;

  DashboardProduct({required this.id, required this.name, required this.sold, required this.price});
}

class DashboardModel {
  final String title;
  final String subtitle;
  final List<DashboardMetric> metrics;
  final List<double> salesTrend;
  final List<String> days;
  final List<DashboardOrder> orders;
  final List<DashboardProduct> products;

  DashboardModel({required this.title, required this.subtitle, required this.metrics, required this.salesTrend, required this.days, required this.orders, required this.products});
}
