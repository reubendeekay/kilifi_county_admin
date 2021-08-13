import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  String encodeQueryParameters(Map<String, String> params) {
                    return params.entries
                        .map((e) =>
                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                        .join('&');
                  }

                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'reubenjefwa4@gmail.com',
                    query: encodeQueryParameters(
                        <String, String>{'subject': 'Hello Reuben!'}),
                  );

                  launch(emailLaunchUri.toString());
                },
                child: FaIcon(
                  FontAwesomeIcons.envelope,
                  color: kBackground,
                ),
              ),
              SizedBox(width: 30),
              GestureDetector(
                onTap: () async =>
                    await _launchInBrowser('https://github.com/reubendeekay'),
                child: FaIcon(
                  FontAwesomeIcons.github,
                  color: kBackground,
                ),
              ),
              SizedBox(width: 30),
              GestureDetector(
                onTap: () async => await _launchInBrowser(
                    'https://www.linkedin.com/in/reuben-balozi-18991420b'),
                child: FaIcon(
                  FontAwesomeIcons.linkedin,
                  color: kBackground,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5, top: 10),
          child: Text(
            'Copyright© 2021 Deekay. All rights Reserved',
            style: font(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
