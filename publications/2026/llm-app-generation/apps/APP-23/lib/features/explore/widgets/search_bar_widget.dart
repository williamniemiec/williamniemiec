import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/explore_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final Function(String) onSuggestionTap;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    required this.onSuggestionTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(
      builder: (context, exploreProvider, child) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search here',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.secondaryTextColor),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppTheme.secondaryTextColor),
                          onPressed: () {
                            _controller.clear();
                            exploreProvider.clearSearchResults();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingM,
                    vertical: AppConstants.spacingM,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                  if (value.isNotEmpty) {
                    exploreProvider.getAutocompleteSuggestions(value);
                  }
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.onSearch(value);
                    _focusNode.unfocus();
                  }
                },
              ),
            ),
            
            // Suggestions dropdown
            if (_showSuggestions && exploreProvider.searchSuggestions.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: AppConstants.spacingXS),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exploreProvider.searchSuggestions.length.clamp(0, 5),
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final suggestion = exploreProvider.searchSuggestions[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: AppTheme.secondaryTextColor,
                        size: 20,
                      ),
                      title: Text(
                        suggestion,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        _controller.text = suggestion;
                        widget.onSuggestionTap(suggestion);
                        _focusNode.unfocus();
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}