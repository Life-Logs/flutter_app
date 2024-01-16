import 'package:flutter/material.dart';
import 'package:lifelog/main/routine/create_routine.dart';
import 'package:lifelog/models/routine_model.dart';
import 'package:lifelog/services/api_services.dart';
import 'package:intl/intl.dart';

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
  final Future<List<RoutineModel>> futureRoutine = ApiService.getAllRoutine();
  final Map<int, bool> clickedStateMap = {};

  void toggleCardState(int id, bool isActived) {
    if (isActived) {
      setState(() {
        clickedStateMap[id] = !(clickedStateMap[id] ?? false);
      });
    }
  }

  void switchState(
      int id, int index, AsyncSnapshot<List<RoutineModel>> snapshot) async {
    setState(() {
      snapshot.data![index].isActived = !snapshot.data![index].isActived;
      snapshot.data![index].isClicked = false;
    });
    await ApiService.toggleRoutine(id, snapshot.data![index].isActived);
  }

  Widget buildInfoRow(String? label, dynamic value, List? tag) {
    String tagValue = tag?.map((tag) => '#$tag').join(' ') ?? '';
    String formattedValue = '';

    if (value is Map<String, dynamic>) {
      if (value.length == 1) {
        var key = value.keys.first;
        Map<String, String> dayOfWeekMap = {
          'monday': '월요일',
          'tuesday': '화요일',
          'wednesday': '수요일',
          'thursday': '목요일',
          'friday': '금요일',
          'saturday': '토요일',
          'sunday': '일요일',
        };

        formattedValue = dayOfWeekMap[key] ?? key;
        // var innerMap = value[key] as Map<String, dynamic>;
        // formattedValue = '$key: ${innerMap['start']} - ${innerMap['end']}';
      }
    } else if (value is DateTime) {
      formattedValue = DateFormat('yyyy-MM-dd').format(value.toLocal());
    } else if (value is String) {
      formattedValue = value;
    } else {
      formattedValue = '';
    }

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
            formattedValue ?? '',
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
      body: FutureBuilder(
        future: futureRoutine,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return makeList(snapshot);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
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

  void _showAddRoutineCard({RoutineModel? existingRoutine}) {
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
        return CreateRoutine(
          existingRoutine: existingRoutine,
          isEditing: existingRoutine != null,
        );
      },
    );
  }

  ListView makeList(AsyncSnapshot<List<RoutineModel>> snapshot) {
    return ListView.separated(
        itemBuilder: (context, index) {
          var card = snapshot.data![index];

          return Dismissible(
            key: UniqueKey(),
            onDismissed: (_) async {
              setState(() {
                snapshot.data!.removeAt(index);
              });
              await ApiService.deleteRoutine(card.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('루틴 삭제 성공!'),
                  duration: Duration(seconds: 2),
                ),
              );
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
                  onTap: () => toggleCardState(card.id, card.isActived),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: clickedStateMap[card.id] == true && card.isActived
                        ? 200
                        : 60,
                    decoration: BoxDecoration(
                      color: card.isActived
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
                                Row(
                                  children: [
                                    Text(
                                      card.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    if (clickedStateMap[card.id] == false ||
                                        clickedStateMap[card.id] == null)
                                      buildInfoRow('', null, card.routineTags),
                                  ],
                                ),
                                clickedStateMap[card.id] == true &&
                                        card.isActived
                                    ? IconButton(
                                        icon: const Icon(Icons.edit_square),
                                        onPressed: () {
                                          _showAddRoutineCard(
                                              existingRoutine: card);
                                        })
                                    : Switch(
                                        value: card.isActived,
                                        onChanged: (newValue) {
                                          switchState(card.id, index, snapshot);
                                        },
                                        activeColor: const Color(0xff34C759),
                                      )
                              ],
                            ),
                            if (card.isActived &&
                                (clickedStateMap[card.id] ?? false))
                              Column(
                                children: [
                                  buildInfoRow('구분', card.type, null),
                                  buildInfoRow('반복', card.datetime, null),
                                  buildInfoRow('활성', card.activedAt, null),
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
                                  buildInfoRow('', null, card.routineTags),
                                ],
                              ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                )),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: snapshot.data!.length);
  }
}
