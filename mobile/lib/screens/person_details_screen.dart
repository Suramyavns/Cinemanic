import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/services/detail_api.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:cinemanic/utils/images.dart';
import 'package:cinemanic/widgets/reusable_widgets/credit_grid_widget.dart';
import 'package:cinemanic/widgets/theme_switcher_widget.dart';
import 'package:flutter/material.dart';

class PersonDetailsScreen extends StatefulWidget {
  const PersonDetailsScreen({super.key, required this.personId});

  final String personId;

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  PersonDetails? personDetailsData;
  PersonCredits? personCreditsData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final results = await Future.wait([
        getPersonDetails(widget.personId),
        getPersonCreditDetails(widget.personId),
      ]);
      setState(() {
        personDetailsData = results[0] as PersonDetails;
        personCreditsData = results[1] as PersonCredits;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading person data: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load details. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(actions: [ThemeSwitcherWidget()]),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null ||
        personDetailsData == null ||
        personCreditsData == null) {
      return Scaffold(
        appBar: AppBar(actions: [ThemeSwitcherWidget()]),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage ?? 'An unexpected error occurred'),
              SizedBox(height: 16),
              ElevatedButton(onPressed: loadData, child: Text('Retry')),
            ],
          ),
        ),
      );
    }

    final details = personDetailsData!;
    final credits = personCreditsData!;

    return Scaffold(
      appBar: AppBar(actions: [ThemeSwitcherWidget()]),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: details.profilePath != null
                      ? NetworkImage(imageUrlBuilder(details.profilePath!))
                      : null,
                  child: details.profilePath == null
                      ? Icon(Icons.person)
                      : null,
                ),
                Text(details.name, style: KTextStyle.headingTextStyle),
                Text(
                  details.biography,
                  style: KTextStyle.bodyTextStyle,
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Text(
                      'Known for ${details.knownForDepartment}',
                      style: KTextStyle.bodyTextStyle,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Career', style: KTextStyle.headingTextStyle),
                  ],
                ),
                TabBar(
                  isScrollable: false,
                  tabs: [
                    Tab(text: 'Cast'),
                    Tab(text: 'Crew'),
                  ],
                ),
                SizedBox(
                  height:
                      500, // Fixed height for TabBarView inside SingleChildScrollView
                  child: TabBarView(
                    children: [
                      CreditGridWidget(credits: credits.cast),
                      CreditGridWidget(credits: credits.crew),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
