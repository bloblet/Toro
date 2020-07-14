import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toro_models/toro_models.dart' hide User;

import 'models/user.dart';
import 'utils.dart';

class AppInitializer {
  static AppInitializer _cache = AppInitializer._();
  AppInitializer._();
  factory AppInitializer() {
    return _cache;
  }

  static Box<User> me;
  static bool hasInitialized = false;
  static bool startedTimer = false;
  static Timer timer;
  static RemoteConfig remoteConfig;
  static Box<FetchCache> fetchCache;

  void startTimer() {
    if (!startedTimer) {
      User user = me.get('me');
      log('Starting timer');
      timer = Timer.periodic(Duration(minutes: 1), (_) {
        log('Updating');
        user.getMissedBalanceHistory();
        user.updateInventory(force: true);
        user.updateBalance(force: true);
      });
      startedTimer = true;
    }
  }

  Future<void> initOnesignal(User user) async {
    await OneSignal.shared.init('f88e9b0e-3c0b-4706-a032-080871499e12');

    await OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // TODO
      final symbol = result.notification.payload.additionalData['symbol'];
    });
  }

  Future<Box<User>> init(BuildContext context) async {
    if (!hasInitialized) {
      final start = DateTime.now();
      log('Starting initialization');
      FirebaseAdMob.instance
          .initialize(appId: "ca-app-pub-6084013412591482~5356667331")
          .then((v) =>
              log('Firebase done... ${msDiff(DateTime.now(), start)}ms'));

      remoteConfig = await RemoteConfig.instance;


      await OneSignal.shared
          .setLogLevel(OSLogLevel.fatal, OSLogLevel.none);
      log('Onesignal done... ${msDiff(DateTime.now(), start)}ms');

      await Hive.initFlutter();
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(StockAdapter());
      Hive.registerAdapter(UserSettingsAdapter());
      Hive.registerAdapter(PortfolioChangeEventAdapter());
      Hive.registerAdapter(FetchCacheAdapter());
      // If you need to test logging in, uncomment the next two lines
      await Hive.deleteBoxFromDisk('me');
      log('Deleted me box', type: Severity.warning);

      me = await Hive.openBox<User>('me');
      fetchCache = await Hive.openBox<FetchCache>('fetchCache');
      log('Hive done... ${msDiff(DateTime.now(), start)}ms');
      hasInitialized = true;
    }
    return me;
  }
}
