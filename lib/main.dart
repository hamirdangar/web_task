import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

void main() {
  ui.platformViewRegistry.registerViewFactory(
    'imageElement',
        (int viewId) {
      final img = html.ImageElement()
        ..id = 'imageElement'
        ..style.width = 'auto'
        ..style.height = 'auto'
        ..style.maxWidth = '80%'
        ..style.maxHeight = '80%'
        ..style.position = 'absolute'
        ..style.left = '50%'
        ..style.top = '50%'
        ..style.transform = 'translate(-50%, -50%)';
      return img;
    },
  );

  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image and the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isMenuOpen = false;

  void _toggleFullScreen() {
    if (html.document.fullscreenElement == null) {
      html.document.documentElement?.requestFullscreen();
    } else {
      html.document.exitFullscreen();
    }
  }

  void _showMenu() {
    setState(() {
      _isMenuOpen = true;
    });
  }

  void _hideMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  void _loadImage() {
    html.document.getElementById('imageElement')?.setAttribute('src', _urlController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onDoubleTap: _toggleFullScreen,
                        child: HtmlElementView(viewType: 'imageElement'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(hintText: 'Image URL'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _loadImage,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
          if (_isMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideMenu,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          Positioned(
            bottom: 80,
            right: 16,
            child: Column(
              children: [
                if (_isMenuOpen)
                  Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          _toggleFullScreen();
                          _hideMenu();
                        },
                        child: Icon(Icons.fullscreen),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: () {
                          html.document.exitFullscreen();
                          _hideMenu();
                        },
                        child: Icon(Icons.fullscreen_exit),
                      ),
                    ],
                  ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _showMenu,
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}