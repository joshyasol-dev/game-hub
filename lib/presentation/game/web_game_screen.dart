import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebGameScreen extends StatefulWidget {
  final String? backgroundImage;
  final String? loadingIcon;
  final String? customUrl;

  const WebGameScreen({
    super.key,
    this.backgroundImage,
    this.loadingIcon,
    this.customUrl,
  });

  @override
  State<WebGameScreen> createState() => _WebGameScreenState();
}

class _WebGameScreenState extends State<WebGameScreen> {
  static const String _lanGameUrl = 'http://10.80.4.28:5175/';
  static const String _emulatorGameUrl = 'http://10.0.2.2:5175/#/';
  WebViewController? _controller;
  int _progress = 0;
  bool _isLoading = true;
  String? _lastError;
  late String _currentUrl;
  bool get _isSupportedPlatform => Platform.isAndroid || Platform.isIOS;

  /// Get the dynamic URL - prefer custom, fallback to LAN, then emulator
  String _getGameUrl() {
    if (widget.customUrl != null && widget.customUrl!.isNotEmpty) {
      return widget.customUrl!;
    }
    return _lanGameUrl;
  }

  @override
  void initState() {
    super.initState();
    _currentUrl = _getGameUrl();
    if (_isSupportedPlatform) {
      _initializeWebView();
      _setPortraitFullscreen();
    }
  }

  /// Initialize WebView with optimized loading handlers
  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _handlePageStarted(),
          onProgress: (progress) => _handleProgress(progress),
          onPageFinished: (_) => _handlePageFinished(),
          onWebResourceError: (error) => _handleWebResourceError(error),
        ),
      )
      ..loadRequest(Uri.parse(_currentUrl));
  }

  /// Handle page started event
  void _handlePageStarted() {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _lastError = null;
      _progress = 0;
    });
  }

  /// Handle progress update
  void _handleProgress(int progress) {
    if (!mounted) return;
    setState(() {
      _progress = progress;
    });
  }

  /// Handle page finished loading
  void _handlePageFinished() {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _progress = 100;
    });
  }

  /// Handle web resource errors
  void _handleWebResourceError(WebResourceError error) {
    if (!mounted) return;
    if (error.isForMainFrame != true) return;
    setState(() {
      _isLoading = false;
      _lastError =
          'Error ${error.errorCode}: ${error.description} (${error.errorType?.name ?? 'unknown'})';
    });
  }

  bool _shouldUseLandscape() {
    return widget.loadingIcon?.contains('tekhen') ?? false;
  }

  Future<void> _setPortraitFullscreen() async {
    final isLandscape = _shouldUseLandscape();
    final orientations = isLandscape
        ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];

    await SystemChrome.setPreferredOrientations(orientations);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _restorePortraitMode() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _exitWebView() async {
    await _restorePortraitMode();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _reloadCurrentUrl() async {
    if (_controller == null) return;
    setState(() {
      _lastError = null;
      _isLoading = true;
      _progress = 0;
    });
    await _controller!.loadRequest(Uri.parse(_currentUrl));
  }

  Future<void> _switchToEmulatorUrl() async {
    _currentUrl = _emulatorGameUrl;
    await _reloadCurrentUrl();
  }

  @override
  void dispose() {
    _restorePortraitMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _controller == null
                ? const Center(
                    child: Text('WebView is only supported on Android/iOS.'),
                  )
                : WebViewWidget(
                    controller: _controller!,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        EagerGestureRecognizer.new,
                      ),
                    },
                  ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: IgnorePointer(
                child: _LoadingScreen(
                  backgroundImage:
                      widget.backgroundImage ?? 'assets/images/hammer_bg.png',
                  icon: widget.loadingIcon!.isNotEmpty
                      ? widget.loadingIcon!
                      : 'assets/icons/bf_icon.png',
                  progress: _progress,
                ),
              ),
            ),
          if (_lastError != null)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _lastError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current URL: $_currentUrl',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _reloadCurrentUrl,
                          child: const Text('Retry'),
                        ),
                        if (Platform.isAndroid &&
                            _currentUrl != _emulatorGameUrl)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: OutlinedButton(
                              onPressed: _switchToEmulatorUrl,
                              child: const Text('Use emulator URL (10.0.2.2)'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_isLoading)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: LinearProgressIndicator(value: _progress / 100),
            ),
          Positioned(
            top: topPadding + 8,
            left: 12,
            child: Material(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(999),
              child: IconButton(
                tooltip: 'Exit',
                onPressed: _exitWebView,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom loading screen widget with background image, icon, and loading text
class _LoadingScreen extends StatelessWidget {
  final String backgroundImage;
  final String icon;
  final int progress;

  const _LoadingScreen({
    required this.backgroundImage,
    required this.icon,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image with dark overlay
        _buildBackgroundImage(),
        // Loading content
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: icon.contains('https')
                      ? Image.network(icon, height: 64)
                      : Image.asset(icon, height: 64),
                ),
                const SizedBox(height: 24),
                // Loading text
                const Text(
                  'Loading game',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'please wait...',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Progress indicator with percentage
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          minHeight: 8,
                          backgroundColor: Colors.white30,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$progress%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build background image with overlay
  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black54, // Semi-transparent dark overlay
      ),
    );
  }
}
