import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/delivery.dart';
import 'services/delivery_service.dart';

void main() => runApp(const CourierApp());

class CourierApp extends StatelessWidget {
  const CourierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Courier App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const DeliveryScreen(),
    );
  }
}

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});
  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final DeliveryService api = DeliveryService();
  List<Delivery> deliveries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeliveries();
  }

  Future<void> fetchDeliveries() async {
    try {
      final data = await api.getDeliveries();
      setState(() {
        deliveries = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching deliveries: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deliveries"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : deliveries.isEmpty
          ? const Center(child: Text("No deliveries"))
          : ListView.builder(
        itemCount: deliveries.length,
        itemBuilder: (context, index) {
          final d = deliveries[index];
          return ListTile(
            title: Text(d.recipient),
            subtitle: Text(d.address),
            trailing: Text(d.status,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Example: add a new delivery
          final newDelivery = Delivery(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            recipient: "Test User",
            address: "123 Test St",
            status: "Pending",
          );
          await api.createDelivery(newDelivery);
          fetchDeliveries();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
