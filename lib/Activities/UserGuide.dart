import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserGuide extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}

class _HoomeState extends State<UserGuide> with TickerProviderStateMixin {
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
                              "User Guide",
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
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height/1.2,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: Container(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.height,

                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10,left: 15),
                                          child: Text("Dear ${accountName},", style: new TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, ),),
                                        ),
                                      ),
                                          Flexible(
                                            child: SingleChildScrollView(
                                              physics: AlwaysScrollableScrollPhysics(),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 20,left: 15,right: 15),
                                                child: Text("SAVEASE was established to create simple solutions to complex deposit and savings problem. It is a useful solution that will promote effective savings habit. \n\nWe have created a technology which uses instant deposit prepaid scratch cards pins. Offering its users: a simple and convenient way to make deposits into distinctive bank accounts across the continent starting from Nigeria. \n\nWith this technological breakthrough, you can make deposit transaction from anywhere with ease. \n\nTo verify the validity of a voucher, simply click on the Verify icon on the dashboard. Insert the prepaid pin, then click on the verify button. A pop up will display on your screen, with information about the card. \n\nTo make a transfer transaction, click on the Transfer icon on the dashboard, select the appropriate account or wallet type from the dropdown menu. You could select Savease Wallet/Account; if you intend to make a transfer into a Savease account or select Bank Account if you intend to make a deposit to a bank account other than Savease. Insert the account number, the amount to be transferred, a narration for the transaction, your secret pin. Then proceed to click on the continue button. Select confirm in the attestation box on the screen, or select discard to discontinue the transaction. The account so provided will be automatically credited with the amount so transfer. \n\nTo make a deposit transaction, click on the Deposit icon on the dashboard, select the appropriate account or wallet type from the dropdown menu. You could select My Wallet/Account; if you intend to make a deposit into your account or select Other Wallet/Account if you intend to make a deposit to a different recipient. Insert the account number, voucher pin, followed with a narration for the transaction. Then proceed to click the continue button. The account so provided will be automatically credited with the value of the pin provided. \n\nTo do a Buy Voucher transaction make sure you have adequate funds in your account, else fund your account by clicking on the fund account icon; then follow through the process using your ATM card before initiating this process. \n\nIf account is adequately funded for a potential transaction. Kindly choose the card denomination from the dropdown tab. Insert the quantity of voucher to be purchased into the quantity box, followed by your secret pin code. Proceed to clicking the buy card button. Click on terms and conditions if you have not read it before, or proceed to check the check box to agree and accept the terms and conditions. Proceed to Place Order to complete your purchase, or the Discard button to discard the purchase. If transaction is successful, a successful alert will be displayed, else a not successful message will be prompted. Thereafter, check your voucher table from your dashboard, and filter the drop down tab to display used cards. \n\nThe Voucher Table is an environment which helps you with the arrangement and management of voucher. In this section, you are presented with Used and Unused cards. To view this, select the Voucher Table icon on your dashboard. Either select from the dropdown tab to display your entire Used Voucher or all Unused Vouchers. The used voucher presents all details about a used voucher; it supplies you information ranging from time/date of use, name of the user, among other details. \n\nTo fund an account, select the fund account icon on your dashboard. Proceed to provide your ATM card details as requested on the screen. A onetime password (OTP) will be sent to the telephone number of the ATM card to confirm ownership of the card. Provide this OTP, and your Savease Account will be funded with the amount so funded. \n\nTo view your transaction summary, simply select the Statement icon on your dashboard. You will be presented with a log of all your transactions. \n\nThe account officer icon on your dashboard, directs you to the assigned savease personnel, whose duty is to help you understand money, help you with your savings and ultimately help you gain financial freedom. He/she also helps you in resolving any technical complaints that may be observed. Feel free to contact him/her through the channels so provided. \n\nNotifications are sent to your notification box icon on the dashboard below. Please ensure to always read all messages that appear in this box; as products and offers will be sent to your box. \n\nTransaction alert are stored in the message icon that appears on the top right view of the dashboard. Here you can confirm or refer transaction when necessary. \n\nTo make a withdrawal from your account. Click on the withdraw icon, provide the receiving bank account details. Proceed to verify, immediately the system automates your transaction and you will get a credit alert. Please note that you must have a minimum balance of one thousand five hundred naira. \n\nPlease ensure to send feedback through the complaint icon seen below on the dashboard. \n\nThank you for trusting us to help you.\n\n\n\n ", style: new TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, ),),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
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
