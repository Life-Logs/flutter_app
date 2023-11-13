import 'package:flutter/material.dart';

class RoutineWidget extends StatefulWidget {
  const RoutineWidget({super.key});

  @override
  State<RoutineWidget> createState() => _RoutineWidgetState();
}

class CardModel {
  bool isClicked = false;
}

class _RoutineWidgetState extends State<RoutineWidget> {
  List<CardModel> cards = List.generate(4, (index) => CardModel());

  void onClick(int index) {
    setState(() {
      cards[index].isClicked = !cards[index].isClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebf6e1),
      body: Column(
        children: cards.asMap().entries.map((cardEntry) {
          final index = cardEntry.key;
          final card = cardEntry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () => onClick(index),
              child: Container(
                height: card.isClicked ? 200 : 60,
                decoration: BoxDecoration(
                  color: const Color(0xfff5fdee),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          );
        }).toList(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
      ),
    );
  }

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
