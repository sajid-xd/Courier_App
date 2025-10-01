import '/index.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      home: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        child: const IpSetup(),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.orange,
          contentTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      themeMode: ThemeMode.dark,
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
  int selectedIndex = 0;
  String searchQuery = '';

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
      if(deliveries.isEmpty){
        Timer(Duration(seconds: 10), (){
          fetchDeliveries();
        });
      }
    } catch (e) {
      debugPrint('Error fetching deliveries: $e');
      setState(() => isLoading = false);
    }
  }

  Widget _buildDeliveriesBody() {
    final filteredDeliveries = deliveries.where((d) =>
      d.receiverName!.toLowerCase().contains(searchQuery.toLowerCase()) ||
      d.toAddress!.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
        color: Colors.black87,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.local_shipping, color: Colors.orange, size: 28),
            SizedBox(width: 10),
            Text(
              "Your Deliveries",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search deliveries...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              filled: true,
              fillColor: Colors.grey[900],
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredDeliveries.isEmpty
              ? const Center(child: Text("No deliveries"))
              : ListView.builder(
            itemCount: filteredDeliveries.length,
            itemBuilder: (context, index) {
              final d = filteredDeliveries[index];
              return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_){
                              showModalBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (context){
                                return Container(
                                  width: double.infinity,
                                  height: 160,
                                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                     BoxShadow(color: Colors.black.withOpacity(0.2),
                                         blurRadius: 10,
                                       spreadRadius: 1
                                     )
                                    ]
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Update Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.orange),),
                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(child: OutlinedButton(onPressed: (){
                                            api.updateDelivery(context, d.id.toString(), Delivery(
                                                fromAddress: d.fromAddress,
                                                toAddress: d.toAddress,
                                                senderName: d.senderName,
                                                receiverName: d.receiverName,
                                                senderId: d.senderId,
                                                agentId: d.agentId,
                                                serviceId: d.serviceId,
                                                weightId: d.weightId,
                                                locationId: d.locationId,
                                                trackingId: d.trackingId,
                                                status: "Shipped",
                                                createdAt: d.createdAt
                                            )).then((_){fetchDeliveries();});
                                          }, child: Text("Shipped"))),
                                          Expanded(child: OutlinedButton(onPressed: (){
                                            api.updateDelivery(context, d.id.toString(), Delivery(
                                                fromAddress: d.fromAddress,
                                                toAddress: d.toAddress,
                                                senderName: d.senderName,
                                                receiverName: d.receiverName,
                                                senderId: d.senderId,
                                                agentId: d.agentId,
                                                serviceId: d.serviceId,
                                                weightId: d.weightId,
                                                locationId: d.locationId,
                                                trackingId: d.trackingId,
                                                status: "Cancelled",
                                                createdAt: d.createdAt
                                            )).then((_){fetchDeliveries();});
                                          }, child: Text("Cancelled"))),
                                          Expanded(child: OutlinedButton(onPressed: () {
                                            api.updateDelivery(context, d.id.toString(), Delivery(
                                                fromAddress: d.fromAddress,
                                                toAddress: d.toAddress,
                                                senderName: d.senderName,
                                                receiverName: d.receiverName,
                                                senderId: d.senderId,
                                                agentId: d.agentId,
                                                serviceId: d.serviceId,
                                                weightId: d.weightId,
                                                locationId: d.locationId,
                                                trackingId: d.trackingId,
                                                status: "Pending",
                                                createdAt: d.createdAt
                                            )).then((_){fetchDeliveries();});
                                          }, child: Text("Pending"))),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                            },
                            backgroundColor: Color(0xFFFA762F),
                            foregroundColor: Colors.white,
                            icon: Icons.edit_note_rounded,
                            label: 'Update',
                          ),
                          SlidableAction(
                            onPressed: (_){
                              api.deleteDelivery(context, d.id.toString()).then((_){fetchDeliveries();});
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.local_shipping, color: Colors.orange),
                        title: Text(d.receiverName!),
                        subtitle: Text(d.toAddress!),
                        trailing: Text(d.status!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: d.status == "Shipped" ? Colors.green : d.status == "Cancelled" ? Colors.red : Colors.orange)),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.inventory_2, color: Colors.white), // box icon
            SizedBox(width: 8),
            Text("Post Management"),
          ],
        ),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Color(0xFFFF8B00)],
            ),
          ),
        ),
      ),
      body: selectedIndex == 0 ? _buildDeliveriesBody() : const RiderProfileBody(),
      floatingActionButton: selectedIndex == 0 ? FloatingActionButton(onPressed: (){
        fetchDeliveries();
      }, child: Icon(Icons.refresh),) : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Color(0xFFFF8B00)],
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class RiderProfileBody extends StatelessWidget {
  const RiderProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFFFF8B00)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Rider Profile",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  "https://media.licdn.com/dms/image/v2/D5603AQGdxMEg8LTj-g/profile-displayphoto-scale_400_400/B56ZkuVYWzJ0Ag-/0/1757418981868?e=1762387200&v=beta&t=pu7uZOjgFvtd-XLyXkFqF6FBDIuWo_IGHVjRcaQhm7w",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.orange),
                      title: const Text("Name", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: const Text("Asad Qureshi", style: TextStyle(color: Colors.white70)),
                    ),
                    const Divider(color: Colors.white24),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.orange),
                      title: const Text("Phone", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: const Text("+92 3155904190", style: TextStyle(color: Colors.white70)),
                    ),
                    const Divider(color: Colors.white24),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.orange),
                      title: const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: const Text("asadqureshi@postmanagement.pk", style: TextStyle(color: Colors.white70)),
                    ),
                    const Divider(color: Colors.white24),
                    ListTile(
                      leading: const Icon(Icons.star, color: Colors.orange),
                      title: const Text("Rating", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: const Text("4.5 / 5.0", style: TextStyle(color: Colors.white70)),
                    ),
                    const Divider(color: Colors.white24),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.orange),
                      title: const Text("Location", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: const Text("Karachi, Pakistan", style: TextStyle(color: Colors.white70)),
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
