import 'package:cinemanic/models/tmdb_models.dart';
import 'package:cinemanic/screens/genre_detail_screen.dart';
import 'package:cinemanic/screens/person_details_screen.dart';
import 'package:cinemanic/screens/production_company_detail_screen.dart';
import 'package:flutter/material.dart';

class ContentTabsWidget extends StatelessWidget {
  final CreditResponse credits;
  final List<Genre> genres;
  final List<AlternativeTitle> altTitles;
  final List<ReleaseInfo> releases;
  final List<ProductionCompany> studios;
  final List<ProductionCountry> countries;
  final String originalLanguage;

  const ContentTabsWidget({
    super.key,
    required this.credits,
    required this.genres,
    required this.altTitles,
    required this.releases,
    required this.studios,
    required this.countries,
    required this.originalLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          const TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              Tab(text: 'Cast'),
              Tab(text: 'Crew'),
              Tab(text: 'Details'),
              Tab(text: 'Genre'),
              Tab(text: 'Releases'),
            ],
          ),
          SizedBox(
            height: 300, // Adjust height as needed
            child: TabBarView(
              children: [
                _buildCastTab(),
                _buildCrewTab(),
                _buildDetailsTab(context),
                _buildGenreTab(context),
                _buildReleasesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastTab() {
    if (credits.cast.isEmpty) {
      return const Center(child: Text('No cast information available'));
    }
    return ListView.builder(
      itemCount: credits.cast.length,
      itemBuilder: (context, index) {
        final person = credits.cast[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PersonDetailsScreen(personId: person.id.toString()),
              ),
            );
          },
          leading: person.profilePath != null
              ? CircleAvatar(backgroundImage: NetworkImage(person.profileUrl!))
              : const CircleAvatar(child: Icon(Icons.person)),
          title: Text(person.name),
          subtitle: Text(person.character),
        );
      },
    );
  }

  Widget _buildCrewTab() {
    if (credits.crew.isEmpty) {
      return const Center(child: Text('No crew information available'));
    }
    return ListView.builder(
      itemCount: credits.crew.length,
      itemBuilder: (context, index) {
        final person = credits.crew[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PersonDetailsScreen(personId: person.id.toString()),
              ),
            );
          },
          leading: person.profilePath != null
              ? CircleAvatar(backgroundImage: NetworkImage(person.profileUrl!))
              : const CircleAvatar(child: Icon(Icons.person)),
          title: Text(person.name),
          subtitle: Text('${person.job} (${person.department})'),
        );
      },
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Studios',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: studios.map((studio) {
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductionCompanyDetailScreen(
                            companyId: studio.id.toString(),
                          ),
                        ),
                      );
                    },
                    title: Text(studio.name),
                  );
                }).toList(),
              ),
              if (studios.isEmpty) const Text('N/A'),
              const Divider(),
            ],
          ),
        ),
        _detailRow('Countries', countries.map((e) => e.name).join(', ')),
        _detailRow('Original Language', originalLanguage.toUpperCase()),
        if (altTitles.isNotEmpty)
          _detailRow(
            'Alternative Titles',
            altTitles.map((e) => e.title).join('\n'),
          ),
      ],
    );
  }

  Widget _buildGenreTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            genres.map((genre) {
              return ActionChip(
                label: Text(genre.name),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => GenreDetailScreen(
                            genreId: genre.id,
                            genreName: genre.name,
                          ),
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }

  Widget _buildReleasesTab() {
    if (releases.isEmpty) {
      return const Center(child: Text('No release information available'));
    }
    return ListView.builder(
      itemCount: releases.length,
      itemBuilder: (context, index) {
        final release = releases[index];
        return ListTile(
          title: Text(release.iso31661 ?? 'Global'),
          subtitle: release.rating != null
              ? Text('Rating: ${release.rating}')
              : Text(
                  release.releaseDates
                          ?.map((e) => e.releaseDate.split('T').first)
                          .join(', ') ??
                      '',
                ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(value.isEmpty ? 'N/A' : value),
          const Divider(),
        ],
      ),
    );
  }
}
