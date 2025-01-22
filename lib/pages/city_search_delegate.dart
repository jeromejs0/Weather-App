import 'package:flutter/material.dart';

class CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Action buttons in the AppBar (e.g., clear query)
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Back button
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (query.isEmpty) {
          close(context, ''); // Close with an empty value
        } else {
          close(context, query); // Return the entered query
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Delay the close call until the build phase is complete
    Future.microtask(() {
      close(context, query.isEmpty ? '' : query); // Return the entered city name
    });

    // Display a temporary message while closing
    return Center(
      child: Text("Fetching weather for \"$query\"..."),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // No suggestions are displayed, just return an empty container
    return Container();
  }
}
