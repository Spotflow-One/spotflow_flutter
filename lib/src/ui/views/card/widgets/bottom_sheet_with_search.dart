import 'package:flutter/material.dart';
import 'package:spotflow/src/core/models/country.dart';

class BottomSheetWithSearch extends StatefulWidget {
  final List<BaseModel> items;
  final Function(BaseModel) onSelect;

  const BottomSheetWithSearch(
      {super.key, required this.items, required this.onSelect});

  @override
  State<BottomSheetWithSearch> createState() => _BottomSheetWithSearchState();
}

class _BottomSheetWithSearchState extends State<BottomSheetWithSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<BaseModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items; // Start with the full list
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  title: Text(item.name),
                  onTap: () {
                    widget.onSelect(item); // Call the onSelect callback
                    Navigator.pop(context); // Close the bottom sheet
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
