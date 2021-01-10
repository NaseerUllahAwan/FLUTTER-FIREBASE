Sir, I have removed the 'dark and light theme' and 'add to favourite' and 'bottomnavigationbar' functionality from the wallpaper app.
  I only want to show both categories wallpapers and all images on a single page. The main.dart file is causing issues.



//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:carousel_slider/carousel_controller.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
//import 'package:provider/provider.dart';
import 'package:thisbestthatwallpaperapp/all_images.dart';
//import 'package:thisbestthatwallpaperapp/carouselDots.dart';
// import 'package:thisbestthatwallpaperapp/constants.dart';
//import 'package:thisbestthatwallpaperapp/fav.dart';
import 'package:thisbestthatwallpaperapp/home.dart';
import 'package:thisbestthatwallpaperapp/models/wallpaper.dart';
//import 'package:thisbestthatwallpaperapp/wallpaper_gallery.dart';
//import 'package:thisbestthatwallpaperapp/providers/fav_wallpaper_manager.dart';
// import 'package:thisbestthatwallpaperapp/theme_manager.dart';

Future<void> main() async {
  // await _initApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ExtraConnectivityfordarktheme());
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

class ExtraConnectivityfordarktheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Freelancing Websites App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'That Wallpaper App!',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pageController = PageController(initialPage: 1);
  int currentSelected = 1;
  int _current = 0;
  final categories = List<String>();
  final categoryImages = List<String>();
  var wallpapersList = List<Wallpaper>();

  @override
  void initState() {
    super.initState();

    wallpapersList.forEach(
      (wallpaper) {
        var category = wallpaper.category;

        if (!categories.contains(category)) {
          categories.add(category);
          categoryImages.add(wallpaper.url);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
     final CarouselController carouselController = CarouselController();
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
////////////////////////////////////////////////////////////////////////////
            return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) =>
                      <Widget>[
                    SliverAppBar(
                        primary: false,
                        backgroundColor: Theme.of(context).primaryColor,
                        automaticallyImplyLeading: false,
                        titleSpacing: 0,
                        expandedHeight: 200,
                        flexibleSpace: SizedBox(
                          child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 5),
                                  child: CarouselSlider.builder(
                                    carouselController: carouselController,
                                    itemCount: categories.length,
                                    options: CarouselOptions(
                                        height: 200,
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        onPageChanged: (index, reason) {
                                          if (mounted) {
                                            setState(() {
                                              _current = index;
                                            });
                                          }
                                        }),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child: CategoriesTile(
                                          imgUrls:
                                              categoryImages.elementAt(index),
                                          // imgUrls: categories[index].imgUrl,
                                          // categorie:
                                          //     categories[index].categorieName,

                                          categorie: categories
                                              .elementAt(index)
                                              .toUpperCase(),
                                          categoryview: //                 category:
                                              categories.elementAt(index),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                CarouselDots(current: _current),
                              ]),
                        ))
                  ],
                  body: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            child: Text('Naseer'),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          GridView.builder(
                            physics: ClampingScrollPhysics(),
                            // physics: const BouncingScrollPhysics(
                            //     parent: AlwaysScrollableScrollPhysics()),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 6.0,
                              crossAxisSpacing: 6.0,
                              //childAspectRatio: 0.6,
                              // childAspectRatio: MediaQuery.of(context).size.width /
                              //     (MediaQuery.of(context).size.height / 1.4),
                              //childAspectRatio: 0.8,
                              childAspectRatio: 6 / 4,
                            ),
                            itemCount: wallpapersList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Hero(
                                    tag: wallpapersList.elementAt(index).url,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CachedNetworkImage(
                                          imageUrl: wallpapersList
                                              .elementAt(index)
                                              .url,
                                          fit: BoxFit.cover,
                                          placeholder: (context, value) {
                                            return Container(
                                                // child: Center(
                                                //   // child: SpinKitRipple(
                                                //   //   color: Colors.white,
                                                //   //   size: 50.0,
                                                //   // ),
                                                // ),
                                                // color: Colors.grey[800],
                                                // color: Colors.yellow,
                                                );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.3),
                                        highlightColor: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.1),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return WallpaperGallery(
                                                  wallpaperList: wallpapersList,
                                                  initialPage: index,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ));

//////////////////////////////////////////////////////////////////////////////
            //return _getPageAtIndex(wallpapersList);
      //       return PageView.builder(
      //         scrollDirection: Axis.horizontal,
      //         controller: pageController,
      //         itemCount: 2,
      //         itemBuilder: (BuildContext context, int index) {
      //           return _getPageAtIndex(index, wallpapersList);
      //         },
      //         onPageChanged: (int index) {
      //           setState(() {
      //             currentSelected = index;
      //           });
      //         },
      //       );
      //     } else {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
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

// Widget _getPageAtIndex(List<Wallpaper> wallpaperList) {
//   return SingleChildScrollView(
//     child: Container(
//       child: Column(
//         children: [
//           Expanded(
//             child: Home(
//               wallpapersList: wallpaperList,
//             ),
//           ),
//           Expanded(
//             child: AllImages(
//               wallpapersList: wallpaperList,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _getPageAtIndex(int index, List<Wallpaper> wallpaperList) {
//   switch (index) {
//     case 0:
//       return AllImages(
//         wallpapersList: wallpaperList,
//       );
//       break;
//     case 1:
//       return Home(
//         wallpapersList: wallpaperList,
//       );
//       break;
//     // case 2:
//     //   return Favorite(
//     //     wallpapersList: wallpaperList,
//     //   );
//     //   break;
//     default:
//       // Should never get hit.
//       return CircularProgressIndicator();
//       break;
//   }
// }


class CategoriesTile extends StatelessWidget {
  final String imgUrls, categorie, categoryview;

  CategoriesTile(
      {@required this.imgUrls, @required this.categorie, this.categoryview});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: imgUrls,
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              placeholder: (context, value) {
                return Container(
                  child: Center(
                      // child: SpinKitWave(
                      //   color: Colors.blue,
                      //   // size: 50.0,
                      // ),
                      ),
                  // color: Colors.grey[800],
                  // color: Colors.yellow,
                );
              },
            )),
        Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Text(
              categorie,
              style: TextStyle(
                letterSpacing: 7,
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w700,
                fontFamily: 'Overpass',
                decoration: TextDecoration.combine(
                  [
                    TextDecoration.underline,
                    TextDecoration.overline,
                  ],
                ),
                decorationStyle: TextDecorationStyle.double,
              ),
            )),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Theme.of(context).accentColor.withOpacity(0.3),
              highlightColor: Theme.of(context).accentColor.withOpacity(0.1),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CategoryWallpapers(
                        category: categoryview,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
