import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/services/detail_api.dart';
import 'package:cinemanic/services/discover_api.dart';
import 'package:cinemanic/widgets/reusable_widgets/discovery_tabs_widget.dart';
import 'package:cinemanic/widgets/theme_switcher_widget.dart';
import 'package:flutter/material.dart';

class ProductionCompanyDetailScreen extends StatefulWidget {
  final String companyId;

  const ProductionCompanyDetailScreen({super.key, required this.companyId});

  @override
  State<ProductionCompanyDetailScreen> createState() =>
      _ProductionCompanyDetailScreenState();
}

class _ProductionCompanyDetailScreenState
    extends State<ProductionCompanyDetailScreen> {
  ProductionCompanyDetail? companyData;
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
      final data = await getProductionCompanyDetails(widget.companyId);
      setState(() {
        companyData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading company data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(actions: [const ThemeSwitcherWidget()]),
        body: LinearProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(actions: [const ThemeSwitcherWidget()]),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: loadData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final company = companyData!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(company.name),
          actions: [const ThemeSwitcherWidget()],
        ),
        body: DiscoveryTabsWidget(
          movieFuture: discoverMoviesByProductionCompany(widget.companyId),
          tvFuture: discoverTVByProductionCompany(widget.companyId),
          header: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (company.logoUrl != null)
                  Center(
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        company.logoUrl!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                Text(
                  company.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (company.headquarters.isNotEmpty)
                  _infoRow(Icons.location_on, company.headquarters),
                if (company.originCountry.isNotEmpty)
                  _infoRow(Icons.flag, company.originCountry),
                if (company.homepage != null && company.homepage!.isNotEmpty)
                  _infoRow(Icons.language, company.homepage!),
                const Divider(height: 32),
                Text(
                  'Description',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  company.description.isEmpty
                      ? 'No description available.'
                      : company.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
