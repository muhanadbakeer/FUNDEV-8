import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:div/screens/auth/SplashView.dart';
import 'package:div/screens/home/HistoryPage.dart';
import 'package:div/screens/home/MealPlanPage.dart';
import 'package:div/screens/home/NotificationsPage.dart';
import 'package:div/screens/home/home/SETTINGS/SettingsPage.dart';
import '../ profile/profile.dart';
import '../../core/uite/recipe_filter.dart';
import 'FiltersPage.dart';

class RecipesApi {
  RecipesApi({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _u(String path) => Uri.parse('$baseUrl$path');

  Future<List<int>> getFavoriteIds(String userId) async {
    final res = await _client.get(_u('/api/recipes/favorites/$userId'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Favorites GET failed: ${res.statusCode} ${res.body}');
    }

    final data = jsonDecode(res.body);

    if (data is List) {
      if (data.isEmpty) return [];
      if (data.first is int) {
        return data.cast<int>();
      }
      if (data.first is Map) {
        return data
            .map<int>((e) => (e['id'] ?? e['recipeId'] ?? 0) as int)
            .where((id) => id > 0)
            .toList();
      }
    }
    return [];
  }

  Future<void> addFavorite(String userId, int recipeId) async {
    final res = await _client.post(_u('/api/recipes/favorites/$userId/$recipeId'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Favorites POST failed: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> removeFavorite(String userId, int recipeId) async {
    final res = await _client.delete(_u('/api/recipes/favorites/$userId/$recipeId'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Favorites DELETE failed: ${res.statusCode} ${res.body}');
    }
  }
}

class RecipeItem {
  RecipeItem({
    required this.id,
    required this.title,
    required this.minutes,
    required this.imageUrl,
    required this.isPro,
    required this.isFav,
  });

  final int id;
  final String title;
  final int minutes;
  final String imageUrl;
  final bool isPro;
  final bool isFav;

  RecipeItem copyWith({
    int? id,
    String? title,
    int? minutes,
    String? imageUrl,
    bool? isPro,
    bool? isFav,
  }) {
    return RecipeItem(
      id: id ?? this.id,
      title: title ?? this.title,
      minutes: minutes ?? this.minutes,
      imageUrl: imageUrl ?? this.imageUrl,
      isPro: isPro ?? this.isPro,
      isFav: isFav ?? this.isFav,
    );
  }
}

class RecipesState {
  RecipesState({
    required this.loading,
    required this.error,
    required this.userId,
    required this.search,
    required this.filterCount,
    required this.explore,
    required this.favorites,
    required this.ratings,
  });

  final bool loading;
  final String? error;

  final String userId;

  final String search;
  final int filterCount;

  final List<RecipeItem> explore;
  final List<RecipeItem> favorites;
  final List<RecipeItem> ratings;

  RecipesState copyWith({
    bool? loading,
    String? error,
    String? userId,
    String? search,
    int? filterCount,
    List<RecipeItem>? explore,
    List<RecipeItem>? favorites,
    List<RecipeItem>? ratings,
  }) {
    return RecipesState(
      loading: loading ?? this.loading,
      error: error,
      userId: userId ?? this.userId,
      search: search ?? this.search,
      filterCount: filterCount ?? this.filterCount,
      explore: explore ?? this.explore,
      favorites: favorites ?? this.favorites,
      ratings: ratings ?? this.ratings,
    );
  }

  static RecipesState initial({required String userId}) {
    return RecipesState(
      loading: false,
      error: null,
      userId: userId,
      search: '',
      filterCount: 3,
      explore: [],
      favorites: [],
      ratings: [],
    );
  }
}

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit({
    required this.api,
    required String userId,
  }) : super(RecipesState.initial(userId: userId));

  final RecipesApi api;

  void init() async {
    emit(state.copyWith(loading: true, error: null));

    final explore = _RecipeData.buildExplore();

    try {
      final favIds = await api.getFavoriteIds(state.userId);

      final newExplore = explore.map((r) {
        final isFav = favIds.contains(r.id);
        return r.copyWith(isFav: isFav);
      }).toList();

      final favorites = newExplore.where((x) => x.isFav).toList();

      emit(state.copyWith(
        loading: false,
        error: null,
        explore: newExplore,
        favorites: favorites,
        ratings: [],
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
        explore: explore,
        favorites: explore.where((x) => x.isFav).toList(),
        ratings: [],
      ));
    }
  }

  void setSearch(String value) {
    emit(state.copyWith(search: value));
  }

  void clearFilters() {
    emit(state.copyWith(filterCount: 0));
  }

  void applyFilters() {
    emit(state.copyWith(filterCount: 3));
  }

  List<RecipeItem> _applySearch(List<RecipeItem> list) {
    final q = state.search.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((e) => e.title.toLowerCase().contains(q)).toList();
  }

  List<RecipeItem> exploredFiltered() => _applySearch(state.explore);
  List<RecipeItem> favoritesFiltered() => _applySearch(state.favorites);
  List<RecipeItem> ratingsFiltered() => _applySearch(state.ratings);

  Future<void> toggleFavorite(RecipeItem item) async {
    final newIsFav = !item.isFav;

    final newExplore = state.explore.map((r) {
      if (r.id == item.id) return r.copyWith(isFav: newIsFav);
      return r;
    }).toList();

    final newFavorites = newExplore.where((x) => x.isFav).toList();

    emit(state.copyWith(
      explore: newExplore,
      favorites: newFavorites,
      error: null,
    ));

    try {
      if (newIsFav) {
        await api.addFavorite(state.userId, item.id);
      } else {
        await api.removeFavorite(state.userId, item.id);
      }
    } catch (e) {
      final rollbackExplore = state.explore.map((r) {
        if (r.id == item.id) return r.copyWith(isFav: !newIsFav);
        return r;
      }).toList();

      final rollbackFav = rollbackExplore.where((x) => x.isFav).toList();

      emit(state.copyWith(
        explore: rollbackExplore,
        favorites: rollbackFav,
        error: e.toString(),
      ));
    }
  }
}

class RecipesExplorePage extends StatefulWidget {
  RecipesExplorePage({super.key});

  @override
  State<RecipesExplorePage> createState() => _RecipesExplorePageState();
}

class _RecipesExplorePageState extends State<RecipesExplorePage> {
  final TextEditingController search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = "1";
    final api = RecipesApi(baseUrl: "http://10.0.2.2:5172");

    return BlocProvider(
      create: (_) => RecipesCubit(api: api, userId: userId)..init(),
      child: BlocBuilder<RecipesCubit, RecipesState>(
        builder: (context, state) {
          final cubit = context.read<RecipesCubit>();
          final green = Colors.green;

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 2,
                centerTitle: true,
                title: Text(
                  "DIV Nutrition".tr(),
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                actions: [
                  IconButton(
                    tooltip: "notifications.title".tr(),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsPage()));
                    },
                    icon: Icon(Icons.notifications_none),
                  ),
                  IconButton(
                    tooltip: "Profile".tr(),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => items_mode()));
                    },
                    icon: Icon(Icons.person_outline),
                  ),
                ],
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: TextStyle(fontWeight: FontWeight.w700),
                  tabs: [
                    Tab(text: "Explore".tr()),
                    Tab(text: "Favorites".tr()),
                    Tab(text: "Ratings".tr()),
                  ],
                ),
              ),
              drawer: Drawer(
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: green),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.restaurant, color: green, size: 28),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "DIV Nutrition".tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text("Quick navigation".tr(), style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            _drawerItem(
                              icon: Icons.settings,
                              title: "settings.title".tr(),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()));
                              },
                            ),
                            _drawerItem(
                              icon: Icons.list_alt,
                              title: "history.title".tr(),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryPage()));
                              },
                            ),
                            _drawerItem(
                              icon: Icons.grid_view_rounded,
                              title: "navigation.mealPlan".tr(),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => MealPlanIntroPage()));
                              },
                            ),
                            Divider(height: 24),
                            _drawerItem(
                              icon: Icons.logout,
                              title: "settings.logout".tr(),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => SplashView()),
                                      (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  if (state.error != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      margin: EdgeInsets.fromLTRB(16, 12, 16, 0),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Text(
                        "API Error: ${state.error}",
                        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 14, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: search,
                            onChanged: (v) => cubit.setSearch(v),
                            decoration: InputDecoration(
                              hintText: "Search recipes".tr(),
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        InkWell(
                          onTap: () async {
                            await Navigator.push<RecipeFiltersSelection>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FiltersPage(
                                  initial:  RecipeFiltersSelection(),
                                  totalRecipesCount: 349,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 52,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: green,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(Icons.tune, color: Colors.white),
                              ),
                              if (state.filterCount > 0)
                                Positioned(
                                  top: -8,
                                  left: -8,
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreenAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      "${state.filterCount}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        TabBarView(
                          children: [
                            _RecipesGrid(
                              items: cubit.exploredFiltered(),
                              showImportCard: true,
                              onImportTap: () {},
                              onRecipeTap: (item) {},
                              onFavTap: (item) => cubit.toggleFavorite(item),
                            ),
                            _RecipesGrid(
                              items: cubit.favoritesFiltered(),
                              showImportCard: false,
                              emptyText: "No favorites yet".tr(),
                              onImportTap: () {},
                              onRecipeTap: (item) {},
                              onFavTap: (item) => cubit.toggleFavorite(item),
                            ),
                            _RecipesGrid(
                              items: cubit.ratingsFiltered(),
                              showImportCard: false,
                              emptyText: "No ratings yet".tr(),
                              onImportTap: () {},
                              onRecipeTap: (item) {},
                              onFavTap: (item) => cubit.toggleFavorite(item),
                            ),
                          ],
                        ),
                        if (state.loading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.03),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void _openFilters(BuildContext context, Color green, RecipesCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Filters".tr(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      cubit.clearFilters();
                    },
                    child: Text("Clear".tr(), style: TextStyle(color: green)),
                  )
                ],
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    cubit.applyFilters();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "common.apply".tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterTile({required String title}) {
    return ListTile(
      leading: Icon(Icons.check_box_outline_blank, color: Colors.green),
      title: Text(title),
      onTap: () {},
      contentPadding: EdgeInsets.zero,
    );
  }
}

Widget _drawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.green),
    title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
    onTap: onTap,
  );
}

