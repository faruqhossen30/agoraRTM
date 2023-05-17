import 'package:flutter/material.dart';
import 'package:realtimemessagin/audience_page.dart';
import 'package:realtimemessagin/host_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: (){
                Navigator.pushNamed(context, HostPage.routeName);
              }, child: Text('Host')),
              TextButton(onPressed: (){
                Navigator.pushNamed(context, AudiencePage.routeName);
              }, child: Text('Audience')),
            ],
          ),
        ),
      ),
    );
  }
}
