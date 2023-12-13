import 'package:flutter/material.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key});

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  String _selectedCategory = '카운트'; // 초기값 설정
  String _selectedPeriod = '매일'; // 초기값 설정
  List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];
  List<String> selectedDays = [];

  void toggleSelectedDay(String day) {
    if (_selectedPeriod == '매일') {
      setState(() {
        if (daysOfWeek.every((d) => selectedDays.contains(d))) {
          selectedDays.clear();
        } else {
          selectedDays = List.from(daysOfWeek);
        }
      });
    } else if (_selectedPeriod == '평일') {
      setState(() {
        if (['월', '화', '수', '목', '금'].every((d) => selectedDays.contains(d))) {
          selectedDays
              .removeWhere((d) => ['월', '화', '수', '목', '금'].contains(d));
        } else {
          selectedDays = List.from(['월', '화', '수', '목', '금']);
        }
      });
    } else if (_selectedPeriod == '주말') {
      setState(() {
        if (['토', '일'].every((d) => selectedDays.contains(d))) {
          selectedDays.removeWhere((d) => ['토', '일'].contains(d));
        } else {
          selectedDays = List.from(['토', '일']);
        }
      });
    }
  }

  void updateSelectedDays() {
    setState(() {
      if (_selectedPeriod == '매일') {
        selectedDays = List.from(daysOfWeek);
      } else if (_selectedPeriod == '평일') {
        selectedDays = List.from(['월', '화', '수', '목', '금']);
      } else if (_selectedPeriod == '주말') {
        selectedDays = List.from(['토', '일']);
      } else {
        selectedDays.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '루틴 추가',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              // 이름 입력창
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('이름',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('구분',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 20),

              // 목표 입력창
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('목표',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _goalController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 태그 입력창
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('태그',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _goalController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 날짜 및 시간
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('날짜 및 시간',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('언제부터 시작할까요?',
                          style: TextStyle(fontWeight: FontWeight.w400)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 193, 190, 190),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Text(
                          '23.12.06',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 193, 190, 190),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedPeriod,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPeriod = newValue!;
                                  // 주기에 따라 선택된 요일 업데이트
                                  updateSelectedDays();
                                });
                              },
                              items: <String>[
                                '매일',
                                '평일',
                                '주말'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: daysOfWeek
                                .map((day) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedDays.contains(day)) {
                                            selectedDays.remove(day);
                                          } else {
                                            selectedDays.add(day);
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent,
                                          border: selectedDays.contains(day)
                                              ? Border.all(
                                                  color: Colors.black,
                                                  width: 2.0,
                                                )
                                              : null,
                                        ),
                                        child: Center(
                                          child: Text(
                                            day,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 20),

              // 닫기버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Bottom Sheet를 닫는 메서드 호출
                      Navigator.pop(context);
                    },
                    child: const Text('취소'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Bottom Sheet를 닫는 메서드 호출
                      Navigator.pop(context);
                    },
                    child: const Text('저장'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
