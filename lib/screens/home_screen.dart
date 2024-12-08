// ignore_for_file: unused_element

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
import '../authentication/email_verification.dart';
import '../screens/request_lists.dart';
//models
import '../models/user_model.dart';
import '../models/data_state.dart';
import '../models/request_response.dart';
//widgets
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_button.dart';
import '../background/main_screen_background.dart';
//services
import '../services/navigation_service.dart';
import '../services/auth_service.dart';
import '../services/push_notification_service.dart';
//providers
import '../providers/user_provider.dart';
import '../providers/current_user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  late DataState<List<PatientModel>> requestState;
  late List<PatientModel> myRequests;
  List<PatientModel> requests = [];
  late AuthService _authService;
  late DataState<UserModel> currentUserState;
  bool _isGoingToDonate = false;
  late DatabaseService _databaseService;

  // ignore: prefer_final_fields
  bool _isCancellingRequest = false;
  RequestResponse requestResponse = RequestResponse();
  PushNotificationService _pushNotificationService = PushNotificationService();

  Future<void> sendResponse(PatientModel reqeust) async {
    requestResponse.responseId = '';
    requestResponse.donorId = currentUserState.data!.uid;
    requestResponse.donorName = currentUserState.data!.name;
    requestResponse.patientName = reqeust.name;
    requestResponse.recipientId = reqeust.currentUserUid;
    requestResponse.requestId = reqeust.requestId;
    requestResponse.bloodGroup = currentUserState.data!.bloodGroup;
    requestResponse.responseDate = DateTime.now();
    requestResponse.responseMessage = 'I want to donate blood to your patient';
    requestResponse.responseStatus = false;

    final response = requestResponse.toMap();
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('request_response')
        .add(response);
    Logger().i(docRef.id);
    String responseId = docRef.id;
    await docRef.update({'responseId': responseId});
  }

  void _requestNotificationPermissions() {
    _pushNotificationService.requestNotificationPermissions();
  }

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _databaseService = DatabaseService();
    _requestNotificationPermissions();
    _setupTokenRefreshListener();

    ref.read(currentUserProvider);
  }

  void _setupTokenRefreshListener() {
    _pushNotificationService.setupTokenRefreshListener();
  }

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
      await sendResponse(request);
      if (request.units == 0) {
        ref
            .watch(patientProvider.notifier)
            .updateIsRequestCompleted(request.requestId, true);
      }
      final chatId = _databaseService.getChatId(
          _authService.currentUser!.uid, request.currentUserUid);
      final message = MessageModel(
        messageId: '',
        message: 'I want to donate blood to your patient',
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

  void _cancelRequest(String requestId) {
    ref.read(patientProvider.notifier).cancelBloodRequest(requestId);
  }

  @override
  Widget build(BuildContext context) {
    _authService = AuthService();

    _databaseService = DatabaseService();

    requestState = ref.watch(patientProvider);
    ref.watch(patientProvider.notifier).fetchBloodRequests();

    requests = requestState.data ?? [];
    ref
        .read(currentUserProvider.notifier)
        .fetchCurrentUser(_authService.currentUser!.uid);

    currentUserState = ref.watch(currentUserProvider);

    myRequests = requests
        .where((request) =>
            request.currentUserUid == currentUserState.data!.uid &&
            !request.isRequestDelete &&
            !request.isRequestComplete)
        .toList();
    final otherRequests = requests
        .where((request) =>
            request.currentUserUid != currentUserState.data!.uid &&
            !request.isRequestDelete &&
            !request.isRequestComplete)
        .toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          SizedBox(
            height: kIsWeb ? 50 : 400,
            width: double.infinity,
            child: CustomPaint(
              size: const Size(
                200,
                100,
              ),
              painter: HomeBackground(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListView(
              children: [
                if (!kIsWeb)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            NavigationService().navigateToRoute('/donors');
                          },
                          child: Card(
                            child: SizedBox(
                              height: 85,
                              width: 85,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Find Donor',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            NavigationService().navigateToRoute('/request');
                          },
                          child: Card(
                            child: SizedBox(
                              height: 85,
                              width: 85,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.bloodtype,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Blood Request',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            NavigationService().navigateToRoute('/response');
                          },
                          child: Card(
                            child: SizedBox(
                              height: 85,
                              width: 85,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.reply,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Responses',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (currentUserState.data != null &&
                            currentUserState.data!.isDonor)
                          InkWell(
                            onTap: () {
                              NavigationService().navigateToRoute('/donations');
                            },
                            child: Card(
                              child: SizedBox(
                                height: 85,
                                width: 85,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.volunteer_activism,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Donations',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 615,
                  child: requestState.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : requestState.errorMessage != null
                          ? Center(
                              child:
                                  Text('Error: ${requestState.errorMessage}  '),
                            )
                          : otherRequests.isEmpty
                              ? const SizedBox(
                                  width: 400,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Card(
                                      elevation: 5,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.info,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                            Text('No requests available ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 400,
                                  child: PageView.builder(
                                    itemCount: otherRequests.length,
                                    controller: _pageController,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kIsWeb ? 256.0 : 16,
                                        ),
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: kIsWeb
                                                    ? 400
                                                    : double.infinity,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                child: Text(
                                                  '${otherRequests[index].bloodGroup} BLOOD REQUIRED',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                'Patient Name',
                                                otherRequests[index].name,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                'Blood Group',
                                                otherRequests[index].bloodGroup,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                'Amount of bag',
                                                otherRequests[index]
                                                    .units
                                                    .toString(),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                'Transfusion Date',
                                                otherRequests[index]
                                                    .transfusionDate,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                'Time',
                                                otherRequests[index]
                                                    .transfusionTime,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                'Hospital',
                                                otherRequests[index].hospital,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                'Address',
                                                otherRequests[index].address,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                'Phone',
                                                otherRequests[index].contact,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                  'Age',
                                                  otherRequests[index]
                                                      .age
                                                      .toString()),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                'Haemoglobin',
                                                otherRequests[index]
                                                    .haemoglobin
                                                    .toString(),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Divider(),
                                              ),
                                              _patientInfo(
                                                  'Description',
                                                  otherRequests[index]
                                                      .description),
                                              _requestNo(index),
                                              if (otherRequests[index]
                                                      .currentUserUid !=
                                                  currentUserState.data!.uid)
                                                _donateButton(
                                                    otherRequests[index]),
                                              if (otherRequests[index]
                                                      .currentUserUid ==
                                                  currentUserState.data!.uid)
                                                _editOrCancelButton(
                                                    otherRequests[index]),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                ),
                if (!requestState.isLoading &&
                    requestState.errorMessage == null &&
                    otherRequests.isNotEmpty)
                  Center(
                    child: SizedBox(
                      height: 32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Expanded(
                              child:
                                  _smoothPageIndicator(otherRequests.length)),
                          Expanded(child: _seeAll(otherRequests.length)),
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

  Widget _patientInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          Text(
            value,
          ),
        ],
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
      onPressed: !currentUserState.data!.isDonor
          ? null
          : currentUserState.data!.isGoingToDonate
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
                      : request.bloodGroup != currentUserState.data!.bloodGroup
                          ? () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                        'You can only donate blood of your own blood group',
                                      ),
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
                          : !currentUserState.data!.isDonor
                              ? () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text(
                                            'You are not a donor',
                                          ),
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
                                            'Are you sure you want to donate?',
                                          ),
                                          actions: [
                                            Row(
                                              children: [
                                                const Spacer(),
                                                Expanded(
                                                  child: CustomElevatedButton(
                                                    isLoading: _isGoingToDonate,
                                                    onPressed: () async {
                                                      _donate(request);
                                                      NavigationService()
                                                          .goBack();

                                                      final userSnapshot =
                                                          await _databaseService
                                                              .getUser(request
                                                                  .currentUserUid);
                                                      final otherUser =
                                                          UserModel.fromMap(
                                                              userSnapshot
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>);
                                                      NavigationService()
                                                          .navigateToRoute(
                                                        '/chat',
                                                        arguments: otherUser,
                                                      );
                                                    },
                                                    title: 'Yes',
                                                    width: 20,
                                                    height: 35,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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

  Widget _smoothPageIndicator(int len) {
    return Container(
      alignment: Alignment.center,
      width: 200,
      height: 50.0,
      child: SmoothPageIndicator(
        controller: _pageController,
        count: len > 10 ? 10 : len,
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

  Widget _seeAll(int length) {
    return CustomTextButton(
      isLoading: false,
      onPressed: _requestlists,
      title: 'See all ($length)',
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
          child: CustomTextButton(
            isLoading: false,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Cancel Request'),
                    content: const Text(
                      'Are you sure you want to cancel this request?',
                    ),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              isLoading: false,
                              onPressed: () {
                                NavigationService().goBack();
                              },
                              title: 'No',
                              width: 40,
                              height: 45,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                _cancelRequest(request.requestId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Request cancelled successfully',
                                    ),
                                  ),
                                );
                                NavigationService().goBack();
                              },
                              child: _isCancellingRequest
                                  ? const SizedBox(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text('Yes'),
                            ),
                            // child: CustomTextButton(
                            //   isLoading: _isCancellingRequest,
                            //   onPressed: () async {
                            //     if (mounted) {
                            //       setState(() {
                            //         _isCancellingRequest = true;
                            //       });
                            //     }
                            //     await _cancelRequest(request.requestId);
                            //     NavigationService().goBack();
                            //   },
                            //   title: 'Yes',
                            // ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
            title: 'Cancel',
          ),
        ),
      ],
    );
  }
}
