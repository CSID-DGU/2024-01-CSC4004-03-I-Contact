import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/models/favorite_model.dart';
import 'package:leftover_is_over_customer/models/order_model.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';
import 'package:leftover_is_over_customer/models/food_model.dart';
import 'package:leftover_is_over_customer/services/favorite_services.dart';
import 'package:leftover_is_over_customer/services/order_services.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';
import 'package:leftover_is_over_customer/services/food_services.dart';
import 'package:leftover_is_over_customer/widgets/menu_widget.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'cart_screen.dart';
import 'dart:convert';
import 'dart:async';

class RestaurantScreen extends StatefulWidget {
  final int storeId;

  const RestaurantScreen({super.key, required this.storeId});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  late Future<Map<String, dynamic>> _futureData;
  late StreamController<List<FoodModel>> _foodStreamController;
  bool isFavorite = false;
  int numServings = 1;

  List<FoodOrder> foodOrders = [];
  List<String> nameList = [];
  List<int> priceList = [];

  StompClient? stompClient;

  void addOrder(int foodId, int count, String foodName, int foodPrice) {
    foodOrders.add(FoodOrder(foodId: foodId, count: count));
    nameList.add(foodName);
    priceList.add(foodPrice);
  }

  @override
  void initState() {
    super.initState();
    _futureData = _fetchData();
    _foodStreamController = StreamController<List<FoodModel>>();
    _checkIfFavorite();
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url:
            'http://loio-server.azurewebsites.net/ws', // Replace with your server's URL
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
      ),
    );
    stompClient!.activate();
  }

  void onConnectCallback(StompFrame frame) {
    print('Connected to WebSocket server');
    print('Subscribing to topic: /topic/store/${widget.storeId}');
    stompClient!.subscribe(
      destination: '/topic/store/${widget.storeId}',
      callback: (frame) {
        if (frame.body != null) {
          final List<FoodModel> updatedFoods = parseFoods(frame.body!);
          _foodStreamController.add(updatedFoods);
          print(
              "Received food update for store ${widget.storeId}: ${frame.body!}");
        }
      },
    );
  }

  List<FoodModel> parseFoods(String body) {
    // Assuming body is a JSON string, parse it and return a list of FoodModel
    final List<dynamic> parsedJson = json.decode(body);
    return parsedJson.map((json) => FoodModel.fromJson(json)).toList();
  }

  @override
  void dispose() {
    // Deactivate the WebSocket connection if it's active
    if (stompClient != null && stompClient!.connected) {
      stompClient!.deactivate();
      print('WebSocket connection deactivated');
    }
    _foodStreamController.close();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final storeFuture = StoreService.getStoreById(widget.storeId);
    final foodsFuture = FoodService.getFoodListByStoreId(widget.storeId);

    final results = await Future.wait([storeFuture, foodsFuture]);

    _foodStreamController.add(results[1] as List<FoodModel>);

    return {
      'store': results[0],
      'foods': results[1],
    };
  }

  Future<void> _checkIfFavorite() async {
    try {
      List<FavoriteModel> favorites = await FavoriteService.getFavorites();
      setState(() {
        isFavorite =
            favorites.any((favorite) => favorite.storeId == widget.storeId);
      });
    } catch (e) {
      print('Failed to check if favorite: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (isFavorite) {
        bool success =
            await FavoriteService.deleteFavorite(storeId: widget.storeId);
        if (success) {
          setState(() {
            isFavorite = false;
          });
        }
      } else {
        bool success =
            await FavoriteService.makeFavorite(storeId: widget.storeId);
        if (success) {
          setState(() {
            isFavorite = true;
          });
        }
      }
    } catch (e) {
      print('Failed to toggle favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return FutureBuilder<Map<String, dynamic>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final store = snapshot.data!['store'] as StoreModel;
          final foods = snapshot.data!['foods'] as List<FoodModel>;
          int totalCapacity = foods.fold(0, (sum, food) => sum + food.capacity);

          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: screenHeight * 0.3,
                    floating: false,
                    pinned: true,
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background:
                          foods.isNotEmpty && foods[0].imageUrl.isNotEmpty
                              ? Image.network(
                                  'http://loio-server.azurewebsites.net${foods[0].imageUrl}',
                                  width: 0.25 * screenWidth,
                                  height: 0.09 * screenHeight,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/no_image.png',
                                      width: 0.25 * screenWidth,
                                      height: 0.09 * screenHeight,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/no_image.png',
                                  width: 0.25 * screenWidth,
                                  height: 0.09 * screenHeight,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(
                            right:
                                screenWidth * 0.05), // Adjust the padding here
                        child: IconButton(
                          onPressed: _toggleFavorite,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.2,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.01,
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.07,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.name,
                              style: TextStyle(
                                  fontSize: screenHeight * 0.035,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              store.address,
                              style: TextStyle(
                                  fontSize: screenHeight * 0.025,
                                  color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Text(
                              '이용 가능 인원 $totalCapacity명',
                              style: TextStyle(fontSize: screenHeight * 0.02),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '마감시간 ${store.endTime}',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: StreamBuilder<List<FoodModel>>(
                stream: _foodStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final foods = snapshot.data!;
                    return ListView.builder(
                      itemCount: foods.length,
                      itemBuilder: (BuildContext context, int index) {
                        final food = foods[index];
                        return MenuWidget(
                          foodId: food.foodId,
                          menuName: food.name,
                          unitCost: food.sellPrice.toString(),
                          remaining: food.capacity.toString(),
                          imgUrl: food.imageUrl.toString(),
                          onMenuTap: (int foodId) {
                            _showHalfScreenModal(food.name, food.sellPrice,
                                foodId, food.capacity);
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.08, // 버튼 높이 조절
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.01, // 좌우 및 상하 간격 조절
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartScreen(
                              storeId: store.storeId,
                              foodOrders: foodOrders,
                              nameList: nameList,
                              priceList: priceList)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    '장바구니',
                    style: TextStyle(
                      fontSize: screenHeight * 0.025,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  void _showHalfScreenModal(
      String menuName, int menuPrice, int foodId, int foodCapacity) {
    setState(() {
      numServings = 1;
      if (foodCapacity == 0) {
        numServings = 0;
      }
    });

    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.4,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.035),
                            child: Text(
                              '$menuName 주문하기',
                              style: TextStyle(fontSize: screenHeight * 0.035),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (numServings > 1) {
                                    setModalState(() {
                                      numServings -= 1;
                                    });
                                  }
                                },
                                child: SizedBox(
                                  width: screenHeight * 0.04,
                                  height: screenHeight * 0.04,
                                  child: Icon(
                                    Icons.exposure_minus_1_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.1,
                              ),
                              Text(
                                '$numServings인분',
                                style: TextStyle(fontSize: screenHeight * 0.04),
                              ),
                              SizedBox(
                                width: screenWidth * 0.1,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    if (foodCapacity > numServings) {
                                      numServings += 1;
                                    }
                                  });
                                },
                                child: SizedBox(
                                  width: screenHeight * 0.04,
                                  height: screenHeight * 0.04,
                                  child: Icon(
                                    Icons.plus_one_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.035),
                            child: ElevatedButton(
                              onPressed: () {
                                if (!nameList.contains(menuName)) {
                                  addOrder(
                                      foodId, numServings, menuName, menuPrice);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('$menuName이(가) 장바구니에 추가되었습니다.'),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('$menuName이(가) 이미 장바구니에 있습니다.'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context).primaryColor,
                                fixedSize: Size(
                                    screenWidth * 0.8, screenHeight * 0.06),
                              ),
                              child: Text(
                                '장바구니에 추가',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.027,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
