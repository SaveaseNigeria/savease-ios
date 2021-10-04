import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class About extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<About> with TickerProviderStateMixin {
  MenuController menuController;
  String accountName = "";

  void getData() async{
    final prefs = await SharedPreferences.getInstance();

    String  fname = prefs.getString('fname') ?? '';
    String  lname = prefs.getString('lname') ?? '';


    if(fname != null || fname != ""){

      setState(() {
        accountName = fname +" "+ lname;

      });

    }else{
      accountName = "";

    }


  }

  @override
  void initState() {
    getData();
    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
          builder: (context) => menuController,
          child: ZoomScaffoldActivities(
            menuScreen: MenuScreen(),
            contentScreen: Layout(
                contentBuilder: (cc) => Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: Container(
                            color: Color(0xff212435),
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: Center(
                                child: Text(
                                  "About Savease",
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,

                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: SingleChildScrollView(
                                        physics: AlwaysScrollableScrollPhysics(),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 20,left: 15,right: 15,bottom: 250),
                                          child: Text("Africa's Easy Deposit & Payment Gateway\n\n Savease was established to create simple solutions to complex savings and payment problem. It was designed and created to initiate, develop and modernise payment system.\n\n In 2012, the Central Bank of Nigeria created a Vision 2020 Cashless Policy the for a number of key reasons, including: \n\n 1. To drive development and modernization of our payment system in line with Nigeria's vision 2020 goal of being amongst the top 20 economies by the end of 2020. An efficient and modern payment system is positively correlated with economic development and is a key enabler for economic growth.\n\n 2. To reduce the cost of Banking services (including cost of credit) and drive financial inclusion by providing more efficient transaction options and greater reach.\n\n 3. To improve the effectiveness of Monetary Policy in managing inflation and driving economic growth.\n\n In addition, the CBN Vision 2020 Cashless Policy aims to curb some of the negative consequences associated with the high usage of physical cash in the economy including:\n\n 1. High Cost of Cash\n 2. High Risk of Using Cash\n 3. Informal Economy\n 4. High Subsidy\n Inefficiency & Corruption\n\n In line with the policy by the CBN, we have designed and created a product called SAVEASE, to:\n\n 1. Bank the Unbanked\n 2. Fund the Unfunded Accounts\n 3. Implement the Cashless Policy of the CBN\n 4. Curb the Spread of the Deadly Corona Virus\n 5. Reduce Unemployment in Nigeria\n\nAs indicated in our Memorandum of Association with the Corporate Affair Commission, the Objects for which the Company was established are:\n\n 1. To develop and design micro softwares, internet/website designing to ease the banking system and sales of goods.\n 2. To carry on business with Banks in Nigeria in implementing the Cashless Policy of the Central Bank of Nigeria.\n 3. To intimate the average Nigerian on Banking Policies and the effect of Banking. To carry on business of general contracts, imports, exports of general goods, general merchants, to act as a manufacturer representative for this purpose. \n 4. To develop products that will benefit Nigerians and the Nigerian Banks.\n\nWe recognise the banking constraint of distance, time, space and structure which is experienced when making small scale deposit payments into banks; thus, we created an excellent solution to this experience.\n\n We recognise the large number of unbanked population in the country; thus, we created a perfect product to enable grassroots banking.\n\n We recognise the large number of unfunded bank accounts which in turn affects the potential financial base of financial institutions like yours; thus, we have created a service which allows making deposits from the comfort of anywhere.\n\n We recognise the need to drive development and modernisation of our payment system in line with CBN’s Vision 2020 which is indicated in the Cashless Policy of the CBN; thus we created a modernised simple payment gateway which allows Users to pay for goods and service (transactions) without the use of physical cash.\n\n We recognise that unemployment is on the rise, as many Nigerians are without jobs or a means of livelihood; thus, we are creating job opportunities and a means of livelihood which will in turn enhance economic development.\n\n We also recognise that a good saving habit is vital to capital development and financial independence; thus we have provided a simple yet compelling tool/approach to help every person achieve this fundamental goal.\n\n We recognise that the easiest way to spread the deadly corona virus is through the medium of exchange called Money; thus we have created an alternative means for making transactions in other to curb the spread of the deadly COVID 19.\n\n It is said that the underlying foundation to good products are made up of 3 components:\n\n * Functionality\n * Reliability\n * Ease of Use\n\n These components are met; thus, qualifying SAVEASE as a good product for the Market. It has been designed to create habits, educate financial literacy, inspire emotions, and ultimately become an indispensable utility tool.  ", style: new TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold,fontFamily: "sfprodisplaylight", ),),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: Container(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xff212435),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                //your elements here
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'Copyrights © 2016 All Rights Reserved. Powered by Savease Nigeria Limited, a sub-class of Savease Africa.',
                                          style: TextStyle(
                                              fontFamily: "sfprodisplaybold",
                                              fontSize: 11.0,
                                              color: Colors.white)),
                                    )),
                              ],
                            ),
                          )),
                    )
                  ],
                )),
          ),
        ));
  }
}
