import '/index.dart';
import 'package:http/http.dart' as http;

class DeliveryService {

  Future<String> getIP()async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    var ipAddress = sp.getString("ip");
    return ipAddress.toString();
  }

  Future<void> setupIP(BuildContext context,String value)async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("ip", 'http://$value:7249/api/api');
    if(context.mounted){
      showToast(context, "IP Configure: $value", Colors.orange);
      Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryScreen(),));
    }
  }

  Future<List<Delivery>> getDeliveries() async {

    final ip = await getIP();

    final res = await http.get(Uri.parse(ip));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Delivery.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch deliveries');
  }

  Future<void> createDelivery(Delivery delivery) async {

    final ip = await getIP();

    final res = await http.post(
      Uri.parse(ip),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(delivery.toJson()),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create delivery');
    }
  }

  Future<void> updateDelivery(BuildContext context, String id, Delivery delivery) async {
    final ip = await getIP();
    final res = await http.put(
      Uri.parse('$ip/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(delivery.toJson()),
    );
    if (res.statusCode == 200) {
      if(context.mounted){
        showToast(context, "Status Updated", Colors.orange); // Show Status
        Navigator.pop(context); // Close the bottom sheet
      }
    } else{
      throw Exception('Failed to update delivery');
    }
  }

  Future<void> deleteDelivery(BuildContext context, String id) async {
    final ip = await getIP();
    final res = await http.delete(Uri.parse('$ip/$id'));
    if (res.statusCode == 200) {
      if(context.mounted){
        showToast(context, "Record Deleted", Colors.red);
      }
    } else{
      throw Exception('Failed to delete delivery');
    }
  }

  // Toast
  void showToast(BuildContext context,String message, Color color){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        width: double.infinity,
        elevation: 0,
        content: Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      padding: const EdgeInsets.only(top: 20,left: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2),spreadRadius: 1, blurRadius: 10)
        ]
      ),
      child: Text(message, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),),
    )));
  }
}
