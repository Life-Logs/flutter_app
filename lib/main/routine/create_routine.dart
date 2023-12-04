import 'package:flutter/material.dart';
import 'package:lifelog/main/routine/widgets/routine_widget.dart';

class CreateRoutine extends StatefulWidget {
  @override
  _CreateRoutineState createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    final Animation<double> curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(
              0.0, (1 - _animation.value) * MediaQuery.of(context).size.height),
          child: Material(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            // Close the bottom sheet with the reverse animation
                            _animationController.reverse().then((value) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Add your form fields or content for creating a routine
                  // Example: TextFormField, DropdownButton, etc.
                  // ...

                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      // Implement logic to save the routine
                      // ...

                      // Close the bottom sheet with the reverse animation
                      _animationController.reverse().then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Save Routine'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
