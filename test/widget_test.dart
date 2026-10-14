import 'package:flutter_test/flutter_test.dart';
import 'package:idle_hub/core/l10n.dart';
import 'package:idle_hub/data/store.dart';
import 'package:idle_hub/steam/library_scan.dart';
import 'package:idle_hub/ui/widgets.dart';

void main() {
  test('VDF ayrıştırıcı iç içe yapıyı çözer', () {
    final d = parseVdf('''
"AppState"
{
  "appid"  "730"
  "name"   "Counter-Strike 2"
  "UserConfig" { "language" "english" }
}''');
    final st = d['AppState'] as Map;
    expect(st['appid'], '730');
    expect(st['name'], 'Counter-Strike 2');
    expect((st['UserConfig'] as Map)['language'], 'english');
  });

  test('oyun olmayan uygulamalar elenir', () {
    expect(isProbablyGame(Game(appId: 228980, name: 'Steamworks Common Redistributables')), isFalse);
    expect(isProbablyGame(Game(appId: 730, name: 'Counter-Strike 2')), isTrue);
    expect(isProbablyGame(Game(appId: 5, name: 'Half-Life Dedicated Server')), isFalse);
  });

  test('süre biçimleri', () {
    expect(fmtClock(const Duration(hours: 2, minutes: 5, seconds: 9)), '02:05:09');
    expect(fmtPlaytime(45), '45m');
    expect(fmtPlaytime(90), '1.5h');
    expect(fmtPlaytime(null), '');
  });

  test('hesap JSON gidiş-dönüş token İÇERMEZ', () {
    final a = AccountInfo(id: 'x', label: 'Ana', accountName: 'abc', steam64: '1', appIds: [730, 440]);
    final j = a.toJson();
    expect(j.keys.any((k) => k.toLowerCase().contains('token')), isFalse);
    final b = AccountInfo.fromJson(j);
    expect(b.appIds, [730, 440]);
    expect(b.display, 'Ana');
  });

  test('çeviri: yer tutucu doldurulur', () {
    expect(const S('en').t('total_idling', {'a': '2', 'g': '5'}), '2 accounts · 5 games idling');
    expect(const S('tr').t('limit_reached', {'n': '32'}), contains('32'));
  });
}
