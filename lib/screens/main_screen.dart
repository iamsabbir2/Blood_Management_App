import 'package:blood_management_app/screens/request_lists.dart';
import 'package:blood_management_app/widgets/donors.dart';
import 'package:blood_management_app/widgets/request.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BmaScreen extends StatefulWidget {
  const BmaScreen({super.key});

  @override
  State<BmaScreen> createState() {
    return _BmaScreenState();
  }
}

class _BmaScreenState extends State<BmaScreen> {
  final PageController _pageController = PageController();
  void _requestlists() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return RequestLists();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, 400),
            painter: MyCustomPainter(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Container(
                  height: 150,
                  child: GridView.count(
                    padding: EdgeInsets.all(10),
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    children: [
                      InkWell(
                        onTap: () {
                          print('Find Donor');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) {
                                return DonorsList();
                              },
                            ),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 2,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 40.0,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                Text('Find Donor'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print('Blood Request');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) {
                                return BloodRequest();
                              },
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bloodtype,
                                size: 40.0,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              Text('Blood Request'),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Feedback from'),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mic_none,
                                size: 40.0,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              Text('None'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('blood_requests')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text('Currently there is no request'),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Something went wrong'),
                      );
                    }
                    final loadRequests = snapshot.data!.docs;
                    loadRequests.where(
                      (element) {
                        return ((element['timestap'] as Timestamp)
                                .compareTo(Timestamp.now()) <=
                            0);
                      },
                    );
                    print(loadRequests.length);
                    return Column(
                      children: [
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 420,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            autoPlayInterval: Duration(
                              seconds: 10,
                            ),
                          ),
                          itemCount: loadRequests.length,
                          itemBuilder: (context, index, realIndex) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${loadRequests[index]['blood_type']} BLOOD REQUIRED',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Patient Name',
                                          ),
                                          Spacer(),
                                          Text(
                                            '${loadRequests[index]['name']}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Patient Name',
                                          ),
                                          Spacer(),
                                          Text(
                                            '${loadRequests[index]['name']}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Patient Name',
                                          ),
                                          Spacer(),
                                          Text(
                                            '${loadRequests[index]['name']}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Patient Name',
                                          ),
                                          Spacer(),
                                          Text(
                                            '${loadRequests[index]['name']}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Patient Name',
                                          ),
                                          Spacer(),
                                          Text(
                                            '${loadRequests[index]['name']}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Divider(),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: Text('request no. ${index + 1}'),
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          )),
                                      child: Text(
                                        'Donate Now!',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          child: TextButton(
                            onPressed: _requestlists,
                            child: Text(
                              'See all',
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  height: 300,
                  child: GridView.builder(
                    padding: EdgeInsets.all(10),
                    physics:
                        NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                    ),
                    itemCount: 6, // Number of items in the grid
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.question_mark_sharp,
                                size: 40.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 223, 10, 10)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..arcTo(
        Rect.fromCircle(
            center: Offset(size.width / 2, 0), radius: size.width / 2),
        0,
        3.14,
        false,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
