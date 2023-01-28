import 'package:flutter/material.dart';
import 'package:meeting/data/person/person.dart';

class CustomDelegate extends SearchDelegate<Person?> {
  final List<Person> persons;

  CustomDelegate({
    required this.persons,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        splashRadius: 20,
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      splashRadius: 20,
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResult(
      persons: persons,
      query: query,
      onTap: (selectedPerson) => close(context, selectedPerson),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchResult(
      persons: persons,
      query: query,
      onTap: (selectedPerson) => close(context, selectedPerson),
    );
  }

  @override
  String? get searchFieldLabel => 'Person Name';
}

class SearchResult extends StatelessWidget {
  final Function(Person) onTap;
  const SearchResult({
    Key? key,
    required this.persons,
    required this.query,
    required this.onTap,
  }) : super(key: key);

  final List<Person> persons;
  final String query;

  @override
  Widget build(BuildContext context) {
    List<Person> result = persons.where((person) {
      return person.firstName.toLowerCase().contains(query.toLowerCase()) ||
          person.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${result[index].firstName} ${result[index].lastName}'),
          onTap: () => onTap.call(result[index]),
        );
      },
    );
  }
}
