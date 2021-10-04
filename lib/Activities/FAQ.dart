
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savease/Utils/ZoomScaffoldActivites.dart';
import 'package:savease/Utils/menu_page.dart';




String smsPrivateKey = '9Pc1XtdCYg43wdJ6AlbCSCyTlLqc2voEFpl9DvmUq0zcKJTDbdE4aOYOPtzz';
String apiKey = 'Bearer sk_live_0dc08582961f9c1d0785245c36bc4a65658ce187';
class Faq extends StatefulWidget {
  @override
  _HoomeState createState() => new _HoomeState();
}




class _HoomeState extends State<Faq> with TickerProviderStateMixin {



  MenuController menuController;
  @override
  void initState() {
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
                  child: Center(child: Text("FAQ", style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal,color: Colors.white),textAlign: TextAlign.center,)),


                ),
            ),
            Flexible(
              child: Container(
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  height: 600.0,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: vehicles.length,
                      itemBuilder: (BuildContext ctxt, int i){

                        return new ExpansionTile(
                          title: new Text(vehicles[i].title, style: new TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, ),),
                          children: <Widget>[
                            new Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 20,bottom: 10),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(vehicles[i].answer, style: new TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, ),)),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),

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



class Vehicle {
  final String title;
  final String answer;


  Vehicle(this.title, this.answer);
}

