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
  List tags;
  bool isClicked;
  bool isActive;

  CardModel({
    required this.title,
    required this.category,
    required this.period,
    required this.activatedAt,
    required this.tags,
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
        tags: ['음식', '커피']),
    CardModel(
        title: '무산소',
        category: '카운트',
        period: '평일',
        activatedAt: DateTime(2023, 11, 23),
        tags: ['건강', '취미']),
    CardModel(
        title: '유산소',
        category: '체크박스',
        period: '평일',
        activatedAt: DateTime(2023, 11, 23),
        tags: ['취미']),
    CardModel(
        title: '컴공 공부',
        category: '퍼센트',
        period: '평일',
        activatedAt: DateTime(2023, 11, 23),
        tags: ['공부']),
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

  Widget buildInfoRow(String? label, String? value, List? tag) {
    String tagValue = tag?.map((tag) => '#$tag').join(' ') ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            tagValue,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            value ?? '',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebf6e1),
      body: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            CardModel card = cards[index];

            return Dismissible(
              key: UniqueKey(),
              onDismissed: (_) {
                setState(() {
                  cards.removeAt(index);
                });
              },
              background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: const Text(
                    "삭제",
                    style: TextStyle(fontSize: 25),
                  )),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GestureDetector(
                    onTap: () => toggleCardState(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: card.isActive && card.isClicked ? 200 : 60,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: ListView(children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    buildInfoRow('구분', card.category, null),
                                    buildInfoRow('반복', card.period, null),
                                    buildInfoRow('활성',
                                        card.activatedAt.toString(), null),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      height: 1,
                                      color: Color.fromARGB(255, 188, 191, 185),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    buildInfoRow('', null, card.tags),
                                  ],
                                ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRoutineCard();
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
      ),
    );
  }

  void _showAddRoutineCard() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return const CreateRoutine();
      },
    );
  }
}
