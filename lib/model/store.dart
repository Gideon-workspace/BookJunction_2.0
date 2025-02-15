import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'books.dart';

class Store extends ChangeNotifier{
  bool isLoading = false;

  //customer cart
  final List<Books> _cart =[];

  //getter methods to get the values outside this class

  //List<Books> get books => _books;
  List<Books> get cart=>_cart;

  //add to cart
  void addToCart(Books bookitem){
    _cart.add(bookitem);
    notifyListeners();
  }

  //remove from the cart

  void removeItem(Books bookitem){
    _cart.remove(bookitem);
    notifyListeners();
  }

  void clear() {
    _cart.clear();
    notifyListeners(); // Notify the UI to update
  }


  }