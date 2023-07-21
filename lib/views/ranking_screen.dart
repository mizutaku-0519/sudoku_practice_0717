import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sudoku_practice_0717/widgets/advetisement_area.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List<String> rankingData = List<String>.generate(100, (index) => "Player ${index + 1}");  // Dummy data
  List<int> scores = List<int>.generate(100, (index) => 100 - index);  // Dummy scores
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Color crownColor(int rank) {
    switch(rank) {
      case 1: return Color(0xFFe6b422);
      case 2: return Color(0xFFbfc5ca);
      case 3: return Color(0xFFb87333);
      default: return Colors.transparent;
    }
  }

  String getRank(int index) {
    return "${index + 1}位";
  }

  Widget buildRankingList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Add horizontal padding
      itemCount: rankingData.length,
      separatorBuilder: (context, index) {
        return Divider(indent: 10, endIndent: 10);
      },
      itemBuilder: (context, index) {
        return ListTile(
          leading: (index < 3)
              ? FaIcon(FontAwesomeIcons.crown, color: crownColor(index + 1), size: 18)
              : Text(getRank(index), style: TextStyle(fontSize: 16)),
          title: Text(rankingData[index], style: TextStyle(fontSize: 16)),
          trailing: Text(scores[index].toString(), style: TextStyle(fontSize: 16)),
        );
      },
    );
  }

  String getCurrentWeek() {
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    DateTime sunday = now.add(Duration(days: 7 - now.weekday));

    final formatter = DateFormat('M月dd日');
    return "${formatter.format(monday)}〜${formatter.format(sunday)} の累計獲得スコアランキング";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(  // Add horizontal padding to AppBar title
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("週間ランキング"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Add horizontal padding to body
        child: Column(
          children: [
            SizedBox(height:10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.crown, color: Color(0xFF1e50a2), size: 13),
                  SizedBox(width: 10),
                  Flexible(  // Add Flexible here
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13, color: Color(0xFF1e50a2), fontWeight: FontWeight.normal, ),
                        children: <TextSpan>[
                          TextSpan(
                            text: getCurrentWeek().substring(0,11),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              decorationColor: Color(0xFF1e50a2),
                            ),
                          ),
                          TextSpan(text: getCurrentWeek().substring(11),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 7),
                  // FaIcon(FontAwesomeIcons.crown, color: Color(0xFF1e50a2), size: 13),
                ],
              ),
            ),
            SizedBox(height: 10),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: '初級'),
                Tab(text: '中級'),
                Tab(text: '上級'),
                Tab(text: '達人級'),
              ],
              unselectedLabelColor: Color(0xFF1e50a2),
              labelColor: Color(0xFF1e50a2),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),  // Make selected label text bold
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),  // Make unselected label text normal
            ),
            SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildRankingList(),
                  buildRankingList(),
                  buildRankingList(),
                  buildRankingList(),
                ],
              ),
            ),
            SizedBox(height: 10),
            AdvertisementArea(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
