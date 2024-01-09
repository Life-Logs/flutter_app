import 'package:flutter/material.dart';
import 'package:lifelog/services/api_services.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key});

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  final List<String> _tags = [];
  String _selectedCategory = '카운트'; // 초기값 설정
  String _selectedPeriod = '매주'; // 초기값 설정
  List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];
  List<String> selectedDays = [];
  List<Widget> timeRows = [];
  bool isChecked = false;

  Map<String, dynamic> routineData = {};

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

  void createRoutineData() {
    routineData = {
      "name": _nameController.text,
      "type": _selectedCategory == '카운트'
          ? 'count'
          : _selectedCategory == '퍼센트'
              ? 'percent'
              : 'checkbox',
      "datetime": {
        "monday": {
          "start": _startTimeController.text,
          "end": _endTimeController.text
        }
      },
      "isActived": true,
      "goal":
          int.tryParse(_goalController.text) ?? 0, // 목표를 정수로 변환, 실패하면 0으로 설정
      "routineTags": _tags, // 태그가 비어 있지 않으면 리스트에 추가
      "activedAt": DateTime.now().toIso8601String(),
      "inactivedAt": DateTime.now().toIso8601String(),
    };
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      String formattedTime = picked.format(context);
      controller.text = convertTo24HourFormat(formattedTime);
    }
  }

  String convertTo24HourFormat(String inputTime) {
    List<String> parts = inputTime.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    if (parts[1] == 'PM' && hours != 12) {
      hours += 12;
    } else if (parts[1] == 'AM' && hours == 12) {
      hours = 0;
    }
    print(selectedDays);

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  void _addTimeRow() {
    setState(() {
      timeRows.add(
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _startTimeController,
                  readOnly: true,
                  onTap: () => _selectTime(context, _startTimeController),
                  decoration: const InputDecoration(
                    labelText: 'Start Time',
                    suffixIcon: Icon(Icons.access_time, color: Colors.black54),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _endTimeController,
                  readOnly: true,
                  onTap: () => _selectTime(context, _endTimeController),
                  decoration: const InputDecoration(
                    labelText: 'End Time',
                    suffixIcon: Icon(Icons.access_time, color: Colors.black54),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
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
              const Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 구분
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('구분',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(children: [
                    Checkbox(
                      value: _selectedCategory == '체크박스' ? true : isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedCategory == '체크박스'
                              ? null
                              : isChecked = !isChecked;
                        });
                      },
                      activeColor: _selectedCategory == '체크박스'
                          ? Colors.black26
                          : Colors.black87,
                    ),
                    const Text('목표설정',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ])
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButton<String>(
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
              ),
              const SizedBox(height: 20),
            ],
          ),

          // 목표 입력창
          if (isChecked && _selectedCategory != '체크박스')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('목표', style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _goalController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

          // 태그 입력창
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('태그', style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _tagController,
                  onSubmitted: (String value) {
                    setState(() {
                      _tags.add(value);
                      _tagController.clear();
                    });
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // 입력된 태그를 리스트로 표시
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _tags
                      .map(
                        (tag) => Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xffEBF6E1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                    color: Color(0xff64705B)), // Text color
                              ),
                            ),
                            const SizedBox(
                                width: 8), // Adjust the width as needed
                          ],
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 날짜 및 시간
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text('날짜 및 시간',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('언제부터 시작할까요?',
                      style: TextStyle(fontWeight: FontWeight.w400)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 193, 190, 190),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Text(
                      '23.12.06',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('언제까지 할까요?',
                      style: TextStyle(fontWeight: FontWeight.w400)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 193, 190, 190),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Text(
                      '23.12.06',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                            updateSelectedDays();
                          });
                        },
                        items: <String>['매주', '매일', '평일', '주말']
                            .map<DropdownMenuItem<String>>((String value) {
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
                      children: [
                        ...daysOfWeek
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
                        // 시간 추가 버튼
                        InkWell(
                          onTap: () {
                            _addTimeRow();
                          },
                          child: Container(
                            width: 40,
                            height: 30,
                            decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add,
                                      color: Colors.white, size: 10.0),
                                  Text(
                                    '시간',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(children: timeRows),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),

          // 닫기버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                        color: Color(0xFF64705B)), // Border color
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () async {
                    createRoutineData();
                    await ApiService.createRoutine(routineData);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64705B),
                  ),
                  child: const Text(
                    '저장',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
