import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../models/pin.dart';
import '../widgets/pin_card.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Pin> _pins = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadPins();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMorePins();
      }
    }
  }

  Future<void> _loadPins() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call with sample data
      await Future.delayed(const Duration(seconds: 1));
      final newPins = _generateSamplePins();
      
      setState(() {
        _pins.addAll(newPins);
        _isLoading = false;
        _currentPage++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load pins');
    }
  }

  Future<void> _loadMorePins() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final newPins = _generateSamplePins();
      
      setState(() {
        _pins.addAll(newPins);
        _isLoading = false;
        _currentPage++;
        
        // Simulate end of data after 5 pages
        if (_currentPage > 5) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load more pins');
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _pins.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    await _loadPins();
  }

  List<Pin> _generateSamplePins() {
    final samplePins = <Pin>[];
    final now = DateTime.now();
    
    for (int i = 0; i < 20; i++) {
      final pinId = 'pin_${_currentPage}_$i';
      final height = 200 + (i % 4) * 100; // Varying heights for masonry effect
      
      samplePins.add(Pin(
        id: pinId,
        title: 'Beautiful Pin ${_currentPage * 20 + i}',
        description: 'This is a sample pin description for testing the masonry layout.',
        imageUrl: 'https://picsum.photos/300/$height?random=$pinId',
        type: PinType.image,
        userId: 'user_$i',
        username: 'user$i',
        userProfileImageUrl: 'https://picsum.photos/50/50?random=user$i',
        width: 300,
        height: height,
        likesCount: (i * 10) + 5,
        commentsCount: i + 2,
        savesCount: (i * 5) + 3,
        createdAt: now.subtract(Duration(days: i)),
        updatedAt: now.subtract(Duration(days: i)),
        tags: ['sample', 'test', 'pinterest'],
        dominantColors: ['#FF6B6B', '#4ECDC4', '#45B7D1'],
      ));
    }
    
    return samplePins;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Pinterest',
        showLogo: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.primaryColor,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            if (_pins.isEmpty && _isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
              )
            else if (_pins.isEmpty && !_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.push_pin_outlined,
                        size: 64,
                        color: AppTheme.grey400,
                      ),
                      SizedBox(height: AppTheme.spacingMedium),
                      Text(
                        'No pins to show',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLarge,
                          color: AppTheme.textSecondary,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingSmall),
                      Text(
                        'Pull to refresh',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeMedium,
                          color: AppTheme.textTertiary,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(AppTheme.spacingSmall),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: AppConstants.gridColumns,
                  mainAxisSpacing: AppTheme.spacingSmall,
                  crossAxisSpacing: AppTheme.spacingSmall,
                  childCount: _pins.length,
                  itemBuilder: (context, index) {
                    return PinCard(
                      pin: _pins[index],
                      onTap: () => _onPinTap(_pins[index]),
                      onSave: () => _onPinSave(_pins[index]),
                      onLike: () => _onPinLike(_pins[index]),
                      onShare: () => _onPinShare(_pins[index]),
                    );
                  },
                ),
              ),
            
            // Loading indicator at bottom
            if (_isLoading && _pins.isNotEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.spacingMedium),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            
            // End of content indicator
            if (!_hasMore && _pins.isNotEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.spacingMedium),
                  child: Center(
                    child: Text(
                      'You\'ve reached the end!',
                      style: TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: AppTheme.fontSizeSmall,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onPinTap(Pin pin) {
    // Navigate to pin detail screen
    Navigator.pushNamed(
      context,
      '/pin_detail',
      arguments: pin,
    );
  }

  void _onPinSave(Pin pin) {
    // Show save to board bottom sheet
    _showSaveToBoardBottomSheet(pin);
  }

  void _onPinLike(Pin pin) {
    // Toggle like status
    setState(() {
      final index = _pins.indexWhere((p) => p.id == pin.id);
      if (index != -1) {
        _pins[index] = pin.copyWith(
          isLiked: !pin.isLiked,
          likesCount: pin.isLiked ? pin.likesCount - 1 : pin.likesCount + 1,
        );
      }
    });
  }

  void _onPinShare(Pin pin) {
    // Show share options
    _showShareBottomSheet(pin);
  }

  void _showSaveToBoardBottomSheet(Pin pin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: AppDecorations.bottomSheetDecoration,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: AppTheme.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(AppTheme.spacingMedium),
              child: Text(
                'Save to board',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLarge,
                  fontWeight: AppTheme.fontWeightSemiBold,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Board selection will be implemented here',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareBottomSheet(Pin pin) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200,
        decoration: AppDecorations.bottomSheetDecoration,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: AppTheme.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(AppTheme.spacingMedium),
              child: Text(
                'Share pin',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLarge,
                  fontWeight: AppTheme.fontWeightSemiBold,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Share options will be implemented here',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}