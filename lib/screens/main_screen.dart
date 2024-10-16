import 'package:blood_management_app/models/message_model.dart';
import 'package:blood_management_app/models/patient_model.dart';
import 'package:blood_management_app/providers/chat_stream_provider.dart';
import 'package:blood_management_app/providers/patient_provider.dart';
import 'package:blood_management_app/services/database_service.dart';
import 'package:blood_management_app/widgets/edit_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//packages
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
//pages
import '../screens/request_lists.dart';
//models
import '../models/user_model.dart';
import '../models/data_state.dart';
//widgets
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_button.dart';
import '../background/main_screen_background.dart';
//services
import '../services/navigation_service.dart';
import '../services/auth_service.dart';
//providers
import '../providers/user_provider.dart';
import '../providers/current_user_provider.dart';

class BmaScreen extends ConsumerStatefulWidget {
  const BmaScreen({super.key});

  @override
  ConsumerState<BmaScreen> createState() {
    return _BmaScreenState();
  }
}

class _BmaScreenState extends ConsumerState<BmaScreen> {
  Future<void> _requestNotificationPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );
  }

  void _setupTokenRefreshListener() {
    Logger().i('Setting up token refresh checker');
    _checkToken();
    // Periodically check for token updates every 24 hours
    Future.delayed(Duration(hours: 24), _checkToken);
  }

  Future<void> _checkToken() async {
    try {
      String? token;
      kIsWeb
          ? token = await FirebaseMessaging.instance.getToken(
              vapidKey:
                  'BE7twew0v0Yt-fDD68pP40FgH2u6wReDBRG-RHFjdwUKNmx-IXxbN8N0S8Piqmm7GGrMmBjqinqVTCr32wXEANw')
          : token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        Logger().i('Token: $token');

        // Use the services as needed
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'fcmToken': token,
          });
          Logger().i('Token updated successfully');
        } else {
          Logger().e('No current user found');
        }
      }
    } catch (e) {
      Logger().e('Error in token refresh checker: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    _setupTokenRefreshListener();
  }

  final _pageController = PageController();
  late DataState<List<PatientModel>> requestState;
  late List<PatientModel> requests;
  late AuthService _authService;
  late DataState<UserModel> currentUserState;
  late bool _isGoingToDonate;
  late DatabaseService _databaseService;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _requestlists() {
    NavigationService().navigateToPage(const RequestLists());
  }

  void _donate(PatientModel request) async {
    setState(() {
      _isGoingToDonate = true;
    });
    try {
      ref
          .watch(userProvider.notifier)
          .updateIsGoingToDonate(currentUserState.data!.uid, true);
      ref
          .watch(patientProvider.notifier)
          .updateNeedBloodUnits(request.requestId, request.units - 1);

      if (request.units == 0) {
        ref
            .watch(patientProvider.notifier)
            .updateIsRequestCompleted(request.requestId, true);
      }
      final chatId = _databaseService.getChatId(
          _authService.currentUser!.uid, request.currentUserUid);
      final message = MessageModel(
        messageId: '',
        message: 'I am going to donate blood to your patient',
        senderUid: _authService.currentUser!.uid,
        receiverUid: request.currentUserUid,
        time: Timestamp.now().toDate().toIso8601String(),
      );
      ref.read(chatStreamProvider.notifier).addMessage(chatId, message);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(' Thanks for Donation confirming!'),
        ),
      );
    } catch (e) {
      Logger().i(e);
    }
    setState(() {
      _isGoingToDonate = false;
    });
  }

  void _editRequest(PatientModel request) {
    NavigationService().navigateToPage(EditRequest(
      patient: request,
    ));
  }

  @override
  Widget build(BuildContext context) {
    _authService = AuthService();
    _databaseService = DatabaseService();
    requestState = ref.watch(patientProvider);
    _isGoingToDonate = false;
    requests = requestState.data ?? [];
    ref
        .read(currentUserProvider.notifier)
        .fetchCurrentUser(_authService.currentUser!.uid);
    currentUserState = ref.watch(currentUserProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: CustomPaint(
              size: const Size(double.infinity, 400),
              painter: HomeBackground(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListView(
              children: [
                _menuCard(),
                SizedBox(
                  height: 615,
                  child: requestState.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : requestState.errorMessage != null
                          ? Center(
                              child:
                                  Text('Error: ${requestState.errorMessage}'),
                            )
                          : requests.isEmpty
                              ? const Center(
                                  child: Text('No requests available'),
                                )
                              : PageView.builder(
                                  itemCount: requests.length,
                                  controller: _pageController,
                                  itemBuilder: (context, index) {
                                    return _request(
                                      index,
                                      _authService.currentUser!.uid,
                                    );
                                  },
                                ),
                ),
                if (!requestState.isLoading &&
                    requestState.errorMessage == null &&
                    requests.isNotEmpty)
                  Center(
                    child: SizedBox(
                      height: 32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Expanded(child: _smoothPageIndicator()),
                          Expanded(child: _seeAll()),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(),
    );
  }

  Widget _patientInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }

  Widget _tappableCard(String title, IconData icon, String route) {
    return InkWell(
      onTap: () {
        NavigationService().navigateToRoute(route);
      },
      child: Card(
        child: SizedBox(
          height: 85,
          width: 85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(title, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _request(int index, String currentUserUid) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                '${requests[index].bloodGroup} BLOOD REQUIRED',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            _divider(),
            _patientInfo(
              'Patient Name',
              requests[index].name,
            ),
            _divider(),
            _patientInfo(
              'Blood Group',
              requests[index].bloodGroup,
            ),
            _divider(),
            _patientInfo(
              'Amount of bag',
              requests[index].units.toString(),
            ),
            _divider(),
            _patientInfo(
              'Transfusion Date',
              requests[index].transfusionDate,
            ),
            _divider(),
            _patientInfo(
              'Time',
              requests[index].transfusionTime,
            ),
            _divider(),
            _patientInfo(
              'Hospital',
              requests[index].hospital,
            ),
            _divider(),
            _patientInfo(
              'Address',
              requests[index].address,
            ),
            _divider(),
            _patientInfo(
              'Phone',
              requests[index].contact,
            ),
            _divider(),
            _patientInfo('Age', requests[index].age.toString()),
            _divider(),
            _patientInfo(
              'Haemoglobin',
              requests[index].haemoglobin.toString(),
            ),
            _divider(),
            _patientInfo('Description', requests[index].description),
            _requestNo(index),
            if (requests[index].currentUserUid != currentUserUid)
              _donateButton(requests[index]),
            if (requests[index].currentUserUid == currentUserUid)
              _editOrCancelButton(requests[index]),
          ],
        ),
      ),
    );
  }

  Widget _requestNo(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.bottomRight,
      child: Text('request no. ${index + 1}'),
    );
  }

  Widget _donateButton(PatientModel request) {
    return CustomElevatedButton(
      isLoading: _isGoingToDonate,
      onPressed: currentUserState.data!.isGoingToDonate
          ? null
          : currentUserState.isLoading
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                }
              : currentUserState.errorMessage != null
                  ? () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text(currentUserState.errorMessage!),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          });
                    }
                  : () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Donate'),
                              content: const Text(
                                  'Are you sure you want to donate?'),
                              actions: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    Expanded(
                                      child: CustomElevatedButton(
                                        isLoading: _isGoingToDonate,
                                        onPressed: () async {
                                          _donate(request);
                                          NavigationService().goBack();

                                          final userSnapshot =
                                              await _databaseService.getUser(
                                                  request.currentUserUid);
                                          final otherUser = UserModel.fromMap(
                                              userSnapshot.data()
                                                  as Map<String, dynamic>);
                                          NavigationService().navigateToRoute(
                                            '/chat',
                                            arguments: otherUser,
                                          );
                                        },
                                        title: 'Yes',
                                        width: 20,
                                        height: 35,
                                      ),
                                    ),
                                    // TextButton(
                                    //   onPressed: () {
                                    //     _donate(request);
                                    //     Navigator.of(context).pop();
                                    //   },
                                    //   child: const Text('Yes'),
                                    // ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
      title: 'Donate Now!',
      width: 40,
      height: 45,
      fontSize: 14,
    );
  }

  Widget _smoothPageIndicator() {
    return Container(
      alignment: Alignment.center, // Center the indicator
      width: 200, // Make the container take the full width
      height: 50.0, // Provide a fixed height
      child: SmoothPageIndicator(
        controller: _pageController,
        count: requests.length > 10 ? 10 : requests.length,
        effect: const WormEffect(
          dotHeight: 8.0,
          dotWidth: 8.0,
          activeDotColor: Colors.red,
          dotColor: Colors.grey,
        ),
        onDotClicked: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Widget _seeAll() {
    return CustomTextButton(
      onPressed: _requestlists,
      title: 'See all',
    );
  }

  Widget _menuCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tappableCard(
            'Find Donor',
            Icons.search,
            '/donors',
          ),
          _tappableCard(
            'Blood Request',
            Icons.bloodtype,
            '/request',
          ),
          _tappableCard(
            'None',
            Icons.mic_none,
            '/request',
          ),
          _tappableCard(
            'None',
            Icons.mic_none,
            '/request',
          ),
        ],
      ),
    );
  }

  Widget _editOrCancelButton(PatientModel request) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Spacer(),
        Expanded(
          child: CustomElevatedButton(
            isLoading: false,
            onPressed: () {
              _editRequest(request);
            },
            title: 'Edit',
            width: 40,
            height: 45,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: CustomTextButton(onPressed: () {}, title: 'Cancel'),
        ),
      ],
    );
  }
}
