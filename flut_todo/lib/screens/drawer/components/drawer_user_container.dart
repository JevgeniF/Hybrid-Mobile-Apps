import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class DrawerUserContainer extends StatelessWidget {
  const DrawerUserContainer({
    Key? key,
    this.name = 'Name',
    this.lastName = 'LastName',
    this.email = 'name.lastname@email.com',
  }) : super(key: key);

  final String name;
  final String lastName;
  final String email;

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var containerColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Column(children: <Widget>[
          Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(top: 30, bottom: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/userImage.png'),
                    fit: BoxFit.fill),
              )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              name,
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(lastName,
                style: const TextStyle(fontSize: 22, color: Colors.white)),
          ]),
          Text(email, style: const TextStyle(color: Colors.white)),
        ])),
        decoration: BoxDecoration(
          color: containerColor,
          border:
              const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ));
  }
}
