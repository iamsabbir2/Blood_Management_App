import 'package:blood_management_app/widgets/donors.dart';
import 'package:blood_management_app/widgets/request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BmaScreen extends StatefulWidget {
  const BmaScreen({super.key});

  @override
  State<BmaScreen> createState() {
    return _BmaScreenState();
  }
}

class _BmaScreenState extends State<BmaScreen> {
  final PageController _pageController = PageController();
  final List<String> _imagePath = ['assets/pic1.jpg', 'assets/pic2.jpg'];

  //String? _userEmail;
  //String? _userPhoneNumber;

  // @override
  // void initState() {
  //   super.initState();
  //   _getUserEmail();
  // }

  // void _getUserEmail() {
  //   final User? user = FirebaseAuth.instance.currentUser;

  //   setState(() {
  //     _userEmail = user!.email;
  //     _userPhoneNumber = user.phoneNumber;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // CustomPaint(
        CustomPaint(
          size: Size(double.infinity, 400),
          painter: MyCustomPainter(),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              // GridView with fixed height
              Container(
                height: 150, // Set the height of the GridView
                child: GridView.count(
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
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 40.0,
                              color: Colors.red,
                            ),
                            Text('Find Donor'),
                          ],
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
                              color: Colors.red,
                            ),
                            Text('Blood Request'),
                          ],
                        ),
                      ),
                    ),
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
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 40.0,
                              color: Colors.red,
                            ),
                            Text('Find Donor'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // child: GridView.builder(
                //   physics:
                //       NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 3,
                //   ),
                //   itemCount: 3, // Number of items in the grid

                //   itemBuilder: (context, index) {
                //     return Container(
                //       margin: EdgeInsets.all(4.0),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(8.0),
                //         color: Colors.red.withAlpha(50),
                //       ),
                //       child: Center(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Icon(
                //               Icons.search,
                //               size: 40.0,
                //               color: Colors.white,
                //             ),
                //             Text(
                //               'Find Donor',
                //               style: TextStyle(
                //                 color: Colors.white,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ),
              // CarouselSlider
              CarouselSlider(
                options: CarouselOptions(
                  height: 300.0,
                  autoPlay: true,
                ),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Card(
                        elevation: 5.0,
                        color: Colors.white,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'Emergency Blood Request',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('Blood Group: A+'),
                            ],
                          ),
                        )),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Container(
                height: 300, // Set the height of the GridView
                child: GridView.builder(
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
                        borderRadius: BorderRadius.circular(0.0),
                        color: Theme.of(context).primaryColor.withAlpha(50),
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
                              Icons.request_page,
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
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 223, 10, 10)
      ..style = PaintingStyle.fill;

    // Draw a rectangle
    //drwa half circle
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

    // Add more custom drawing logic here
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
