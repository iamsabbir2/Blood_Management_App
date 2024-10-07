import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomListViewTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() onTap;
  final double height;
  final bool isActivity;
  final bool isOnline;

  const CustomListViewTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.height,
    required this.onTap,
    required this.isActivity,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red,
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: isOnline ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
      minVerticalPadding: height * 0.20,
      title: Text(title),
      subtitle: isActivity
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  child: SpinKitThreeBounce(
                    color: Colors.red,
                    size: 15,
                  ),
                ),
              ],
            )
          : Text(subtitle, style: TextStyle()),
      onTap: onTap,
    );
  }
}
