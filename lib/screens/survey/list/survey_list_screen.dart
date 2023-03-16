import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Ciellie/models/survey.dart';
import 'package:Ciellie/network/auth/authenticator.dart';
import 'package:Ciellie/network/db/db_helper.dart';
//import 'package:Ciellie/screens/home_screen.dart';
import 'package:Ciellie/screens/survey/add/new_survey_screen.dart';
import 'package:Ciellie/screens/survey/detail/survey_detail_screen.dart';
import 'package:Ciellie/util/date_utils.dart';
import '../../screen.dart';
import '../../../widgets/widget.dart';

class SurveyListScreen extends StatefulWidget {
  const SurveyListScreen({Key? key}) : super(key: key);

  //static const routeName = "/survey";

  @override
  _SurveyListScreenState createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  final dbHelper = DbHelper.instance;
  final authenticator = Authenticator.instance;
  final surveys = <Survey>[];
  var isInitialDataFetched = false;

  @override
  void initState() {
    super.initState();
    dbHelper.surveysFuture.then((snapshot) {
      surveys.clear();
      surveys.addAll(snapshot);
      print(surveys);
      setState(() => isInitialDataFetched = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Questionnaire"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Log out",
            onPressed: onClickLogout,
          )
        ],
        //automaticallyImplyLeading: false,
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onClickAddSurveyFab(),
        child: Icon(Icons.add),
        tooltip: "Create Survey",
      ),
    );
  }

  Widget buildBody() {
    return isInitialDataFetched ? buildSurveyListOrEmpty() : buildProgress();
  }

  Widget buildProgress() {
    return Container(
        margin: EdgeInsets.all(16),
        alignment: Alignment.topCenter,
        child: CircularProgressIndicator());
  }

  Widget buildSurveyListOrEmpty() {
    return surveys.isEmpty ? buildEmpty() : buildSurveyList();
  }

  Widget buildEmpty() {
    return Container(
      margin: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        "No polls have been added yet.\nAdd the first poll now.",
        textAlign: TextAlign.center,
      ),
    );
  }

  ListView buildSurveyList() {

    return ListView(
      padding: EdgeInsets.all(6),
      children: [
        ...surveys.map((e) => buildSurvey(e)).toList(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
          child: Text("— Total ${surveys.length} survey listed —", textAlign: TextAlign.center,),
        ),
      ],
    );
  }

  Card buildSurvey(Survey item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => onClickSurvey(item),
        child: ListTile(
          title: Text(item.name),
          trailing: Text(
            "${item.totalVoteCount} vote",
            textAlign: TextAlign.end,
          ),
          subtitle: Text("@${item.creator.username}"),
        ),
      ),
    );
  }

  Future<void> onClickAddSurveyFab() async {
    final result =
        //await Navigator.pushNamed(context, MaterialPageRoute(builder: (context) =>  NewSurveyScreen()) as String);
        await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  NewSurveyScreen()));
    if (result == null) return;
    final addedSurvey = result as Survey;
    setState(() {
      surveys.insert(0, addedSurvey);
    });
  }

  void onClickSurvey(Survey survey) {
    // showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //           title: Text("Hello"),
    //           content:
    //               Text("$survey anketine gitmek üzeresiniz. Haberiniz ola!"),
    //         ));a
    //Navigator.pushNamed(context, MaterialPageRoute(builder: (context) =>  SurveyDetailScreen()) as String,
    //  arguments: survey);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  SurveyDetailScreen(final_survey: survey)));
    //Navigator.of(context).pushNamed(MaterialPageRoute(builder: (context) =>  SurveyDetailScreen()),arguments: survey); //sending of the values to route_generator.dart
  }

  Future<void> onClickLogout() async {
    await authenticator.logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  WelcomePage()));
  }
}
