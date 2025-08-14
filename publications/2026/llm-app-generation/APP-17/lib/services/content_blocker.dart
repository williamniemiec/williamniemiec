import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AdAndTrackerBlocker {
  static final List<ContentBlocker> _blockers = [
    ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: ".*doubleclick\\.net/.*",
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.BLOCK,
      ),
    ),
    ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: ".*google-analytics\\.com/.*",
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.BLOCK,
      ),
    ),
    ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: ".*googlesyndication\\.com/.*",
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.BLOCK,
      ),
    ),
    ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: ".*adservice\\.google\\.com/.*",
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.BLOCK,
      ),
    ),
    ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: ".*facebook\\.net/.*",
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.BLOCK,
      ),
    ),
    ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: ".*connect\\.facebook\\.net/.*",
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.BLOCK,
      ),
    ),
  ];

  static List<ContentBlocker> get blockers => _blockers;
}