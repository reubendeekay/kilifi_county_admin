import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/user_management/widgets/add_admin_card.dart';

class AddVerificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.28,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Verify a User',
                  style: font()
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: size.width * 0.2,
                child: Text(
                    'Verify that a user is a confirmed real presence of a public figure or an important person or a celebrity. They will have a blue checkmark next to their name'),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => Dialog(
                            child: AdminExisting(),
                          ));
                },
                color: kBackground,
                child: Text(
                  'Get User',
                  style: font().copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: Image.asset(
                'assets/images/admin2.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
