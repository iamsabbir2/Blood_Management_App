import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/data_state.dart';
import '../models/user_model.dart';
import '../providers/current_user_provider.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({super.key});

  @override
  ConsumerState<InfoScreen> createState() {
    return _InfoScreenState();
  }
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  late DataState<UserModel> _currentUser;
  @override
  Widget build(BuildContext context) {
    _currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: ListTile(
                  onTap: () {},
                  title: const Text('Donor'),
                  subtitle: Text(
                    _currentUser.data!.isDonor ? 'Yes' : 'No',
                  ),
                  leading: const Icon(Icons.bloodtype_sharp),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (_currentUser.data != null && _currentUser.data!.isDonor)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  // color: Colors.red[100],
                  borderOnForeground: false,
                  child: ListTile(
                    onTap: () {},
                    title: const Text('Total Donations'),
                    subtitle: Text(
                      _currentUser.data!.totalDonations.toString(),
                    ),
                    leading: const Icon(Icons.volunteer_activism),
                    shape: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            if (_currentUser.data != null && _currentUser.data!.isDonor)
              const SizedBox(
                height: 10,
              ),
            if (_currentUser.data != null && _currentUser.data!.isDonor)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  // color: Colors.red[100],
                  borderOnForeground: false,
                  child: ListTile(
                    onTap: () {},
                    title: const Text('Can you donate now?'),
                    subtitle: Text(
                      !_currentUser.data!.isGoingToDonate
                          ? 'Yes, available'
                          : 'No, not available',
                    ),
                    leading: const Icon(Icons.bloodtype),
                    shape: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            if (_currentUser.data != null && _currentUser.data!.isDonor)
              const SizedBox(
                height: 10,
              ),
            if (_currentUser.data != null && _currentUser.data!.isDonor)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  // color: Colors.red[100],
                  borderOnForeground: false,
                  child: ListTile(
                    onTap: () {},
                    title: const Text('Last Donation Date'),
                    subtitle: Text(
                      _currentUser.data!.lastDonationDate != null
                          ? _currentUser.data!.lastDonationDate!.toString()
                          : 'Not available',
                    ),
                    leading: const Icon(Icons.bloodtype),
                    shape: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            if (_currentUser.data != null && _currentUser.data!.isDonor)
              const SizedBox(
                height: 10,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: ListTile(
                  onTap: () {},
                  title: const Text('Total Requests'),
                  subtitle: Text(
                    _currentUser.data!.totalRequests.toString(),
                  ),
                  leading: const Icon(Icons.bloodtype_sharp),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
