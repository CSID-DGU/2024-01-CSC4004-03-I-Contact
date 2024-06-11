import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget(
      {super.key,
      required this.menuName,
      required this.foodId,
      required this.unitCost,
      required this.remaining,
      this.numMenu = 0,
      required this.onMenuTap,
      required this.imgUrl});

  final String menuName, unitCost, remaining, imgUrl;
  final int numMenu, foodId;
  final void Function(int foodId) onMenuTap;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    bool isRemainingZero = int.tryParse(remaining) == 0;

    return GestureDetector(
      onTap: isRemainingZero ? null : () => onMenuTap(foodId),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 1),
          ),
        ),
        width: screenWidth,
        height: 0.15 * screenHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01,
            horizontal: screenWidth * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    menuName,
                    style: TextStyle(
                      color: isRemainingZero ? Colors.grey : Colors.black,
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.001),
                  Row(
                    children: [
                      Text(
                        unitCost,
                        style: TextStyle(
                          color: isRemainingZero ? Colors.grey : Colors.black,
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '원',
                        style: TextStyle(
                          color: isRemainingZero ? Colors.grey : Colors.black,
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.003),
                  Row(
                    children: [
                      Text(
                        '남은 개수',
                        style: TextStyle(
                          color: isRemainingZero
                              ? Colors.grey.withOpacity(0.4)
                              : Colors.black.withOpacity(0.4),
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: screenHeight * 0.01),
                      Text(
                        remaining,
                        style: TextStyle(
                          color: isRemainingZero
                              ? Colors.grey.withOpacity(0.4)
                              : Colors.black.withOpacity(0.4),
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '개',
                        style: TextStyle(
                          color: isRemainingZero
                              ? Colors.grey.withOpacity(0.4)
                              : Colors.black.withOpacity(0.4),
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: 0.13 * screenHeight,
                  height: 0.13 * screenHeight,
                  child: imgUrl.isNotEmpty
                      ? Image.network(
                          'http://loio-server.azurewebsites.net$imgUrl',
                          width: 0.25 * screenWidth,
                          height: 0.09 * screenHeight,
                          fit: BoxFit.cover,
                          color: isRemainingZero
                              ? const Color.fromARGB(255, 220, 220, 220)
                                  .withOpacity(0.7)
                              : null,
                          colorBlendMode:
                              isRemainingZero ? BlendMode.modulate : null,
                          errorBuilder: (context, error, stackTrace) {
                            print('Image load error: $error');
                            return Image.asset(
                              'assets/images/chicken.jpg',
                              width: 0.25 * screenWidth,
                              height: 0.09 * screenHeight,
                              fit: BoxFit.cover,
                              color: isRemainingZero
                                  ? const Color.fromARGB(255, 220, 220, 220)
                                      .withOpacity(0.7)
                                  : null,
                              colorBlendMode:
                                  isRemainingZero ? BlendMode.modulate : null,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/chicken.jpg',
                          width: 0.25 * screenWidth,
                          height: 0.09 * screenHeight,
                          fit: BoxFit.cover,
                          color: isRemainingZero
                              ? const Color.fromARGB(255, 220, 220, 220)
                                  .withOpacity(0.7)
                              : null,
                          colorBlendMode:
                              isRemainingZero ? BlendMode.modulate : null,
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
