import 'package:flutter/material.dart';
import 'package:lifelog/main/routine/create_routine.dart';

class RoutineWidget extends StatefulWidget {
  const RoutineWidget({super.key});

  @override
  State<RoutineWidget> createState() => _RoutineWidgetState();
}

class CardModel {
  String title;
  String category;
  String period;
  DateTime activatedAt;
  bool isClicked;
  bool isActive;

  CardModel({
    required this.title,
    required this.category,
    required this.period,
    required this.activatedAt,
    this.isClicked = false,
    this.isActive = true,
  });
}

class _RoutineWidgetState extends State<RoutineWidget> {
  List<CardModel> cards = [
    CardModel(
      title: '커피',
      category: '카운트',
      period: '평일',
      activatedAt: DateTime(2023, 11, 23),
    ),
    CardModel(
      title: '무산소',
      category: '카운트',
      period: '평일',
      activatedAt: DateTime(2023, 11, 23),
    ),
    CardModel(
      title: '유산소',
      category: '체크박스',
      period: '평일',
      activatedAt: DateTime(2023, 11, 23),
    ),
    CardModel(
      title: '컴공 공부',
      category: '퍼센트',
      period: '평일',
      activatedAt: DateTime(2023, 11, 23),
    ),
  ];

  void toggleCardState(int index) {
    setState(() {
      cards[index].isClicked = !cards[index].isClicked;
    });
  }

  void switchState(int index) {
    setState(() {
      cards[index].isActive = !cards[index].isActive;
      cards[index].isClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebf6e1),
      body: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            CardModel card = cards[index];

            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () => toggleCardState(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: card.isActive && card.isClicked ? 150 : 60,
                    decoration: BoxDecoration(
                      color: card.isActive
                          ? const Color(0xfff5fdee)
                          : const Color(0xffC5DDBC),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  card.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Switch(
                                  value: card.isActive,
                                  onChanged: (newValue) {
                                    switchState(index);
                                  },
                                  activeColor: const Color(0xff34C759),
                                )
                              ],
                            ),
                            if (card.isActive && card.isClicked)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '구분',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        card.category,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '반복',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        card.period,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '활성',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        card.activatedAt.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoutine()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
      ),
    );
  }

// const Column(children: [
//         Text(
//           '루틴', // 추가된 텍스트
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.normal,
//             color: Colors.grey,
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xffebf6e1),
  //     body: FutureBuilder(
  //       builder: ((context, snapshot) {
  //         if (snapshot.hasData) {
  //           return const Column(
  //             children: [
  //               SizedBox(height: 30),
  //               Expanded(child: makeRoutineList(snapshot)),
  //             ],
  //           );
  //         }
  //       }),
  //     ),
  //   );
  // }

  // ListView makeRoutineList(AsyncSnapshot<List<>> snapshot) {
  //   return ListView.separated(
  //     itemBuilder: (context, index) {
  //       return null;

  //   },
  //   separatorBuilder: separatorBuilder,
  //   itemCount: itemCount,)
  // }
}
