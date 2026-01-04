import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/favorite_cuisines_api.dart';

class FavoriteCuisinesPage extends StatefulWidget {
  FavoriteCuisinesPage({super.key});

  @override
  State<FavoriteCuisinesPage> createState() => _FavoriteCuisinesPageState();
}

class _FavoriteCuisinesPageState extends State<FavoriteCuisinesPage> {
  bool loading = true;
  final String userId = "1";

  Map<String, bool?> votes = {};

  late List<CuisineItem> items;

  @override
  void initState() {
    super.initState();

    items = [
      CuisineItem(title: "American", keyName: "American", imageUrl: ""),
      CuisineItem(title: "Asian", keyName: "Asian", imageUrl: ""),
      CuisineItem(title: "Chinese", keyName: "Chinese", imageUrl: ""),
      CuisineItem(title: "Indian", keyName: "Indian", imageUrl: ""),
      CuisineItem(title: "Italian", keyName: "Italian", imageUrl: ""),
      CuisineItem(title: "Mexican", keyName: "Mexican", imageUrl: ""),
      CuisineItem(title: "Japanese", keyName: "Japanese", imageUrl: ""),
      CuisineItem(title: "Turkish", keyName: "Turkish", imageUrl: ""),
      CuisineItem(title: "Greek", keyName: "Greek", imageUrl: ""),
      CuisineItem(title: "Middle Eastern", keyName: "Middle Eastern", imageUrl: ""),
    ];

    _init();
  }

  Future<void> _init() async {
    try {
      final liked = await FavoriteCuisinesApi.getCuisines(userId);
      final likedSet = liked.toSet();

      for (final it in items) {
        votes[it.keyName] = likedSet.contains(it.keyName) ? true : null;
      }
    } catch (_) {
      for (final it in items) {
        votes[it.keyName] = null;
      }
    }
    setState(() => loading = false);
  }

  void _vote(String keyName, bool like) {
    setState(() {
      final current = votes[keyName];
      // if pressed same again => clear
      if (current == like) {
        votes[keyName] = null;
      } else {
        votes[keyName] = like;
      }
    });
  }

  Future<void> _save() async {
    final liked = <String>[];
    votes.forEach((k, v) {
      if (v == true) liked.add(k);
    });

    await FavoriteCuisinesApi.saveCuisines(userId, liked);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bg = Colors.blueGrey.shade50;
    final green = Colors.green;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator(color: green))
            : Column(
          children: [
            // Header like screenshot (no AppBar)
            Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    " cuisines you love".tr(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: Text(
                "Tap 👍 if you like it, 👎 if you don’t".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16, 6, 16, 90),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final it = items[i];
                  final v = votes[it.keyName]; // true/false/null

                  return Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: _CuisineCard(
                      title: it.title.tr(),
                      imageUrl: it.imageUrl,
                      liked: v == true,
                      disliked: v == false,
                      onLike: () => _vote(it.keyName, true),
                      onDislike: () => _vote(it.keyName, false),
                    ),
                  );
                },
              ),
            ),

            // Bottom Save fixed
            Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _save,
                  child: Text(
                    "common.save".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
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
}

class CuisineItem {
  CuisineItem({
    required this.title,
    required this.keyName,
    required this.imageUrl,
  });

  final String title;
  final String keyName; // stored in API
  final String imageUrl;
}

class _CuisineCard extends StatelessWidget {
  _CuisineCard({
    required this.title,
    required this.imageUrl,
    required this.liked,
    required this.disliked,
    required this.onLike,
    required this.onDislike,
  });

  final String title;
  final String imageUrl;
  final bool liked;
  final bool disliked;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  Widget build(BuildContext context) {
    final green = Colors.green;

    final likeColor = liked ? green : Colors.black26;
    final dislikeColor = disliked ? Colors.red : Colors.black26;

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 8),
            color: Colors.black12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(18, 18, 10, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        IconButton(
                          onPressed: onDislike,
                          icon: Icon(Icons.thumb_down_alt_outlined),
                          color: dislikeColor,
                          iconSize: 26,
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: onLike,
                          icon: Icon(Icons.thumb_up_alt_outlined),
                          color: likeColor,
                          iconSize: 26,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Right image cropped like screenshot
            SizedBox(
              width: 170,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                  bottomLeft: Radius.circular(120),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
