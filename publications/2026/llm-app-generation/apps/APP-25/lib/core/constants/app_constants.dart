class AppConstants {
  // App Info
  static const String appName = 'Reddit';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://www.reddit.com/api/v1';
  static const String oauthUrl = 'https://oauth.reddit.com';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String savedPostsKey = 'saved_posts';
  static const String subscriptionsKey = 'subscriptions';
  static const String themeKey = 'theme_mode';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 2.0;
  
  // Post Constants
  static const int maxPostTitleLength = 300;
  static const int maxCommentLength = 10000;
  static const int postsPerPage = 25;
  
  // Vote Constants
  static const String upvote = 'upvote';
  static const String downvote = 'downvote';
  static const String unvote = 'unvote';
  
  // Post Types
  static const String textPost = 'text';
  static const String imagePost = 'image';
  static const String linkPost = 'link';
  static const String videoPost = 'video';
  static const String pollPost = 'poll';
  
  // Sort Types
  static const String sortHot = 'hot';
  static const String sortNew = 'new';
  static const String sortTop = 'top';
  static const String sortRising = 'rising';
  static const String sortControversial = 'controversial';
  
  // Time Periods
  static const String timeHour = 'hour';
  static const String timeDay = 'day';
  static const String timeWeek = 'week';
  static const String timeMonth = 'month';
  static const String timeYear = 'year';
  static const String timeAll = 'all';
  
  // Default Subreddits
  static const List<String> defaultSubreddits = [
    'popular',
    'all',
    'askreddit',
    'funny',
    'todayilearned',
    'worldnews',
    'pics',
    'gaming',
    'movies',
    'music',
    'books',
    'science',
    'technology',
    'programming',
  ];
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String authError = 'Authentication failed. Please login again.';
  static const String notFoundError = 'Content not found.';
  static const String genericError = 'Something went wrong. Please try again.';
  
  // Success Messages
  static const String postCreated = 'Post created successfully!';
  static const String commentAdded = 'Comment added successfully!';
  static const String postSaved = 'Post saved!';
  static const String postUnsaved = 'Post removed from saved!';
  static const String subredditJoined = 'Joined community!';
  static const String subredditLeft = 'Left community!';
}

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String create = '/create';
  static const String chat = '/chat';
  static const String inbox = '/inbox';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String register = '/register';
  static const String postDetail = '/post/:postId';
  static const String subreddit = '/r/:subredditName';
  static const String userProfile = '/u/:username';
  static const String settings = '/settings';
  static const String search = '/search';
}

class AppImages {
  static const String logo = 'assets/images/reddit_logo.png';
  static const String snooDefault = 'assets/images/snoo_default.png';
  static const String placeholder = 'assets/images/placeholder.png';
  static const String noImage = 'assets/images/no_image.png';
}

class AppIcons {
  static const String upvote = 'assets/icons/upvote.svg';
  static const String downvote = 'assets/icons/downvote.svg';
  static const String comment = 'assets/icons/comment.svg';
  static const String share = 'assets/icons/share.svg';
  static const String save = 'assets/icons/save.svg';
  static const String award = 'assets/icons/award.svg';
}