class _RecipesGrid extends StatelessWidget {
  _RecipesGrid({
    required this.items,
    required this.onImportTap,
    required this.onRecipeTap,
    required this.onFavTap,
    this.showImportCard = true,
    this.emptyText,
  });

  final List<RecipeItem> items;
  final VoidCallback onImportTap;
  final void Function(RecipeItem item) onRecipeTap;
  final void Function(RecipeItem item) onFavTap;
  final bool showImportCard;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (showImportCard) {
      children.add(_ImportCard(onTap: onImportTap));
    }

    for (final item in items) {
      children.add(
        _RecipeCard(
          item: item,
          onTap: () => onRecipeTap(item),
          onFavTap: () => onFavTap(item),
        ),
      );
    }

    if (children.isEmpty) {
      return Center(
        child: Text(
          emptyText ?? "No items".tr(),
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return GridView.count(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: children,
    );
  }
}

class _ImportCard extends StatelessWidget {
  _ImportCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Import Recipe".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 10),
            Icon(Icons.add, size: 28, color: Colors.green),
            SizedBox(height: 10),
            Text(
              "From link, text, or photos".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  _RecipeCard({
    required this.item,
    required this.onTap,
    required this.onFavTap,
  });

  final RecipeItem item;
  final VoidCallback onTap;
  final VoidCallback onFavTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Colors.black12,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(item.imageUrl, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: onFavTap,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        item.isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              if (item.isPro)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "PRO",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                  ),
                ),
              Positioned(
                bottom: 44,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${item.minutes} min",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================= LOCAL DATA =========================
class _RecipeData {
  static List<RecipeItem> buildExplore() {
    final titles = [
      "Shirataki Stir-Fry Noodles",
      "Roasted Asparagus",
      "Herb Grilled Atlantic Salmon",
      "Protein Salad",
      "Greek Yogurt Bowl",
      "Chicken & Veggie Plate",
      "Overnight Oats",
      "Healthy Rice Bowl",
      "Avocado Toast",
      "Fresh Green Salad",
      "Tuna Salad Wrap",
      "Egg & Spinach Omelet",
      "Grilled Chicken Breast",
      "Baked Sweet Potato",
      "Beef & Broccoli",
      "Turkey Sandwich",
      "Quinoa Veggie Bowl",
      "Lentil Soup",
      "Oat Pancakes",
      "Chia Pudding",
      "Shrimp Stir-Fry",
      "Salmon Rice Bowl",
      "Cottage Cheese Plate",
      "Roasted Veggies Mix",
      "Chicken Caesar Salad",
      "Brown Rice & Beans",
      "Zucchini Noodles",
      "Tomato Basil Salad",
      "Chicken Wrap",
      "Air-Fryer Potatoes",
      "Veggie Omelet",
      "Grilled Steak Bites",
      "Mediterranean Bowl",
      "Yogurt & Berries",
      "Apple Cinnamon Oats",
      "Light Pasta Bowl",
      "Baked Cod Plate",
      "Chicken Soup",
      "Low-Cal Sandwich",
      "High-Protein Breakfast",
      "Veggie Snack Box",
      "Egg Salad",
      "Tuna Bowl",
      "Beef Salad",
      "Chicken Bowl",
      "Green Smoothie Bowl",
      "Oatmeal Power Bowl",
      "Simple Meal Prep Box",
      "Healthy Snack Plate",
      "Chicken & Rice",
      "Salmon & Greens",
      "Eggs & Avocado",
      "Lean Beef Bowl",
      "Veggie Soup",
      "Protein Lunch Box"
    ];

    final list = <RecipeItem>[];

    for (int i = 0; i < titles.length; i++) {
      final minutes = 10 + (i % 25);
      final pro = (i % 7 == 0);
      final img = "https://picsum.photos/seed/recipe_$i/600/600";

      list.add(
        RecipeItem(
          id: i + 1,
          title: titles[i],
          minutes: minutes,
          imageUrl: img,
          isPro: pro,
          isFav: false,
        ),
      );
    }
    return list;
  }
}
