import 'package:flutter/material.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubjectStore extends Store {
  List<String> _subjects = [
    "Ciencias",
    "Física",
    "Biología",
    "Anatomía y fisiología",
    "Matemáticas",
    "Química",
    "Ecología",
    "Metodología de la investigación",
    "Ciencias sociales",
    "Geografía",
    "Economía",
    "Medio ambiente",
    "Biografías",
    "Arte",
    "Historia del arte",
    "Filosofía",
    "Historia",
    "Ética y valores",
    "Literatura",
    "Lengua española",
    "Inglés",
    "Informática",
    "Psicología",
    "Educación física",
    "Tecnología",
    "Política",
    "Religión",
    "Salud",
    "Educación"
  ];
  List<String> get subjects {
    return _subjects;
  }

  Icon getSubjectIcon(String subject, {double size = 24}) {
    IconData ico = Icons.book;
    Color color = Colors.grey;
    switch (subject) {
      case "Ciencias":
        ico = FontAwesomeIcons.microscope;
        break;
      case "Física":
        ico = FontAwesomeIcons.weight;
        break;
      case "Biología":
        ico = FontAwesomeIcons.paw;
        break;
      case "Anatomía y fisiología":
        ico = FontAwesomeIcons.male;
        break;
      case "Matemáticas":
        ico = FontAwesomeIcons.calculator;
        break;
      case "Química":
        ico = FontAwesomeIcons.atom;
        break;
      case "Ecología":
        ico = FontAwesomeIcons.seedling;
        break;
      case "Metodología de la investigación":
        ico = FontAwesomeIcons.search;
        break;
      case "Ciencias sociales":
        ico = FontAwesomeIcons.userFriends;
        break;
      case "Geografía":
        ico = FontAwesomeIcons.mapPin;
        break;
      case "Economía":
        ico = FontAwesomeIcons.coins;
        break;
      case "Medio ambiente":
        ico = FontAwesomeIcons.tree;
        break;
      case "Arte":
        ico = FontAwesomeIcons.paintBrush;
        break;
      case "Filosofía":
        ico = FontAwesomeIcons.scroll;
        break;
      case "Historia":
        ico = FontAwesomeIcons.hourglass;
        break;
      case "Ética y valores":
        ico = FontAwesomeIcons.balanceScale;
        break;
      case "Literatura":
        ico = FontAwesomeIcons.bookOpen;
        break;
      case "Lengua española":
        ico = FontAwesomeIcons.language;
        break;
      case "Inglés":
        ico = FontAwesomeIcons.language;
        break;
      case "Informática":
        ico = FontAwesomeIcons.laptop;
        break;
      case "Psicología":
        ico = FontAwesomeIcons.brain;
        break;
      case "Educación física":
        ico = FontAwesomeIcons.dumbbell;
        break;
      case "Tecnología":
        ico = FontAwesomeIcons.laptop;
        break;
      case "Política":
        ico = FontAwesomeIcons.gavel;
        break;
      case "Religión":
        ico = FontAwesomeIcons.prayingHands;
        break;
      case "Salud":
        ico = FontAwesomeIcons.firstAid;
        break;
      case "Educación":
        ico = FontAwesomeIcons.school;
        break;
    }
    return Icon(ico, size: size, color: color);
  }
}
