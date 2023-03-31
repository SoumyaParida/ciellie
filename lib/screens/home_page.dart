import 'package:Ciellie/models/profile.dart';
import 'package:Ciellie/models/survey.dart';
import 'package:Ciellie/screens/survey_details.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';
import '../screens/screen.dart';

import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/network/db/db_helper.dart';
import 'package:Ciellie/network/prefs/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Ciellie/screens/survey/survey_name.dart';
import 'package:Ciellie/screens/survey/reopen_survey.dart';
import 'package:Ciellie/screens/survey/reopen_scheduled_survey.dart';

class MyHomePage extends StatefulWidget
{
  User? currentuser;
  //const MyHomePage({Key? key, this.requ}) : super(key: key);
  MyHomePage({required this.currentuser});
  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePage> with TickerProviderStateMixin{
  final dbHelper = DbHelper.instance;
  User? user;
  UserProfile? userProfile;
  late SharedPrefs sharedPrefs;
  var isInitialDataFetched = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<String> docIDs =[];
  List<String> scheduled_docIDs =[];
  List<String> incomplete_docIDs =[];
  List<String> completed_docIDs =[];
  
  
  Survey? targetSurvey;
  Survey? surveyItmes;

  Survey? targetScheduledSurvey;
  Survey? surveyScheduledItmes;

  Survey? targetIncompleteSurvey;
  Survey? surveyIncompleteItmes;

  Survey? targetCompletedSurvey;
  Survey? surveyCompletedItmes;
  
  static const List<Tab> myTabs = <Tab>[
    Tab(child: Text("surveys", style: TextStyle(color: Colors.black)),),
    Tab(child: Text("scheduled", style: TextStyle(color: Colors.black)),),
    Tab(child: Text("incomplete", style: TextStyle(color: Colors.black)),),
    Tab(child: Text("complted", style: TextStyle(color: Colors.black)),),
  ];
  
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    
    tabController = TabController(length: 4, vsync: this);
    
    SharedPrefs.getInstance().then((prefs) async {
      sharedPrefs = prefs;
      user = sharedPrefs.getUser()!;
      print("user: $user");
      final snapshot =
        await _db.collection("profiles").where("email", isEqualTo: user!.email).get();
      //userProfile = UserProfile.fromJson(snapshot.docs.first.data());
      //print("userProfile{$userProfile}");
      
      setState(() {
        
        isInitialDataFetched = true;
      });
      //getSurveyValues()
      //setState(() => isInitialDataFetched = true);
      //super.initState();
    });
  }

 //Get all Surveys
  Future<Survey?> getSurveyValues(String documentId, String profileId) async {
    final snapshot =
        await _db.collection("surveys").doc(profileId).collection("survey").doc(documentId).get();
    //final profile = snapshot.docs.map((e) => UserProfile.fromDocSnapshot(e)).single;
    print("snapshot{$snapshot}");
    var surveyValues = snapshot.data();
    print("surveyValues{$surveyValues}");
    //setState(() {       
    targetSurvey =  Survey.fromJson(surveyValues!);
    //  });
      print("targetSurvey{$targetSurvey}");
      return targetSurvey;
  }

  //Get all Scheduled
  Future<Survey?> getScheduledSurveyValues(String documentId, String profileId) async {
    final snapshot =
        await _db.collection("surveys").doc(profileId).collection("survey").doc(documentId).get();
    print("snapshot{$snapshot}");
    var surveyValues = snapshot.data();
    print("surveyValues{$surveyValues}");  
    targetScheduledSurvey =  Survey.fromJson(surveyValues!);
    print("targetScheduledSurvey{$targetScheduledSurvey}");
    if (DateTime.parse(targetScheduledSurvey!.date).isAfter(DateTime.now())){
      return targetScheduledSurvey;
    }
    else{
      return null;
    }
    
  }

  Future<Survey?> getIncompletedSurveyValues(String documentId, String profileId) async {
    final snapshot =
        await _db.collection("surveys").doc(profileId).collection("survey").doc(documentId).get();
    print("snapshot{$snapshot}");
    var surveyValues = snapshot.data();
    print("surveyValues{$surveyValues}");  
    targetIncompleteSurvey =  Survey.fromJson(surveyValues!);
    print("targetIncompleteSurvey{$targetIncompleteSurvey}");
    if (DateTime.parse(targetScheduledSurvey!.date).isAfter(DateTime.now())){
      return targetScheduledSurvey;
    }
    else{
      return null;
    } 
  }

  Future<UserProfile?> getProfile(String userId) async {
    try{
      final snapshot = await _db.collection("profiles").doc(userId).get();

      var ProfileValues = snapshot.data();
      userProfile = UserProfile.fromJson(ProfileValues!);
      return userProfile;
    } catch (e) {
      print(e);
      return null;
    }
  
  }

  @override
 void dispose() {
   tabController.dispose();
   super.dispose();
 }

