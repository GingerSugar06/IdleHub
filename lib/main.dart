// ignore_for_file: deprecated_member_use
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tray_manager/legacy.dart';
import 'package:window_manager/window_manager.dart';

import 'core/autostart.dart';
import 'core/l10n.dart';
import 'core/theme.dart';
import 'data/store.dart';
import 'state/app_state.dart';
import 'ui/shell.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tek örnek
  try {
    await ServerSocket.bind(InternetAddress.loopbackIPv4, 47312);
  } on SocketException {
    exit(0);
  }

  await windowManager.ensureInitialized();
  final store = await Store.open();
  final ps = await store.load();
  final app = AppState(store, ps);

  final minimized = args.contains('--minimized') || ps.settings.startMinimized;
  await windowManager.waitUntilReadyToShow(
    const WindowOptions(
      size: Size(1120, 740),
      minimumSize: Size(940, 600),
      center: true,
      titleBarStyle: TitleBarStyle.hidden,
      backgroundColor: C.bg,
      title: 'Idle Hub',
    ),
    () async {
      if (!minimized) {
        await windowManager.show();
        await windowManager.focus();
      }
    },
  );
  await windowManager.setPreventClose(true);

  final desktop = Desktop(app);
  await desktop.init();
  runApp(IdleApp(app: app));
  app.init();
}

/// Pencere kapatma, tepsi ve "Windows ile başlat" işleri.
class Desktop with TrayListener, WindowListener {
  Desktop(this.app);
  final AppState app;
  String? _lastSig;

  S get s => app.s;

  Future<void> init() async {
    windowManager.addListener(this);
    trayManager.addListener(this);
    app.addListener(_sync);
    await _sync();
  }

  Future<void> _sync() async {
    if (!Platform.isWindows) return;
    final live = app.totalLive();
    final sig = '${app.settings.lang}|${live > 0}';
    if (sig == _lastSig) return;
    _lastSig = sig;
    await trayManager.setIcon(live > 0 ? 'assets/tray/tray_active.ico' : 'assets/tray/tray_off.ico');
    await trayManager.setToolTip(live > 0 ? 'Idle Hub — ${s.t('tray_idling', {'n': '$live'})}' : 'Idle Hub');
    await trayManager.setContextMenu(Menu(items: [
      MenuItem(key: 'show', label: s.t('tray_show')),
      MenuItem(key: 'stop', label: s.t('tray_stop_all')),
      MenuItem.separator(),
      MenuItem(key: 'quit', label: s.t('tray_quit')),
    ]));
  }

  Future<void> show() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> quit() async {
    await app.shutdown();
    await trayManager.destroy();
    await windowManager.setPreventClose(false);
    exit(0);
  }

  @override
  void onTrayIconMouseDown() => show();
  @override
  void onTrayIconRightMouseDown() => trayManager.popUpContextMenu();
  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show':
        show();
      case 'stop':
        app.stopEverything();
      case 'quit':
        quit();
    }
  }

  @override
  void onWindowClose() async {
    if (app.settings.closeToTray) {
      await windowManager.hide();
    } else {
      await quit();
    }
  }

  Future<void> setLaunchAtLogin(bool v) async {
    app.settings.launchAtLogin = v;
    await setLaunchAtLoginReg(v);
    await app.saveSettings();
  }
}

class IdleApp extends StatelessWidget {
  const IdleApp({super.key, required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Idle Hub',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: Shell(app: app),
      );
}
