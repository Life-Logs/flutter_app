import 'package:flutter/material.dart';
import 'package:lifelog/main/routine/widgets/routine_widget.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key});

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  List<CardModel> cards = [];

  void addCard(CardModel card) {
    setState(() {
      cards.add(card);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('아직 못했지롱~~'),
    );
  }
}
