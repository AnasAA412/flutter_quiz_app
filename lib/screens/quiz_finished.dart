import 'package:flutter/material.dart';
import 'package:quizapp/models/question.dart';
import 'package:quizapp/screens/check_answer.dart';

class QuizFinishedPage extends StatefulWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;
  QuizFinishedPage({Key? key, required this.questions, required this.answers})
      : super(key: key);

  @override
  State<QuizFinishedPage> createState() => _QuizFinishedPageState();
}

class _QuizFinishedPageState extends State<QuizFinishedPage> {
  int? correctAnswer;

  @override
  Widget build(BuildContext context) {
    int correct = 0;
    this.widget.answers.forEach((index, value) {
      if (this.widget.questions[index].correctAnswer == value) correct++;
    });
    final TextStyle titleStyle = TextStyle(
        color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);

    return Scaffold(
        appBar: AppBar(
          title: Text('Result'),
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10.0),
                  title: Text(
                    "Total Questions",
                    style: titleStyle,
                  ),
                  trailing: Text(
                    "${widget.questions.length}",
                    style: trailingStyle,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Score", style: titleStyle),
                  trailing: Text("${correct / widget.questions.length * 100}%",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Correct Answers", style: titleStyle),
                  trailing: Text("$correct/${widget.questions.length}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Incorrect Answers", style: titleStyle),
                  trailing: Text(
                      "${widget.questions.length - correct}/${widget.questions.length}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 20.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text("Go to Home")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text("Check Answers"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CheckAnswersPage(
                                questions: widget.questions,
                                answers: widget.answers,
                              )));
                    },
                  ),
                ],
              )
            ]),
          ),
        ));
  }
}
