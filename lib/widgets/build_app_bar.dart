import "package:flutter/material.dart";

AppBar buildAppBar(String title) {
  return AppBar(
    title: Text(title),
    backgroundColor: Colors.white,
    centerTitle: true,
    elevation: 4.0,
  );
}