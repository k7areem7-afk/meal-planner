// Language switch. Arabic is the source language; tx() picks the English
// text when the user chose English in Settings.

class L {
  static bool en = false;
}

String tx(String ar, String en) => L.en ? en : ar;
