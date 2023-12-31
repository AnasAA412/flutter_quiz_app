import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quizapp/models/category.dart';
import 'package:quizapp/models/question.dart';
import 'package:quizapp/screens/quiz_finished.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category? category;
  const QuizPage({Key? key, required this.questions, this.category})
      : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.blue);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers!;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(widget.category!.name),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text("${_currentIndex + 1}")),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Text(
                          HtmlUnescape().convert(
                              widget.questions[_currentIndex].question!),
                          softWrap: true,
                          style: MediaQuery.of(context).size.width > 800
                              ? _questionStyle.copyWith(fontSize: 30.0)
                              : _questionStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 80, 10, 50),
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ...options.map((option) => RadioListTile(
                                title: Text(
                                  HtmlUnescape().convert("$option"),
                                  style: MediaQuery.of(context).size.width > 800
                                      ? TextStyle(fontSize: 30)
                                      : null,
                                ),
                                value: option,
                                groupValue: _answers[_currentIndex],
                                onChanged: (dynamic value) {
                                  setState(() {
                                    _answers[_currentIndex] = option;
                                  });
                                },
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(190, 140, 0, 0),
                    child: Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: MediaQuery.of(context).size.width > 800
                                ? const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 64.0)
                                : null,
                          ),
                          child: Text(
                            _currentIndex == (widget.questions.length - 1)
                                ? "Submit"
                                : "Next",
                            style: MediaQuery.of(context).size.width > 800
                                ? TextStyle(fontSize: 30.0)
                                : null,
                          ),
                          onPressed: _nextSubmit,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("you must select an answer to continue")));
      return;
    }

    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: widget.questions, answers: _answers)));
    }
  }

  Future<bool> _onWillPop() async {
    final resp = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost"),
            title: Text("Warning!"),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
    return resp ?? false;
  }
}
