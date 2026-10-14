/// Kalıcı veri.
///
/// * `state.json` (uygulama veri klasörü): hesap listesi (token YOK), favoriler,
///   özel oyunlar, kasılan oyun kümeleri, ayarlar.
/// * Windows Kimlik Bilgisi Yöneticisi (flutter_secure_storage): refresh
///   token'lar ve Web API anahtarı. Sır içeren hiçbir şey düz dosyaya yazılmaz.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Settings {
  String lang = 'tr';
  bool closeToTray = true;
  bool startMinimized = false;
  bool launchAtLogin = false;
  bool gamesOnly = true;

  Map<String, dynamic> toJson() => {
        'lang': lang,
        'closeToTray': closeToTray,
        'startMinimized': startMinimized,
        'launchAtLogin': launchAtLogin,
        'gamesOnly': gamesOnly,
      };

  void load(Map<String, dynamic> j) {
    if (j['lang'] == 'tr' || j['lang'] == 'en') lang = j['lang'] as String;
    closeToTray = j['closeToTray'] as bool? ?? closeToTray;
    startMinimized = j['startMinimized'] as bool? ?? startMinimized;
    launchAtLogin = j['launchAtLogin'] as bool? ?? launchAtLogin;
    gamesOnly = j['gamesOnly'] as bool? ?? gamesOnly;
  }
}

class CustomGame {
  CustomGame(this.appId, this.name);
  final int appId;
  final String name;
  Map<String, dynamic> toJson() => {'id': appId, 'name': name};
}

class AccountInfo {
  AccountInfo({
    required this.id,
    this.label = '',
    this.accountName = '',
    this.persona = '',
    this.steam64 = '',
    List<int>? appIds,
    this.autoResume = true,
  }) : appIds = appIds ?? [];

  final String id;
  String label;
  String accountName;
  String persona;
  String steam64;

  /// Bu hesapta kasılması İSTENEN oyunlar (uygulama açılınca sürdürülür).
  List<int> appIds;
  bool autoResume;

  /// Listede görünecek ad.
  String get display {
    if (label.trim().isNotEmpty) return label.trim();
    if (persona.isNotEmpty) return persona;
    if (accountName.isNotEmpty) return accountName;
    return '';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'accountName': accountName,
        'persona': persona,
        'steam64': steam64,
        'appIds': appIds,
        'autoResume': autoResume,
      };

  factory AccountInfo.fromJson(Map<String, dynamic> j) => AccountInfo(
        id: j['id'] as String,
        label: j['label'] as String? ?? '',
        accountName: j['accountName'] as String? ?? '',
        persona: j['persona'] as String? ?? '',
        steam64: j['steam64'] as String? ?? '',
        appIds: [for (final a in (j['appIds'] as List? ?? const [])) (a as num).toInt()],
        autoResume: j['autoResume'] as bool? ?? true,
      );
}

class PersistedState {
  final settings = Settings();
  final accounts = <AccountInfo>[];

  /// hesap kimliği ('thispc' dahil) → favori appid'ler
  final favorites = <String, Set<int>>{};

  /// hesap kimliği → özel eklenen oyunlar
  final custom = <String, List<CustomGame>>{};

  /// "Bu bilgisayar" için kasılması istenen oyunlar
  List<int> thisPcWanted = [];
}

class Store {
  Store._(this.dir, this._secure);
  final Directory dir;
  final FlutterSecureStorage _secure;

  File get _file => File(p.join(dir.path, 'state.json'));

  String get path => dir.path;
  String credsDir(String id) => p.join(dir.path, 'creds', id);
  String logPath(String id) => p.join(dir.path, 'logs', '$id.log');

  static Future<Store> open() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory(p.join(base.path, 'IdleHub'));
    await dir.create(recursive: true);
    await Directory(p.join(dir.path, 'logs')).create(recursive: true);
    return Store._(dir, const FlutterSecureStorage());
  }

  Future<PersistedState> load() async {
    final st = PersistedState();
    try {
      if (!await _file.exists()) return st;
      final j = jsonDecode(await _file.readAsString()) as Map<String, dynamic>;
      st.settings.load((j['settings'] as Map?)?.cast<String, dynamic>() ?? {});
      for (final a in (j['accounts'] as List? ?? const [])) {
        st.accounts.add(AccountInfo.fromJson((a as Map).cast<String, dynamic>()));
      }
      ((j['favorites'] as Map?) ?? {}).forEach((k, v) {
        st.favorites['$k'] = {for (final a in (v as List)) (a as num).toInt()};
      });
      ((j['custom'] as Map?) ?? {}).forEach((k, v) {
        st.custom['$k'] = [
          for (final c in (v as List)) CustomGame((c['id'] as num).toInt(), '${c['name']}'),
        ];
      });
      st.thisPcWanted = [for (final a in (j['thisPcWanted'] as List? ?? const [])) (a as num).toInt()];
    } catch (_) {
      // Bozuk dosya: yedeğe al, temiz başla.
      try {
        await _file.rename('${_file.path}.corrupt');
      } catch (_) {}
    }
    return st;
  }

  Future<void> save(PersistedState st) async {
    final j = {
      'settings': st.settings.toJson(),
      'accounts': [for (final a in st.accounts) a.toJson()],
      'favorites': {for (final e in st.favorites.entries) e.key: e.value.toList()..sort()},
      'custom': {
        for (final e in st.custom.entries) e.key: [for (final c in e.value) c.toJson()],
      },
      'thisPcWanted': st.thisPcWanted,
    };
    final tmp = File('${_file.path}.tmp');
    await tmp.writeAsString(jsonEncode(j), flush: true);
    await tmp.rename(_file.path);
  }

  // ── Sırlar ────────────────────────────────────────────────────────────────
  Future<String?> readToken(String id) => _readSecret('rt_$id');
  Future<void> writeToken(String id, String token) => _secure.write(key: 'rt_$id', value: token);
  Future<void> deleteToken(String id) => _secure.delete(key: 'rt_$id');

  Future<String> readApiKey() async => await _readSecret('webapikey') ?? '';
  Future<void> writeApiKey(String key) => key.isEmpty
      ? _secure.delete(key: 'webapikey')
      : _secure.write(key: 'webapikey', value: key);

  Future<String?> _readSecret(String k) async {
    try {
      return await _secure.read(key: k);
    } catch (_) {
      return null;
    }
  }
}
