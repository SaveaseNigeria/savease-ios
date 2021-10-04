import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

const baseUrl = "https://api.paystack.co";

class API {
  static Future getUsers() {
    var url = baseUrl + "/bank";
    return http.get(url,
      headers: {HttpHeaders.authorizationHeader: "Bearer sk_live_0dc08582961f9c1d0785245c36bc4a65658ce187"},
    );
  }


  static Future getAccount() {
    var url = baseUrl + "bank/resolve";
    return http.get(url,
      headers: {HttpHeaders.authorizationHeader: "Bearer sk_live_0dc08582961f9c1d0785245c36bc4a65658ce187"},
    );
  }


}
