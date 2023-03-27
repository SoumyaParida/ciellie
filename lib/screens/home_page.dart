import 'package:Ciellie/models/profile.dart';
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
      userProfile = UserProfile.fromJson(snapshot.docs.first.data());
      print("userProfile{$userProfile}");
      
      setState(() {
        
        isInitialDataFetched = true;
      });
      //setState(() => isInitialDataFetched = true);
      //super.initState();
    });
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
      drawer: NavDrawer(user: this.user, userProfile : this.userProfile),
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
                              //leading: Icon(Icons.call_missed, color: Colors.red,),
                              title: GetSurveyName(documentId: docIDs[index], profileId: profile.id),//Text(docIDs[index]),
                              onTap: (){
                                
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SurveyReopen(documentId: docIDs[index], userProfile: this.userProfile)));
                                      //MaterialPageRoute(builder: (context) => SurveyListScreen()));
                                },
                              
                              /*onTap: (){
                                SurveyReopen(documentId: docIDs[index], userProfile: this.userProfile);
                              },*/
                              //subtitle: Text("Missed call from person ${index+1}"),
                              //trailing: Icon(Icons.phone_callback, color: Colors.green,),
                            ), 
                          );
                        },
                      );
                  },
                ),
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context,index){
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical:10),
                      child: ListTile(
                        leading: Icon(Icons.call_missed, color: Colors.red,),
                        title: Text("Person ${index+1}"),
                        subtitle: Text("Missed call from person ${index+1}"),
                        trailing: Icon(Icons.phone_callback, color: Colors.green,),
                      ), 
                    );
                  },
                ),
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context,index){
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical:10),
                      child: ListTile(
                        leading: Icon(Icons.call_missed, color: Colors.red,),
                        title: Text("Person ${index+1}"),
                        subtitle: Text("Missed call from person ${index+1}"),
                        trailing: Icon(Icons.phone_callback, color: Colors.green,),
                      ), 
                    );
                  },
                ),
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context,index){
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical:10),
                      child: ListTile(
                        leading: Icon(Icons.call_missed, color: Colors.red,),
                        title: Text("Person ${index+1}"),
                        subtitle: Text("Missed call from person ${index+1}"),
                        trailing: Icon(Icons.phone_callback, color: Colors.green,),
                      ), 
                    );
                  },
                ),
              ]),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SurveyDetails(userProfile : this.userProfile)));
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
}