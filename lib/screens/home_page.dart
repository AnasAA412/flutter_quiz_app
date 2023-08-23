import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quizapp/models/category.dart';
import 'package:quizapp/widgets/quiz_option.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperOne(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 200,
            ),
          ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 30),
                  child: Text(
                    "Select a category to start the quiz",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19.0),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(_buildCategoryItem,
                        childCount: categories.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 800
                            ? 7
                            : MediaQuery.of(context).size.width > 500
                                ? 3
                                : 3,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return ElevatedButton.icon(
      icon: Icon(category.icon),
      label: Text(category.name),
      onPressed: () {
        _categoryPressed(context, category);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    showModalBottomSheet(
        context: context,
        builder: (sheetContext) => BottomSheet(
            onClosing: () {},
            builder: (_) => QuizOptionsDialog(category: category)));
  }
}
