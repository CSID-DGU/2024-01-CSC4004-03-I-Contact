import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_result_screen.dart'; // Import the SearchResultScreen

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _recentSearches = [];

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
  }

  void _removeRecentSearch(int index) {
    setState(() {
      _recentSearches.removeAt(index);
      _saveRecentSearches();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  void _onSubmitted(String query) {
    setState(() {
      if (!_recentSearches.contains(query)) {
        _recentSearches.add(query);
        if (_recentSearches.length > 10) {
          _recentSearches
              .removeAt(0); // Remove the oldest search if the limit is exceeded
        }
        _saveRecentSearches();
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(query: query),
      ),
    );
  }

  void _onRecentSearchTap(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('검색'),
      ),
      body: Column(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight * 0.07,
            margin: EdgeInsets.only(
                bottom: screenHeight * 0.02,
                left: screenHeight * 0.03,
                right: screenHeight * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 2.0,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요.',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black38,
                ),
              ),
              keyboardType: TextInputType.text,
              onSubmitted: _onSubmitted,
            ),
          ),
          Expanded(
            child: Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ListView(
                children: _recentSearches
                    .asMap()
                    .entries
                    .map((entry) {
                      return RecentSearchWidget(
                        key: ValueKey(entry.key),
                        searchText: entry.value,
                        onDelete: () => _removeRecentSearch(entry.key),
                        onTap: () => _onRecentSearchTap(entry.value),
                      );
                    })
                    .toList()
                    .reversed
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentSearchWidget extends StatelessWidget {
  final String searchText;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const RecentSearchWidget({
    super.key,
    required this.searchText,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.07,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.black54, width: 1)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.08,
            ),
            SizedBox(
              width: screenWidth * 0.75,
              child: Text(
                searchText,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: screenHeight * 0.022,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.cancel_sharp),
              color: Colors.black54,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
