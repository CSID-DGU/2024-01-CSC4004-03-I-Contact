import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                width: 400,
                height: 100,
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 2),
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.person_2_rounded,
                        size: 32,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 70,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45)),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '아이디123',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      width: 55,
                      height: 55,
                      margin: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.notifications,
                        size: 32,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                width: 400,
                height: 100,
                margin: const EdgeInsets.only(
                    top: 5, bottom: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2.0,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(7)),
                      Icon(
                        Icons.search,
                        size: 32,
                        color: Colors.black38,
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                        '검색',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black38),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                width: 400,
                height: 250,
                margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2.0,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '    카테고리',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 6,
                          ),
                          FoodCategoryWidget(foodName: '한식'),
                          FoodCategoryWidget(foodName: '중식'),
                          FoodCategoryWidget(foodName: '일식'),
                          FoodCategoryWidget(foodName: '양식'),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 6,
                          ),
                          FoodCategoryWidget(foodName: '분식'),
                          FoodCategoryWidget(foodName: '디저트'),
                          FoodCategoryWidget(foodName: '야식'),
                          FoodCategoryWidget(foodName: '도시락'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Container(
                width: 400,
                height: 400,
                margin: const EdgeInsets.only(bottom: 15, left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2.0,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('    지도',
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 400,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.asset('assets/images/square_map.png'),
                      ),
                    ],
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

class FoodCategoryWidget extends StatelessWidget {
  final String foodName;

  const FoodCategoryWidget({super.key, required this.foodName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 0,
            blurRadius: 5.0,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.food_bank_rounded,
            color: Theme.of(context).primaryColorDark,
            size: 30,
          ),
          Text(
            foodName,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('foodName', foodName));
  }
}
