import 'package:carwashbooking/Core/services/location_service.dart';
import 'package:carwashbooking/Core/utils/formatters.dart';
import 'package:carwashbooking/Screens/AddressScreen/Model/addressmodel.dart';
import 'package:carwashbooking/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../model/user_model.dart';
import '../presenter/profile_presenter.dart';
import '../repository/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Login/view/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> implements ProfileView {
  late ProfilePresenter presenter;
  UserModel? _userData;
  bool _isLoading = true;
  bool _isGettingLocation = false;

  final Color backgroundColor = Color(0x071826);
  //const Color(0xFF0D1B2A);

  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    print('🎯 ProfileScreen initialized for user: ${widget.user.uid}');
    print('📧 Auth user email: ${widget.user.email}');
    print('👤 Auth user display name: ${widget.user.displayName}');

    presenter = ProfilePresenter(
      repository: ProfileRepository(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      ),
    );
    presenter.attachView(this);

    // Ensure document exists first, then load user data
    presenter
        .ensureUserDocumentExists(widget.user)
        .then((_) {
          print('✅ Document ensured, now loading user data');
          return presenter.loadUser(widget.user.uid);
        })
        .catchError((error) {
          print('❌ Error in initialization: $error');
          showError('Initialization failed: $error');
        });
  }

  @override
  void dispose() {
    presenter.detachView();
    super.dispose();
  }

  @override
  void showLoading() => setState(() => _isLoading = true);

  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void showUser(UserModel user) {
    print('👤 User data received: $user');
    setState(() {
      _userData = user;
      _isLoading = false;
    });
  }

  @override
  void showError(String message) {
    print('❌ Error: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: aquaSwatch),
    );
  }

  @override
  void onAddressUpdated(String address) {
    print('📍 Address updated to: $address');
    setState(() {
      _userData = _userData?.copyWith(address: address);
    });
  }

  @override
  void onLogout() async {
    print('🚪 Logging out...');
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _getCurrentLocationAndUpdate() async {
    setState(() => _isGettingLocation = true);
    try {
      final serviceEnabled = await _locationService.isLocationEnabled();
      if (!serviceEnabled) {
        showError('Location services are disabled. Please enable them.');
        return;
      }

      var permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _locationService.requestPermission();
        if (permission == LocationPermission.denied) {
          showError('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showError(
          'Location permissions are permanently denied. Please enable them in app settings.',
        );
        return;
      }

      final pos = await _locationService.getCurrentPosition();
      final address = await _locationService.getAddressFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (address != null) {
        await presenter.updateAddress(widget.user.uid, address);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        showError('Failed to get address from coordinates');
      }
    } catch (e) {
      showError('Failed to get location: $e');
    } finally {
      setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _showAddressEditDialog() async {
    final controller = TextEditingController(text: _userData?.address ?? '');
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getCurrentLocationAndUpdate,
                child: const Text('Use Current Location'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final txt = controller.text.trim();
                if (txt.isNotEmpty) {
                  await presenter.updateAddress(widget.user.uid, txt);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Address updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left circular icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0x003B2D05), // dark circle background
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title + Subtitle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Manage your account',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF00C8FF), // aquaSwatch main color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: const Color(
                      0xFF0D1B2A,
                    ), // dark background like in screenshot
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: aquaSwatch,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // match container radius
                              child: Image.network(
                                'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202408/shah-rukh-khan-115148818-16x9_0.jpg?VersionId=MccYGNrEjoJ3aqFcljPAtCdtRcJWRDjQ&size=690:388',
                                fit: BoxFit.cover, // makes it fill nicely
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.black,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),

                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                Text(
                                  _userData?.fullName ??
                                      widget.user.displayName ??
                                      'User Name',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  "Member since ${formatDateFromTimestamp(_userData!.updatedAt)}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  _userData?.email ??
                                      widget.user.email ??
                                      'Email',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Verified badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        size: 16,
                                        color: Colors.teal,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFF0D1B2A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // match container radius
                              child: const Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 16.0,
                                        bottom: 8,
                                      ),
                                      child: Icon(
                                        Icons.calendar_month,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Bookings",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFF0D1B2A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // match container radius
                              child: GestureDetector(
                                onTap: (){
                                     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddressListScreen(user: widget.user),
      ),
    );
                                },
                                child: const Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 16.0,
                                          bottom: 8,
                                        ),
                                        child: Icon(
                                          Icons.gps_fixed,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "Locations",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  //Spacer(),
               
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => presenter.logout(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
      ],
    );
  }
}





class AddressListScreen extends StatelessWidget {
  final User user;

  const AddressListScreen({super.key, required this.user});

  Stream<List<AddressModel>> _streamAddresses() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("addresses")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AddressModel.fromMap(doc.data())).toList());
  }

  Future<void> _addAddress(BuildContext context) async {
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final postalController = TextEditingController();
    final phoneController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Address"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: "City"),
              ),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(labelText: "State"),
              ),
              TextField(
                controller: postalController,
                decoration: const InputDecoration(labelText: "Postal Code"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (addressController.text.isEmpty ||
                  cityController.text.isEmpty ||
                  stateController.text.isEmpty ||
                  postalController.text.isEmpty ||
                  phoneController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All fields are required")),
                );
                return;
              }

              final newAddress = AddressModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                address: addressController.text,
                city: cityController.text,
                state: stateController.text,
                postalCode: postalController.text,
                phone: phoneController.text,
              );

              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .collection("addresses")
                  .doc(newAddress.id)
                  .set(newAddress.toMap());

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Address added successfully!")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Addresses"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<List<AddressModel>>(
        stream: _streamAddresses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final addresses = snapshot.data ?? [];

          if (addresses.isEmpty) {
            return const Center(child: Text("No addresses found."));
          }

          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final addr = addresses[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading:
                      const Icon(Icons.location_on, color: Colors.deepPurple),
                  title: Text(addr.address),
                  subtitle: Text(
                    "${addr.city}, ${addr.state}, ${addr.postalCode}\nPhone: ${addr.phone}",
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addAddress(context),
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text("Add Address"),
      ),
    );
  }
}






/*
class AddressListScreen extends StatelessWidget {
  final User user;

  const AddressListScreen({super.key, required this.user});

  Future<List<AddressModel>> _fetchAddresses() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("addresses")
        .get();

    return snapshot.docs
        .map((doc) => AddressModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> _addAddress(BuildContext context) async {
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final postalController = TextEditingController();
    final phoneController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Address"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: "City"),
              ),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(labelText: "State"),
              ),
              TextField(
                controller: postalController,
                decoration: const InputDecoration(labelText: "Postal Code"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (addressController.text.isEmpty ||
                  cityController.text.isEmpty ||
                  stateController.text.isEmpty ||
                  postalController.text.isEmpty ||
                  phoneController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All fields are required")),
                );
                return;
              }

              final newAddress = AddressModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                address: addressController.text,
                city: cityController.text,
                state: stateController.text,
                postalCode: postalController.text,
                phone: phoneController.text,
              );

              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .collection("addresses")
                  .doc(newAddress.id)
                  .set(newAddress.toMap());

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Address added successfully!")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Addresses"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<AddressModel>>(
        future: _fetchAddresses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final addresses = snapshot.data ?? [];

          if (addresses.isEmpty) {
            return const Center(child: Text("No addresses found."));
          }

          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final addr = addresses[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.deepPurple),
                  title: Text(addr.address),
                  subtitle: Text(
                    "${addr.city}, ${addr.state}, ${addr.postalCode}\nPhone: ${addr.phone}",
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addAddress(context),
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text("Add Address"),
      ),
    );
  }
}
*/