  //late User user;
  //late SharedPrefs sharedPrefs;
  //var isInitialDataFetched = false;
  Widget build(BuildContext context) {
    //TabController tabController = TabController(length: 4, vsync: this);
    User? profile = widget.currentuser;
    
    return Scaffold(  
      drawer: NavDrawer(
        user: profile,
        
      ),
      appBar: AppBar(
        title: Text('Surveys'),
        backgroundColor: Colors.lightBlue,
      ),
      /*body: Center(
        child: Text('Begin New Survey'),
      ),*/
      body: Column(
        children: [
          SizedBox(height: 20,),
          Text(
            "Survey Manager", 
            style:TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(64, 105, 225, 1),
                    ),
          ),
          SizedBox(height: 20,),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.orange
                ),
                controller: tabController,
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 30),
                tabs: [
                  Tab(child: Text("surveys", style: TextStyle(color: Colors.black)),),
                  Tab(child: Text("scheduled", style: TextStyle(color: Colors.black)),),
                  Tab(child: Text("incomplete", style: TextStyle(color: Colors.black)),),
                  Tab(child: Text("complted", style: TextStyle(color: Colors.black)),),
                ],
              ),
            ),

          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                FutureBuilder(
                  future: getDocIds(profile!.id, docIDs),
                  builder: (context,snapshot){
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: docIDs.toSet().toList().length,
                        itemBuilder: (context,index){
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 30, vertical:10),
                            child: ListTile(
                              leading: Icon(Icons.document_scanner_rounded, color: Colors.red,),
                              title: GetSurveyName(documentId: docIDs[index], profileId: profile.id, parameter: "address"),//Text(docIDs[index]),
                              trailing: Text("read-only"),
                              onTap: () async {
                                  surveyItmes = await getSurveyValues(docIDs[index], profile.id);
                                  UserProfile? userprofile = await getProfile(profile.id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          SurveyReopen(documentId: docIDs[index], 
                                                      profileId: profile,
                                                      name: surveyItmes!.name,
                                                      email: surveyItmes!.email,
                                                      phone: surveyItmes!.phone,
                                                      address: surveyItmes!.address,
                                                      propertyType: surveyItmes!.propertyType,
                                                      date: surveyItmes!.date,
                                                      time: surveyItmes!.time,
                                                      message: surveyItmes!.message,
                                                      geolocation: surveyItmes!.geolocation,
                                                      status: surveyItmes!.status,
                                                      userprofile: userprofile,
                                        )
                                      )
                                    );
                                },
                            ), 
                          );
                        },
                      );
                  },
                ),
                FutureBuilder(
                  future: getScheduledDocIds(profile.id, scheduled_docIDs),
                  builder: (context,snapshot){
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: scheduled_docIDs.toSet().toList().length,
                        itemBuilder: (context,index){
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 30, vertical:10),
                            child: ListTile(
                              leading: Icon(Icons.schedule_outlined, color: Colors.red,),
                              title: GetSurveyName(documentId: scheduled_docIDs[index], profileId: profile.id, parameter: "address"),//Text(docIDs[index]),
                              trailing: Text("Future Surveys"),
                              onTap: () async {
                                  surveyScheduledItmes = await getSurveyValues(scheduled_docIDs[index], profile.id);
                                  UserProfile? userprofile = await getProfile(profile.id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          SchduledSurveyReopen(documentId: scheduled_docIDs[index], 
                                                      profileId: profile,
                                                      name: surveyScheduledItmes!.name,
                                                      email: surveyScheduledItmes!.email,
                                                      phone: surveyScheduledItmes!.phone,
                                                      address: surveyScheduledItmes!.address,
                                                      propertyType: surveyScheduledItmes!.propertyType,
                                                      date: surveyScheduledItmes!.date,
                                                      time: surveyScheduledItmes!.time,
                                                      message: surveyScheduledItmes!.message,
                                                      geolocation: surveyScheduledItmes!.geolocation,
                                                      status: surveyScheduledItmes!.status,
                                                      userprofile: userprofile,
                                        )
                                      )
                                    );
                                },
                            ), 
                          );
                        },
                      );
                  },
                ),
                FutureBuilder(
                  future: getIncompleteDocIds(profile.id, incomplete_docIDs),
                  builder: (context,snapshot){
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: incomplete_docIDs.toSet().toList().length,
                        itemBuilder: (context,index){
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 30, vertical:10),
                            child: ListTile(
                              leading: Icon(Icons.incomplete_circle_outlined, color: Colors.red,),
                              title: GetSurveyName(documentId: incomplete_docIDs[index], profileId: profile.id, parameter: "address"),//Text(docIDs[index]),
                              trailing: Text("Incompleted"),
                              onTap: () async {
                                  surveyIncompleteItmes = await getSurveyValues(incomplete_docIDs[index], profile.id);
                                  UserProfile? userprofile = await getProfile(profile.id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          SchduledSurveyReopen(documentId: incomplete_docIDs[index], 
                                                      profileId: profile,
                                                      name: surveyIncompleteItmes!.name,
                                                      email: surveyIncompleteItmes!.email,
                                                      phone: surveyIncompleteItmes!.phone,
                                                      address: surveyIncompleteItmes!.address,
                                                      propertyType: surveyIncompleteItmes!.propertyType,
                                                      date: surveyIncompleteItmes!.date,
                                                      time: surveyIncompleteItmes!.time,
                                                      message: surveyIncompleteItmes!.message,
                                                      geolocation: surveyIncompleteItmes!.geolocation,
                                                      status: surveyIncompleteItmes!.status,
                                                      userprofile: userprofile,
                                        )
                                      )
                                    );
                                },
                            ), 
                          );
                        },
                      );
                  },
                ),
                FutureBuilder(
                  future: getCompletedDocIds(profile.id, completed_docIDs),
                  builder: (context,snapshot){
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: completed_docIDs.toSet().toList().length,
                        itemBuilder: (context,index){
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 30, vertical:10),
                            child: ListTile(
                              leading: Icon(Icons.subject_outlined, color: Colors.red,),
                              title: GetSurveyName(documentId: completed_docIDs[index], profileId: profile.id, parameter: "address"),//Text(docIDs[index]),
                              trailing: Text("Completed"),
                              onTap: () async {
                                  surveyCompletedItmes = await getSurveyValues(completed_docIDs[index], profile.id);
                                  UserProfile? userprofile = await getProfile(profile.id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          SurveyReopen(documentId: completed_docIDs[index], 
                                                      profileId: profile,
                                                      name: surveyCompletedItmes!.name,
                                                      email: surveyCompletedItmes!.email,
                                                      phone: surveyCompletedItmes!.phone,
                                                      address: surveyCompletedItmes!.address,
                                                      propertyType: surveyCompletedItmes!.propertyType,
                                                      date: surveyCompletedItmes!.date,
                                                      time: surveyCompletedItmes!.time,
                                                      message: surveyCompletedItmes!.message,
                                                      geolocation: surveyCompletedItmes!.geolocation,
                                                      status: surveyCompletedItmes!.status,
                                                      userprofile: userprofile,
                                        )
                                      )
                                    );
                                },
                            ), 
                          );
                        },
                      );
                  },
                ),
              ]),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () async {
        UserProfile? userprofile = await getProfile(profile.id);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SurveyDetails(userProfile : userprofile)));
            //MaterialPageRoute(builder: (context) => SurveyListScreen()));
      },
      child: Icon(Icons.add),
      ),
    );
  }
  Future getDocIds(String profileId, List docIDs) async{
    await _db.collection("surveys").doc(profileId).collection("survey").get().then(
      (snapshot) => snapshot.docs.forEach((element) { 
        print(element.reference);
        docIDs.add(element.reference.id);
      }),
    );
  }

  Future getScheduledDocIds(String profileId, List scheduled_docIDs) async{
    await _db.collection("surveys").doc(profileId).collection("survey").get().then(
      (snapshot) => snapshot.docs.forEach((element) async { 
        print(element.reference);
        final snapshot =
                  await _db.collection("surveys").doc(profileId).collection("survey").doc(element.reference.id).get();
        var surveyValues = snapshot.data();
        targetScheduledSurvey =  Survey.fromJson(surveyValues!);
        
        if (DateTime.parse(targetScheduledSurvey!.date).isAfter(DateTime.now())){
              scheduled_docIDs.add(element.reference.id);
          }
      }),
    );
  }

  Future getIncompleteDocIds(String profileId, List incomplete_docIDs) async{
    await _db.collection("surveys").doc(profileId).collection("survey").get().then(
      (snapshot) => snapshot.docs.forEach((element) async { 
        print(element.reference);
        final snapshot =
                  await _db.collection("surveys").doc(profileId).collection("survey").doc(element.reference.id).get();
        var surveyValues = snapshot.data();
        targetIncompleteSurvey =  Survey.fromJson(surveyValues!);
        
        if (DateTime.parse(targetIncompleteSurvey!.date).isBefore(DateTime.now()) && (targetIncompleteSurvey!.status == 'incomplete')){
              incomplete_docIDs.add(element.reference.id);
          }
      }),
    );
  }

  Future getCompletedDocIds(String profileId, List complete_docIDs) async{
    await _db.collection("surveys").doc(profileId).collection("survey").get().then(
      (snapshot) => snapshot.docs.forEach((element) async { 
        print(element.reference);
        final snapshot =
                  await _db.collection("surveys").doc(profileId).collection("survey").doc(element.reference.id).get();
        var surveyValues = snapshot.data();
        targetCompletedSurvey =  Survey.fromJson(surveyValues!);
        
        if (targetCompletedSurvey!.status == 'complete'){
              complete_docIDs.add(element.reference.id);
          }
      }),
    );
  }
}