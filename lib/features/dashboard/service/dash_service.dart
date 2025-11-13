import 'package:cloud_firestore/cloud_firestore.dart';
// Assuming your DailySalesData class is defined in sale_model.dart
import 'package:techmart_admin/features/dashboard/model/sale_model.dart';

class DashService {
  // All Collection References should be static
  static CollectionReference userRef = FirebaseFirestore.instance.collection(
    "Users",
  );
  static CollectionReference sellerRef = FirebaseFirestore.instance.collection(
    "seller",
  );
  static CollectionReference orderRef = FirebaseFirestore.instance.collection(
    "Orders",
  );

  // Helper for Day Labels
  static const List<String> daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // ----------------------
  // STATIC COUNT METHODS
  // ----------------------

  static Stream<int> userCount() {
    return userRef.snapshots().map((snapshot) => snapshot.docs.length);
  }

  static Stream<int> activeSellerCount() {
    return sellerRef
        .where("is_verfied", isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Stream<int> unActiveSellerCount() {
    return sellerRef
        .where("is_verfied", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Stream<int> totalOrders() {
    return orderRef.snapshots().map((snapshot) => snapshot.docs.length);
  }

  // ----------------------
  // CHART DATA METHODS
  // ----------------------

  // NOTE: This method should be static to be consistent with the other methods.
  static Stream<List<DailySalesData>> fetchDailySalesData() {
    final DateTime now = DateTime.now();
    // Calculate start of the 7-day range (midnight 6 days ago)
    final DateTime sevenDaysAgoStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));
    final Timestamp startTime = Timestamp.fromDate(sevenDaysAgoStart);

    return orderRef
        .where('createTime', isGreaterThanOrEqualTo: startTime)
        .orderBy('createTime', descending: false)
        .snapshots()
        .map(
          (snapshot) => _processSnapshot(snapshot, sevenDaysAgoStart),
        ); // Pass the start date
  }

  // Data Aggregation and Processing
  static List<DailySalesData> _processSnapshot(
    QuerySnapshot snapshot,
    DateTime sevenDaysAgoStart,
  ) {
    // 1. Initialize the 7-day range (List of DateTimes)
    final List<DateTime> lastSevenDays = List.generate(7, (index) {
      // Correctly generate the last 7 dates starting from sevenDaysAgoStart
      return sevenDaysAgoStart.add(Duration(days: index));
    });

    // 2. Initialize map for daily totals, keyed by YYYY-MM-DD
    final Map<String, double> dailyTotals = {};
    for (var date in lastSevenDays) {
      final dateKey = date.toIso8601String().substring(0, 10);
      dailyTotals[dateKey] = 0.0;
    }

    // 3. Aggregate sales from the documents
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Safely extract Timestamp and total amount
      final Timestamp? ts = data['createTime'] as Timestamp?;
      final double totalAmount = (data['total'] as num?)?.toDouble() ?? 0.0;

      if (ts != null) {
        final DateTime orderDate = ts.toDate();
        // Use YYYY-MM-DD as the map key for aggregation
        final String dateKey = orderDate.toIso8601String().substring(0, 10);

        // Update the total for that date key
        dailyTotals.update(
          dateKey,
          (value) => value + totalAmount,
          ifAbsent: () => totalAmount,
        );
      }
    }

    // 4. Convert to final chart structure (DailySalesData)
    final List<DailySalesData> chartData = [];
    for (int i = 0; i < 7; i++) {
      final DateTime date = lastSevenDays[i];
      final String dateKey = date.toIso8601String().substring(0, 10);

      chartData.add(
        DailySalesData(
          daysOfWeek[date.weekday - 1], // Day label (Mon, Tue, etc.)
          dailyTotals[dateKey] ?? 0.0, // Use 0.0 if no sales for that day
        ),
      );
    }

    return chartData;
  }

  // Helper to map complex statuses to simplified chart statuses
  static String _getChartStatus(String status) {
    status = status.toLowerCase();

    // Group Shipped, OutForDelivery, and Delivered into one category
    if (status == 'shipped' ||
        status == 'outfordelivery' ||
        status == 'delivered') {
      return 'Delivered';
    }

    // Check for Processing
    if (status == 'processing') {
      return 'Processing';
    }

    // Check for Pending
    if (status == 'pending') {
      return 'Pending';
    }

    // Note: If your OrderModel doesn't have 'cancelled', you need to ensure orders
    // with that status are included if they exist in Firestore.
    if (status == 'cancelled') {
      return 'Cancelled';
    }

    return 'Other'; // Fallback for unhandled or unexpected statuses
  }

  // 🎯 Real-time stream of aggregated status counts
  static Stream<Map<String, int>> fetchOrderStatusCounts() {
    return orderRef.snapshots().map((snapshot) {
      final Map<String, int> statusCounts = {
        'Pending': 0,
        'Processing': 0,
        'Delivered': 0,
        'Cancelled': 0,
      };

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final String status = data['status'] ?? 'Other';
        final String chartStatus = _getChartStatus(status);

        if (statusCounts.containsKey(chartStatus)) {
          statusCounts[chartStatus] = (statusCounts[chartStatus] ?? 0) + 1;
        } else {
          // Handles 'Other' or unexpected statuses if needed
          statusCounts.update(
            chartStatus,
            (count) => count + 1,
            ifAbsent: () => 1,
          );
        }
      }
      return statusCounts;
    });
  }
}
