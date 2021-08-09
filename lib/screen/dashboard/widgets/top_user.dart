import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

class TopUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UsersProvider>(context, listen: false).user;

    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        children: [
          Spacer(),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl),
              radius: 20,
            ),
          ),
          SizedBox(width: size.width * 0.01),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3),
              Text(
                user.email,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 12),
              ),
            ],
          ),
          SizedBox(width: size.width * 0.02),
          Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.grey,
            size: 20,
          ),
          SizedBox(width: size.width * 0.01),
        ],
      ),
    );
  }
}
