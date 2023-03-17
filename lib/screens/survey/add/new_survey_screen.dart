import 'package:flutter/material.dart';
import 'package:Ciellie/network/db/db_helper.dart';
import 'package:Ciellie/util/snackbar_utils.dart';

class NewSurveyScreen extends StatefulWidget {
  const NewSurveyScreen({Key? key}) : super(key: key);

  //static const routeName = "/survey/add";

  @override
  _NewSurveyScreenState createState() => _NewSurveyScreenState();
}

class _NewSurveyScreenState extends State<NewSurveyScreen> {
  bool get isAnythingInserted =>
      choices.any((element) => element.trim().isNotEmpty);

  bool get isAllInserted =>
      choices.every((element) => element.trim().isNotEmpty);

  bool get isSurveyNameInserted => surveyNameController.text.trim().isNotEmpty;

  final dbHelper = DbHelper.instance;

  final surveyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: buildSurveyNameTextField(),
          leading: buildCancelAction(),
          actions: [buildCompleteAction()],
        ),
        body: buildBody(),
      ),
    );
  }

  @override
  void dispose() {
    surveyNameController.dispose();
    super.dispose();
  }

  Widget buildSurveyNameTextField() {
    return TextField(
      //keyboardType: TextInputType.text,
      autofocus: true,
      controller: surveyNameController,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.white60,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: "Survey Name",
          hintStyle: TextStyle(color: Colors.white60),
          border: InputBorder.none),
    );
  }

  Widget buildCancelAction() {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => onClickClose(),
      tooltip: "Cancel",
    );
  }

  Widget buildCompleteAction() {
    return IconButton(
      onPressed: () => onClickComplete(),
      icon: Icon(Icons.done),
      tooltip: "Complete",
    );
  }

  final choices = ["", ""];

  Widget buildBody() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        for (int i = 0; i < choices.length; i++) buildRow(i, choices[i]),
        Divider(color: Theme.of(context).primaryColor),
        buildAddButton()
      ],
    );
  }

  Widget buildAddButton() {
    return TextButton.icon(
      onPressed: () => onClickAdd(),
      icon: Icon(Icons.add),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(""),
      ),
    );
  }

  Widget buildRow(int index, String item) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: TextField(
        controller: TextEditingController(text: item),
        onChanged: (text) => choices[index] = text,
        decoration: InputDecoration(
          hintText: "${index + 1}. Choice",
          border: InputBorder.none,
          icon: Icon(Icons.radio_button_unchecked),
          suffixIcon: index > 1
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => onDeleteItem(index),
                  color: Colors.grey,
                  splashRadius: 24,
                )
              : null,
        ),
      ),
    );
  }

  Future<bool> onClickClose() async {
    if (!isAnythingInserted) {
      Navigator.of(context).pop();
      return true;
    }
    var isConfirmed = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Warning"),
              content: Text(
                  "If you leave, the survey draft you are creating will be deleted. Do you confirm?"),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    isConfirmed = true;
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
    if (isConfirmed) Navigator.of(context).pop();
    return isConfirmed;
  }

  Future<void> onClickComplete() async {
    if (!isSurveyNameInserted) {
      context.snackbar("You have to write the survey name!");
      return;
    }

    if (!isAllInserted) {
      context.snackbar("You have to fill all the options!");
      return;
    }

    final title = surveyNameController.text;
    //final newSurvey = await dbHelper.createNewSurvey(title, choices);

    //Navigator.pop(context, newSurvey);
  }

  void onClickAdd() {
    //add new radio button
    if (isAllInserted)
      setState(() => choices.add(""));
    else
      context.snackbar("Please fill all the options first");
  }

  void onDeleteItem(int index) {
    setState(() {
      print("item deleted: ${choices.removeAt(index)}");
      print(choices);
    });
  }

  Future<bool> _onWillPop() => onClickClose();
}
