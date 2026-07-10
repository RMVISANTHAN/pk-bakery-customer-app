import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../services/api_service.dart';
import '../../utils/api_constants.dart';
import '../../utils/app_theme.dart';
import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<BakeryOrder> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await ApiService.instance.get(ApiConstants.myOrders);
      setState(() {
        _orders = (response.data['data'] as List).map((o) => BakeryOrder.fromJson(o)).toList();
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), automaticallyImplyLeading: false),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('No orders yet'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final order = _orders[i];
                      return Card(
                        child: ListTile(
                          title: Text('Order #${order.orderNumber}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${order.items.length} item(s) · ₹${order.total.toStringAsFixed(0)}'),
                          trailing: Text(
                            order.status.name,
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderId: order.id))),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
