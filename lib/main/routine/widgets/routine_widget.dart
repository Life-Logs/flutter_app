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

  TextEditingController _nameController = TextEditingController();
  TextEditingController _goalController = TextEditingController();
  String _selectedCategory = '카운트'; // 초기값 설정

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

            return Padding(
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
                                  buildInfoRow('구분', card.category, null),
                                  buildInfoRow('반복', card.period, null),
                                  buildInfoRow(
                                      '활성', card.activatedAt.toString(), null),
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
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRoutineCard();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => CreateRoutine()),
          // );
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '루틴 추가',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // 이름 입력창
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('구분', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      items: <String>['카운트', '퍼센트', '체크박스']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                // 목표 입력창
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('목표', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _goalController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                // 태그 입력창
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('태그', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _goalController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                // 닫기버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Bottom Sheet를 닫는 메서드 호출
                        Navigator.pop(context);
                      },
                      child: Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Bottom Sheet를 닫는 메서드 호출
                        Navigator.pop(context);
                      },
                      child: Text('저장'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
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

