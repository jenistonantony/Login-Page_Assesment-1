import 'package:flutter/foundation.dart';

/// A function signature for event callbacks.
///
/// [eventName]: The name of the event being recorded.
/// [parameters]: Additional metadata about the event.
typedef EventCallback = void Function(String eventName, Map<String, dynamic> parameters);

/// A singleton class for managing and recording app analytics such as page navigations,
/// user actions, screen views, form interactions, custom analytics, and errors.
///
/// The `EventManager` can:
///   - Capture analytics and send them to an external analytics service (if integrated).
///   - Invoke an optional callback to notify the app of captured analytics in real-time.
///   - Log analytics to the debug console (toggleable).
class EventManager {
  /// The private singleton instance.
  static final EventManager _instance = EventManager._internal();

  /// Factory constructor to return the singleton instance.
  factory EventManager() => _instance;

  /// Private internal constructor to prevent direct instantiation.
  EventManager._internal();

  /// Optional callback to notify the app about captured analytics.
  EventCallback? _eventCallback;

  /// When [true], the event details will be printed to the debug console.
  bool _enableLogging = true;

  /// The current user’s identifier (e.g., a user ID or email).
  /// Useful for analytics providers that segment data by user.
  String? _userId;

  /// A session ID that can be used to group a series of analytics together.
  /// For example, you can generate a UUID on app start or login.
  String? _sessionId;

  /// (Optional) A simple queue for storing analytics if you want
  /// to handle them later (e.g., offline caching). This is a
  /// skeleton implementation—commented out for now.
  ///```dart
  /// final List<Map<String, dynamic>> _eventQueue = [];
  ///```

  // --------------------------------------------------------------------------
  // Initialization & Configuration
  // --------------------------------------------------------------------------

  /// Sets an optional event callback to notify the app about captured analytics.
  ///
  /// The [callback] function will be invoked whenever an event is recorded,
  /// providing real-time event data for custom handling.
  void setEventCallback(EventCallback callback) {
    _eventCallback = callback;
  }

  /// Enables or disables printing event details to the debug console.
  ///
  /// When [enable] is true, the debugPrint statement in [_sendEvent] will be active.
  void enableLogging(bool enable) {
    _enableLogging = enable;
  }

  /// Sets or updates the current user identifier for analytics segmentation.
  ///
  /// Example usage: after a user logs in, call `EventManager().setUserId("12345")`.
  void setUserId(String userId) {
    _userId = userId;
  }

  /// Retrieves the current user ID (if any).
  String? get userId => _userId;

  /// Sets or updates the current session identifier. This can be useful
  /// to group analytics within a single user session.
  void setSessionId(String sessionId) {
    _sessionId = sessionId;
  }

  /// Retrieves the current session ID (if any).
  String? get sessionId => _sessionId;

  // --------------------------------------------------------------------------
  // Public API for Recording Events
  // --------------------------------------------------------------------------

  /// Records a page navigation event, indicating the user navigated to a specific page.
  ///
  /// [pageName]: The name of the page being navigated to (e.g., 'HomePage').
  /// [parameters]: Optional additional metadata (e.g., navigation source).
  void recordPageNavigation(String pageName, {Map<String, dynamic>? parameters}) {
    if (pageName.isEmpty) return; // Avoid logging empty page names
    _sendEvent('page_navigation', {
      'page_name': pageName,
      ...?parameters,
    });
  }

  /// Records a screen view event, typically used in analytics to track screen impressions.
  ///
  /// [screenName]: The name of the screen being viewed.
  /// [parameters]: Optional additional metadata (e.g., time spent, referrer).
  void recordScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    if (screenName.isEmpty) return; // Avoid logging empty screen names
    _sendEvent('screen_view', {
      'screen_name': screenName,
      ...?parameters,
    });
  }

  /// Records a user action event, such as button clicks or item selections.
  ///
  /// [actionName]: The name of the user action (e.g., 'button_click').
  /// [parameters]: Optional additional metadata (e.g., button ID, location in UI).
  void recordUserAction(String actionName, {Map<String, dynamic>? parameters}) {
    if (actionName.isEmpty) return; // Avoid logging empty action names
    _sendEvent('user_action', {
      'action_name': actionName,
      ...?parameters,
    });
  }

  /// Records a form interaction event, commonly used to track form submissions or cancellations.
  ///
  /// [formName]: The name of the form (e.g., 'login_form').
  /// [interactionType]: The type of interaction (e.g., 'form_submit', 'form_cancel').
  /// [parameters]: Optional additional metadata (e.g., validation errors, time to complete).
  void recordFormInteraction(
      String formName,
      String interactionType, {
        Map<String, dynamic>? parameters,
      }) {
    if (formName.isEmpty || interactionType.isEmpty) return;
    _sendEvent('form_interaction', {
      'form_name': formName,
      'interaction_type': interactionType,
      ...?parameters,
    });
  }

  /// Records an error event, which can be useful for analytics and debugging.
  ///
  /// [errorMessage]: A human-readable error message or code.
  /// [parameters]: Optional additional metadata (e.g., stack trace, severity level).
  void recordError(String errorMessage, {Map<String, dynamic>? parameters}) {
    if (errorMessage.isEmpty) return;
    _sendEvent('error_event', {
      'error_message': errorMessage,
      ...?parameters,
    });
  }

  /// Records a custom event of your choosing.
  ///
  /// [eventName]: The name of the custom event (e.g., 'tutorial_complete', 'purchase_made').
  /// [parameters]: Optional additional metadata specific to this event.
  void recordCustomEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (eventName.isEmpty) return;
    _sendEvent(eventName, parameters ?? {});
  }

  // --------------------------------------------------------------------------
  // Internal Logic
  // --------------------------------------------------------------------------

  /// Internal method to handle sending analytics and invoking the callback.
  ///
  /// This method:
  ///   1) Merges base parameters like [userId] and [sessionId].
  ///   2) Invokes the optional [_eventCallback] with the event details.
  ///   3) Prints event details to the debug console if [_enableLogging] is true.
  ///
  /// In a real app, you might also forward analytics to a third-party service
  /// (e.g., Firebase Analytics, Mixpanel, etc.) here.
  void _sendEvent(String eventName, Map<String, dynamic> parameters) {
    // Merge base parameters like userId and sessionId
    final mergedParams = {
      'user_id': _userId ?? '',
      'session_id': _sessionId ?? '',
      ...parameters,
    };

    // Invoke the event callback, if set
    _eventCallback?.call(eventName, mergedParams);

    // Uncomment this block to queue analytics for offline or deferred processing:
    ///_eventQueue.add({
    ///  'event_name': eventName,
    ///  'parameters': mergedParams,
    ///  'timestamp': DateTime.now().toIso8601String(),
    ///});

    // Optionally log event details to the debug console
    if (_enableLogging) {
      debugPrint('Event recorded: $eventName, Parameters: $mergedParams');
    }
  }
}