List<Vehicle> vehicles = [
  new Vehicle(
    'What is Savease',
    'Savease is a financial solution that solves the complex problem of making deposits and savings. It is available as a USSD App, Mobile App, and a Web App. It adopts the style of scratch cards, but uses preloaded prepaid deposit pin as exchange for value, thereby translating paper money into electronic money which is then understood electronically. It is helping millions of people save their money, due to convenience it presents and represents. It has broken the banking barrier of distance, space and structure. ',

  ),
  new Vehicle(
    'Getting started with Savease',
    'You can get started on any of the following: USSD, Mobile App and Web App. To use the USSD App, kindly dial the *0456#, then follow the on-screen options to sign up to Savease. You can use the Mobile App by downloading it from Playstore for Android users or Applestore for IOS users. When downloaded, navigate to the Register now page, then fill in the required information. You can also log on to www.savease.ng, then nagivate to sign up page.',

  ),
  new Vehicle(
    'What is a username',
    'A username is a unique identification used by a person with access to the Savease online services',

  ),
  new Vehicle(
    'Changing your password',
    'To change your password, log on to Savease, then navigate to your profile page. Click on Change Password',

  ),
  new Vehicle(
    'Forgot Password',
    'To change your password, kindly go to your login page. Click on Forgot Password. Type in your Savease ID, which is also your wallet/account number. A password change link will be generated and sent to email address used during registration.',

  ),
  new Vehicle(
    'How to make a deposit to your wallet/account',
    'Kindly locate and purchase a Savease prepaid deposit card with the equivalent value of money from the nearest authorized vendor. Open the Savease mobile app and login. Select the Deposit icon on the dashboard. Select self deposit. Provide the card pin then proceed by clicking the make deposit button. A success message will be sent if transaction is successful, also a failure message will be received.',

  ),
  new Vehicle(
    'How to make a deposit to another wallet/account',
    'Kindly locate and purchase a Savease prepaid deposit card with the equivalent value of money from the nearest authorized vendor. Open the Savease mobile app and login. Select the Deposit icon on the dashboard. Provide the card pin, wallet/account number, then proceed by clicking the make deposit button. A success message will be sent if transaction is successful, also a failure message will be received.',

  ),
  new Vehicle(
    'How to transfer money from a wallet to another wallet',
    'Login. Click on the transfer icon or navigation button. Click on the select transfer type and select Savease Account. Provide the wallet ID of the recipient, followed by the amount to be transferred. Confirm the attestation. A success message will be sent if transaction is successful, else a failure message will be received.',

  ),
  new Vehicle(
    'How to transfer money from your wallet to a bank account',
    'Login. Click on the Transfer icon or the navigation bar. Click on the dropdown tab or button to select the appropriate account. Click on other bank, then select the appropriate bank as available in the drop-down tab. Insert the account number of the recipient, followed by the amount to be transferred. Confirm the attestation. A success message will be sent if transaction is successful, also a failure message will be received.',

  ),
  new Vehicle(
    'How to become a Vendor on Savease',
    'All registered Savease users are Vendors. Login to Savease, then navigate to the buy voucher icon and vendor table. On the vendor table, click on Request for Vendor Materials. A Savease representative will contact you to complete your registration.',

  ),
  new Vehicle(
    'How to buy the Savease prepaid deposit cards',
    'Savease vouchers are available in stores, markets, minimarkets, neighboring shops, kiosks and any other place where human activities are done. You could also buy the prepaid cards from the mobile app or web app by logging in, then navigate to the buy voucher page.',

  ),
  new Vehicle(
    'What to do if a Savease voucher is misplaced or stolen',
    'Login to the web application. Click on Voucher Table navigation bar. Select the Block Voucher radio button. The block voucher button present an elevated section where vouchers can be blocked, whenever there is a case of misplacement or theft. You can block vouchers by their serial number, voucher pin or batch code. Once blocked, the vouchers will be rebatched and the rebatched vouchers will be sent to your inbox and voucher table.',

  ),
  new Vehicle(
    'How to make money on Savease',
    'Everything',

  ),
  new Vehicle(
    'How to block vouchers and rebatch them',
    'After logging in to the web application, navigate to the voucher table. You will find two radio button labelled Voucher Table and Block Voucher. Select the block voucher button, which present an elevated section where vouchers can be blocked, whenever there is a case of misplacement or theft. You can block vouchers by their serial number, voucher pin or batch code. Once blocked, the vouchers will be rebatched and the rebatched vouchers will be sent to your inbox and voucher table. ',

  ),
  new Vehicle(
    'How to view your transaction summary on Savease',
    'Login. On your dashboard, open the statement icon, which presents a list of your transactions. According to date, time,amount,beneficiary name, among others',

  ),
  new Vehicle(
    'Who is an account officer',
    'The account officer assigned to you is tasked with the responsibility of helping you gain financial literacy. His/her ultimate purpose is to help you build capital through savings then design financial packages to aid you gain financial independence.',

  ),
  new Vehicle(
    'Is Savease a bank',
    'No. it is not bank. It is a financial technology corporation in partnership to the banking and other financial institutions.',

  ),
  new Vehicle(
    'Reporting a problem',
    'From the mobile app, navigate to the complaint page and fill in as requested. Otherwise, call customer care on 456; or log on to www.savease.ng , then navigate to the compliant page to fill in the required information. ',

  ),
  new Vehicle(
    'Updating Savease',
    'Periodically, modifications are made available to serve you better. This update will require you to download a new version from Google playstore or Apple store respectively. Updates on the web applications are automatic, and will not require you downloading anything. The USSD update are made available automatically, but with adequate user guide information as they become available.',

  ),
  new Vehicle(
    'How to use Savease on your computer',
    'To use Savease on your computer, you will log on to the www.savease.ng from a web browser.',

  ),
  new Vehicle(
    'Reinstalling Savease',
    'Kindly go to google playstore or apple store respectively. Download and install the Savease app.',

  ),
  new Vehicle(
    'Where can i buy Savease Voucher',
    'Savease vouchers are available in stores, markets, minimarkets, neighbouring shops, kiosks and any other place where human activities are done. You could also buy the prepaid cards from the mobile app or web app by logging in, then navigate to the buy voucher page.',

  ),
  new Vehicle(
    'How many wallet can i have',
    'Due to regulations, you can only have a maximum of 3 wallets attached to a BVN.',

  ),
  new Vehicle(
    'How to fund your account',
    'Login. On your dashboard, click on your fund account icon. Provide details from credit card you intend to fund your account with. An OTP(One Time Password) will be sent to the credit card telephone number which will be provided upon request. Your account will be credited and updated with the equivalent.3',

  ),
  new Vehicle(
    'What is Pin Code',
    'This is your private identification number which serves as a personal secret number that should not be disclosed to any other person, which will serve as your true authentication and signature.',

  ),
  new Vehicle(
    'How to make withdrawal',
    'Login. CLick on the withdraw icon on the dashboard. Provide the receiving bank details, followed with your personal secret pin, then click on the verify button. Automatically the transaction will be processed and a credit alert will received. Please note that to make a withdrawal you must have a minimum balance of one thousand five hundred naira.',

  ),
];

