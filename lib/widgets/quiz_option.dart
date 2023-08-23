import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizapp/models/category.dart';
import 'package:quizapp/models/question.dart';
import 'package:quizapp/resources/api_provider.dart';
import 'package:quizapp/screens/error.dart';

import '../screens/quiz_page.dart';

class QuizOptionsDialog extends StatefulWidget {
  final Category? category;
  const QuizOptionsDialog({Key? key, this.category}) : super(key: key);

  @override
  State<QuizOptionsDialog> createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int? _noOfQuestions;
  String? _difficulty;
  late bool processing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Text(
              widget.category!.name,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Select Total Number of Questions"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(
                  height: 0.5,
                ),
                ActionChip(
                  label: Text("10"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 10
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestion(10),
                ),
                ActionChip(
                  label: Text("20"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 20
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestion(20),
                ),
                ActionChip(
                  label: Text("30"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 30
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestion(30),
                ),
                ActionChip(
                  label: Text("40"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 40
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestion(40),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Text("Select Difficulty"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(width: 0.0),
                ActionChip(
                  label: Text("Any"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == null
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty(null),
                ),
                ActionChip(
                  label: Text("Easy"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "easy"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("easy"),
                ),
                ActionChip(
                  label: Text("Medium"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "medium"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("medium"),
                ),
                ActionChip(
                  label: Text("Hard"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "hard"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("hard"),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          processing
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _startQuiz,
                  child: Text("Start Quiz"),
                ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  _selectNumberOfQuestion(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String? s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      List<Question> questions =
          await getQuestions(widget.category!, _noOfQuestions, _difficulty);
      Navigator.pop(context);
      if (questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorPage(
                  message:
                      "There are not enough questions in the category, with the options you selected.",
                )));
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => QuizPage(
                    questions: questions,
                    category: widget.category,
                  )));
    } on SocketException catch (_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message:
                        "Can't reach the servers, \n Please check your internet connection.",
                  )));
    } catch (e) {
      print(e.toString());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message: "Unexpected error trying to connect to the API",
                  )));
    }
    setState(() {
      processing = false;
    });
  }
}
