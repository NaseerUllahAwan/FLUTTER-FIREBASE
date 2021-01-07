Sir, I have removed the 'dark theme and light theme' and 'add to favourite' and 'bbottomnavigationbar' functionality from the wallpaper app.
  I only want to show both categories wallpapers and all images on a single page. The main.dart file is causing issues.



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
//import 'package:provider/provider.dart';
import 'package:thisbestthatwallpaperapp/all_images.dart';
// import 'package:thisbestthatwallpaperapp/constants.dart';
//import 'package:thisbestthatwallpaperapp/fav.dart';
import 'package:thisbestthatwallpaperapp/home.dart';
import 'package:thisbestthatwallpaperapp/models/wallpaper.dart';
//import 'package:thisbestthatwallpaperapp/providers/fav_wallpaper_manager.dart';
// import 'package:thisbestthatwallpaperapp/theme_manager.dart';

Future<void> main() async {
  // await _initApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyHomePage(
    title: 'That Wallpaper App!',
  ));
}

// Future _initApp() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   var docDir = await getApplicationDocumentsDirectory();
//   Hive.init(docDir.path);

//   var favBox = await Hive.openBox(FAV_BOX);
//   if (favBox.get(FAV_LIST_KEY) == null) {
//     favBox.put(FAV_LIST_KEY, List<dynamic>());
//   }

//   var settings = await Hive.openBox(SETTINGS);
//   if (settings.get(DARK_THEME_KEY) == null) {
//     settings.put(DARK_THEME_KEY, false);
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pageController = PageController(initialPage: 1);
  int currentSelected = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData.light(),
      home: _buildScaffold(),
    );
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_5),
            onPressed: () {
              // if (ThemeManager.notifier.value == ThemeMode.dark) {
              //   ThemeManager.setTheme(ThemeMode.light);
              // } else {
              //   ThemeManager.setTheme(ThemeMode.dark);
              // }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('wallpapersnaseer')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
            var wallpapersList = List<Wallpaper>();
            // var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

            snapshot.data.docs.forEach((documentSnapshot) {
              var wallpaper = Wallpaper.fromDocumentSnapshot(documentSnapshot);

              // if (favWallpaperManager.isFavorite(wallpaper)) {
              //   wallpaper.isFavorite = true;
              // }

              wallpapersList.add(wallpaper);
            });
            return _getPageAtIndex(wallpapersList);
            // return PageView.builder(
            //   controller: pageController,
            //   itemCount: 2,
            //   itemBuilder: (BuildContext context, int index) {
            //     return _getPageAtIndex(index, wallpapersList);
            //   },
            //   onPageChanged: (int index) {
            //     setState(() {
            //       currentSelected = index;
            //     });
            //   },
            // );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // BottomNavigationBar _buildBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     currentIndex: currentSelected,
  //     items: [
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.image),
  //         label: 'All Images',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.home),
  //         label: 'Home',
  //       ),
  //       // BottomNavigationBarItem(
  //       //   icon: Icon(Icons.favorite),
  //       //   label: 'Favorites',
  //       // ),
  //     ],
  //     onTap: (int index) {
  //       setState(() {
  //         currentSelected = index;
  //         if (pageController.hasClients) {
  //           pageController.animateToPage(
  //             currentSelected,
  //             curve: Curves.fastOutSlowIn,
  //             duration: Duration(milliseconds: 400),
  //           );
  //         }
  //       });
  //     },
  //   );
  // }

  Widget _getPageAtIndex(
    List<Wallpaper> wallpaperList,
  ) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Home(
                wallpapersList: wallpaperList,
              ),
            ),
            Expanded(
              child: AllImages(
                wallpapersList: wallpaperList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
