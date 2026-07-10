import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/order_model.dart';
import '../../services/api_service.dart';
import '../../utils/api_constants.dart';
import '../../utils/app_theme.dart';

/// Displays order status progress plus the delivery partner's live location
/// once the order is out_for_delivery. Live location updates are pushed via
/// Socket.IO (see backend/src/server.js `location-update` event) - connect
/// with the `socket_io_client` package and join room `order:<orderId>`.
class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  BakeryOrder? _order;
  GoogleMapController? _mapController;
  LatLng? _partnerLocation;

  static const _steps = [
    OrderStatus.placed,
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.baking,
    OrderStatus.outForDelivery,
    OrderStatus.delivered,
  ];

  static const _stepLabels = {
    OrderStatus.placed: 'Order Placed',
    OrderStatus.confirmed: 'Confirmed',
    OrderStatus.preparing: 'Preparing',
    OrderStatus.baking: 'Baking',
    OrderStatus.outForDelivery: 'Out for Delivery',
    OrderStatus.delivered: 'Delivered',
  };

  @override
  void initState() {
    super.initState();
    _load();
    // TODO: open a Socket.IO connection here, emit `join-order` with
    // widget.orderId, and listen for `location-update` to refresh _partnerLocation.
  }

  Future<void> _load() async {
    try {
      final response = await ApiService.instance.get('${ApiConstants.orders}/${widget.orderId}');
      setState(() => _order = BakeryOrder.fromJson(response.data['data']));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_order == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final currentIndex = _steps.indexOf(_order!.status);
    return Scaffold(
      appBar: AppBar(title: Text('Order #${_order!.orderNumber}')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            children: List.generate(_steps.length, (i) {
              final done = i <= currentIndex;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: done ? AppColors.primary : AppColors.border,
                        child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                      ),
                      if (i != _steps.length - 1)
                        Container(width: 2, height: 36, color: done ? AppColors.primary : AppColors.border),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      _stepLabels[_steps[i]]!,
                      style: TextStyle(fontWeight: done ? FontWeight.w600 : FontWeight.normal, color: done ? AppColors.textPrimary : AppColors.textSecondary),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          if (_order!.status == OrderStatus.outForDelivery) ...[
            const Text('Live Location', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 260,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _partnerLocation ?? const LatLng(28.6139, 77.2090), // fallback: New Delhi
                    zoom: 14,
                  ),
                  onMapCreated: (c) => _mapController = c,
                  markers: _partnerLocation == null
                      ? {}
                      : {Marker(markerId: const MarkerId('partner'), position: _partnerLocation!)},
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._order!.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.name} x${item.quantity}'),
                    Text('₹${(item.price * item.quantity).toStringAsFixed(0)}'),
                  ],
                ),
              )),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('₹${_order!.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
