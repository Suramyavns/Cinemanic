import 'package:cinemanic/services/auth_service.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:cinemanic/utils/notifiers.dart';
import 'package:flutter/material.dart';

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        selectedIndexNotifier.value = 0;
        AuthService().signOutWithGoogle();
      },
      style: TextButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.red[900]!, width: 2),
        ),
      ),
      child: Text('Logout', style: KTextStyle.buttonTextStyle),
    );
  }
}
