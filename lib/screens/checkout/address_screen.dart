import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/app_theme.dart';

/// Lets the customer pick a saved address or add a new one.
/// Wire up to GET/POST /api/auth/me addresses sub-array (add a dedicated
/// /api/users/addresses endpoint on the backend if you want direct CRUD
/// instead of round-tripping through the full user profile).
class AddressScreen extends StatefulWidget {
  final List<Address> savedAddresses;
  const AddressScreen({super.key, this.savedAddresses = const []});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _pincode = TextEditingController();
  bool _showForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Address')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.savedAddresses.isNotEmpty && !_showForm) ...[
              Expanded(
                child: ListView.separated(
                  itemCount: widget.savedAddresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final a = widget.savedAddresses[i];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                        title: Text(a.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${a.line1}, ${a.city}, ${a.state} ${a.pincode}'),
                        onTap: () => Navigator.of(context).pop(a),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => setState(() => _showForm = true),
                icon: const Icon(Icons.add),
                label: const Text('Add new address'),
              ),
            ] else
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(controller: _line1, decoration: const InputDecoration(labelText: 'Address line 1'), validator: (v) => v!.isEmpty ? 'Required' : null),
                      const SizedBox(height: 12),
                      TextFormField(controller: _line2, decoration: const InputDecoration(labelText: 'Address line 2 (optional)')),
                      const SizedBox(height: 12),
                      TextFormField(controller: _city, decoration: const InputDecoration(labelText: 'City'), validator: (v) => v!.isEmpty ? 'Required' : null),
                      const SizedBox(height: 12),
                      TextFormField(controller: _state, decoration: const InputDecoration(labelText: 'State'), validator: (v) => v!.isEmpty ? 'Required' : null),
                      const SizedBox(height: 12),
                      TextFormField(controller: _pincode, decoration: const InputDecoration(labelText: 'Pincode'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          final address = Address(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            label: 'Home',
                            line1: _line1.text,
                            line2: _line2.text,
                            city: _city.text,
                            state: _state.text,
                            pincode: _pincode.text,
                          );
                          // TODO: POST this address to the backend before returning it
                          Navigator.of(context).pop(address);
                        },
                        child: const Text('Save & Use This Address'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
