import 'package:cinemanic/models/watchlist.dart';
import 'package:cinemanic/services/auth_service.dart';
import 'package:cinemanic/services/watchlist_api.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:cinemanic/widgets/home_screen_widgets/content_row_widget.dart';
import 'package:cinemanic/widgets/profile_screen_widgets/logout_button_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<WatchList> watchListData;
  bool isLoading = true;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    try {
      List<WatchList> watchList = await getWatchList();
      if (mounted) {
        setState(() {
          watchListData = watchList;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: RefreshIndicator(
        onRefresh: loadData,
        child: isLoading
            ? LinearProgressIndicator()
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          AuthService().currentUser!.photoURL!,
                        ),
                      ),
                      Text(
                        AuthService().currentUser!.displayName!,
                        style: KTextStyle.headingTextStyle,
                      ),
                      watchListData.isNotEmpty
                          ? ContentRowWidget(
                              title: 'Your Watchlist',
                              data: watchListData,
                              mediaType: 'watchlist',
                            )
                          : Text('No watchlist found'),
                      LogoutButtonWidget(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
