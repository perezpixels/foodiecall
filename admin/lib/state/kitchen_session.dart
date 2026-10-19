import 'package:flutter/material.dart';

class KitchenSession extends ChangeNotifier {
  bool provisioned = false;
  bool acceptingOrders = true;
  bool notificationsOpen = false;
  bool darkMode = false;
  String? toast;

  void toggleTheme() {
    darkMode = !darkMode;
    notifyListeners();
  }

  void completeProvisioning() {
    provisioned = true;
    notifyListeners();
  }

  void signOut() {
    provisioned = false;
    acceptingOrders = true;
    notificationsOpen = false;
    notifyListeners();
  }

  void toggleAccepting() {
    acceptingOrders = !acceptingOrders;
    showToast(acceptingOrders ? 'Kitchen is accepting orders' : 'Inflow paused');
  }

  void toggleNotifications() {
    notificationsOpen = !notificationsOpen;
    notifyListeners();
  }

  void closeNotifications() {
    if (!notificationsOpen) return;
    notificationsOpen = false;
    notifyListeners();
  }

  void showToast(String message) {
    toast = message;
    notifyListeners();
    Future<void>.delayed(Duration(milliseconds: 2800), () {
      if (toast == message) {
        toast = null;
        notifyListeners();
      }
    });
  }
}
