import '/index.dart';

class IpSetup extends StatefulWidget {
  const IpSetup({super.key});

  @override
  State<IpSetup> createState() => _IpSetupState();
}

class _IpSetupState extends State<IpSetup> with SingleTickerProviderStateMixin {

  final TextEditingController ip = TextEditingController();
  final DeliveryService service = DeliveryService();

  final GlobalKey<FormState> key = GlobalKey();

  String creatingIP = 'http://your-value:7249/api/api';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.settings_remote,
                  size: 80,
                  color: Colors.orange,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Setup IP Address",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: ip,
                    maxLines: 1,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false
                    ),
                    validator: (val){
                      if(val == null || val == "" || val.isEmpty){
                        return "IP is required";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val){
                      setState(() {
                        creatingIP = "http://$val:7249/api/api";
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.wifi, color: Colors.orange),
                      hintText: "Setup IP (Without Port)",
                      hintStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade700),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange.shade400, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[900],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    creatingIP,
                    style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Setup", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: (){
                    if(key.currentState!.validate()){
                      service.setupIP(context, ip.text);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
