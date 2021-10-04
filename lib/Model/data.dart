import 'package:flutter/material.dart';

var pageList = [
  PageModel(
      imageUrl: "assets/image/trust.svg",
      title: "MUSIC",
      body: "Trust savease \nto reach your goals",
      logo: "assets/image/logo.png"
      ),
  PageModel(
      imageUrl: "assets/image/teaching.svg",
      title: "SPA",
      body: "Teaching \nyou about money",
      logo: "assets/image/logo.png"),
  PageModel(
      imageUrl: "assets/image/freedom.svg",
      title: "TRAVEL",
      body: "Gaining\nfinancial freedom",
      logo: "assets/image/logo.png"),

  PageModel(
      imageUrl: "assets/image/passionate.svg",
      title: "TRAVEL",
      body: "Passionate\nabout helping you",
      logo: "assets/image/logo.png"),

  PageModel(
      imageUrl: "assets/image/happiness.svg",
      title: "TRAVEL",
      body: "Giving\nyou a life time of happiness",
      logo: "assets/image/logo.png"),

];



class PageModel {
  var imageUrl;
  var title;
  var body;
  var logo;

  PageModel({this.imageUrl, this.title, this.body,this.logo});
}