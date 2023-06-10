// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomepage extends StatefulWidget {
  const MyHomepage({Key? key}) : super(key: key);

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  int _page = 0;
  late List<dynamic> newsList = [];

  Future<void> apicall() async {
    final response = await http.post(
      Uri.parse(
          'http://devapi.hidoc.co:8080/HidocWebApp/api/getArticlesByUid?sId=500&uuId=&userId=423914'),
    );
    if (response.statusCode == 200) {
      setState(() {
        final responseData = json.decode(response.body);
        newsList = responseData.containsKey('data')
            ? responseData['data']['trandingBulletin']
            : [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apicall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: GNav(
          textStyle: TextStyle(color: Colors.black),
          activeColor: Colors.amber,
          tabBackgroundColor: Colors.grey.shade400,
          padding: EdgeInsets.all(10.0),
          gap: 10.0,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.favorite_border,
              text: 'Links',
            ),
            GButton(
              icon: Icons.person,
              text: 'User',
            ),
            GButton(
              icon: Icons.verified_user,
              text: 'Verify',
            ),
          ],
        ),
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   items: [
      //     Icon(Icons.add, size: 30),
      //     Icon(Icons.list, size: 30),
      //     Icon(Icons.compare_arrows, size: 30),
      //     Icon(Icons.call_split, size: 30),
      //     Icon(Icons.perm_identity, size: 30),
      //   ],
      //   color: Colors.amber.withOpacity(0.4),
      //   buttonBackgroundColor: Colors.white,
      //   backgroundColor: Colors.white,
      //   animationCurve: Curves.easeInOut,
      //   animationDuration: Duration(milliseconds: 300),
      //   onTap: (index) {
      //     setState(() {
      //       _page = index;
      //     });
      //   },
      //   letIndexChange: (index) => true,
      // ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Need to give route
          },
          icon: Icon(
            Icons.house_siding_outlined,
            color: Colors.black,
            size: 40,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "HiDoc App",
          style: TextStyle(color: Colors.black),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 20,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -350,
            left: -250,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/bg.png', // Replace with your image path
                fit: BoxFit.contain,
                opacity: const AlwaysStoppedAnimation(0.5),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 150,
                  ),
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.4),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Tranding Bulletin",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final newsItem = newsList[index];
                    final articleImg = newsItem['articleImg'] ?? '';
                    return Column(
                      children: [
                        Container(
                          height: 350,
                          width: 350,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                newsItem['articleTitle'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                newsItem['articleDescription'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
