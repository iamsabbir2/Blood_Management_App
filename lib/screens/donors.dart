import 'package:blood_management_app/services/auth_service_firebase.dart';
import 'package:blood_management_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

//widgets
import '../widgets/custom_dropdown_button.dart';

//providers
import '../providers/user_provider.dart';

//models
import '../models/data_state.dart';
import '../models/user_model.dart';

class DonorsList extends ConsumerStatefulWidget {
  const DonorsList({super.key});

  @override
  ConsumerState<DonorsList> createState() => _DonorsListState();
}

class _DonorsListState extends ConsumerState<DonorsList> {
  String selectedBloodGroup = 'All';
  String? _selectedDistrict;
  // ignore: prefer_final_fields
  DatabaseService _databaseService = DatabaseService();
  // ignore: prefer_final_fields
  AuthService _authService = AuthService();
  List<String> districts = [
    'All',
    'Tangail',
    'Gazipur',
    'Dhaka',
    'Mymensingh',
    'Narayanganj',
    'Narsingdi',
  ];
  late DataState<List<UserModel>> userState;
  final List<String> bloodGroupFilters = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  String getChat(String otherUserUid) {
    return _databaseService.getChatId(
        _authService.currentUser!.uid, otherUserUid);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _showFilterOption() {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          MediaQuery.sizeOf(context).width - 100,
          kToolbarHeight,
          0,
          0,
        ),
        items: bloodGroupFilters.map((e) {
          return PopupMenuItem(
            value: e,
            child: Text(e),
            onTap: () {
              setState(() {
                selectedBloodGroup = e;
              });
            },
          );
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    userState = ref.watch(userProvider);
    final donors = userState.data?.where((user) {
          return user.isDonor == true &&
              user.uid != _authService.currentUser!.uid;
        }).toList() ??
        [];
    donors.sort((a, b) => a.bloodGroup.compareTo(b.bloodGroup));
    final filteredDonors = selectedBloodGroup == 'All'
        ? donors
        : donors
            .where((donor) => donor.bloodGroup == selectedBloodGroup)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donors'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          // CustomDropdownButton(
          //   items: districts,
          //   value: _selectedDistrict ?? 'A+',
          //   title: _selectedDistrict ?? 'Sort by District',
          //   onChanged: (value) {
          //     setState(() {
          //       _selectedDistrict = value;
          //     });
          //   },
          // ),
          IconButton(
            onPressed: _showFilterOption,
            icon: const Icon(
              Icons.filter_list,
            ),
          ),
        ],
      ),
      body: userState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : userState.errorMessage != null
              ? Center(
                  child: Text('Error: ${userState.errorMessage}'),
                )
              : filteredDonors.isEmpty
                  ? Center(
                      child: Text(
                          'No donors found of $selectedBloodGroup blood group!'),
                    )
                  : ListView.builder(
                      itemCount: filteredDonors.length,
                      itemBuilder: (context, index) {
                        final donor = filteredDonors[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              onTap: () {},
                              leading: Text(
                                donor.bloodGroup,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              minLeadingWidth: 30,
                              title: Text(donor.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const Row(
                                  //   children: [
                                  //     Icon(
                                  //       Icons.location_on,
                                  //       size: 16,
                                  //     ),
                                  //     SizedBox(width: 4),
                                  //     Text('Tangail'),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      if (donor.isContactHidden)
                                        const Text('Hidden')
                                      else
                                        const Text('Available'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.volunteer_activism_outlined,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      if (donor.isGoingToDonate)
                                        const Text(
                                          'Can\'t dontate now!',
                                        )
                                      else
                                        const Text(
                                          'Ready to donate',
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          '/chat',
                                          arguments: donor,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.chat,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  if (!donor.isContactHidden)
                                    const SizedBox(height: 8),
                                  if (!donor.isContactHidden)
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          _makePhoneCall(donor.contact);
                                        },
                                        icon: const Icon(
                                          Icons.phone,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
