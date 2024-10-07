import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late String selectedBloodGroup;
  String? _selectedDistrict;

  String generateChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? userId1 + userId2
        : userId2 + userId1;
  }

  late DataState<List<UserModel>> userState;

  @override
  Widget build(BuildContext context) {
    selectedBloodGroup = 'All';
    userState = ref.watch(userProvider);
    final donors = userState.data?.where((user) {
          return user.isDonor == true;
        }).toList() ??
        [];
    final bloodGroupFilters = [
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

    List<String> districts = [
      'All',
      'Tangail',
      'Gazipur',
      'Dhaka',
      'Mymensingh',
      'Narayanganj',
      'Narsingdi',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donors'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          CustomDropdownButton(
            items: districts,
            value: _selectedDistrict ?? 'A+',
            title: _selectedDistrict ?? 'Sort by District',
            onChanged: (value) {
              setState(() {
                _selectedDistrict = value;
              });
            },
          ),
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
              : donors.isEmpty
                  ? const Center(
                      child: Text('No donors found'),
                    )
                  : ListView.builder(
                      itemCount: donors.length,
                      itemBuilder: (context, index) {
                        final donor = donors[index];
                        return ListTile(
                          title: Text(donor.name),
                        );
                      },
                    ),
    );
  }
}
