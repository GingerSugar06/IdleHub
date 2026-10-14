/// TR/EN çeviri tablosu: anahtar -> [Türkçe, English].
library;

class S {
  const S(this.code);
  final String code;
  bool get tr => code == 'tr';

  String t(String key, [Map<String, String>? args]) {
    final v = _m[key];
    var out = v == null ? key : v[tr ? 0 : 1];
    args?.forEach((k, val) => out = out.replaceAll('{$k}', val));
    return out;
  }

  static const _m = <String, List<String>>{
    // genel
    'add': ['Ekle', 'Add'],
    'cancel': ['Vazgeç', 'Cancel'],
    'save': ['Kaydet', 'Save'],
    'saved': ['Kaydedildi', 'Saved'],
    'open': ['Aç', 'Open'],
    'refresh': ['Yenile', 'Refresh'],
    'more': ['Daha fazla', 'More'],
    'remove': ['Kaldır', 'Remove'],
    'rename': ['Yeniden adlandır', 'Rename'],
    'connecting': ['Bağlanıyor…', 'Connecting…'],
    'settings': ['Ayarlar', 'Settings'],
    'language': ['Dil', 'Language'],
    'data': ['Veri', 'Data'],
    'general': ['Genel', 'General'],

    // hesaplar
    'accounts': ['Hesaplar', 'Accounts'],
    'this_pc': ['Bu bilgisayar', 'This PC'],
    'this_pc_sub': ['Steam’de açık hesap', 'Account signed in to Steam'],
    'this_pc_desc': ['Bu bilgisayarda açık olan Steam hesabı. Steam çalışıyor olmalı.', 'The account signed in to the Steam client on this PC. Steam must be running.'],
    'remote_desc': ['Steam istemcisi olmadan ağ üzerinden bağlanan hesap.', 'An account connected over the network, without the Steam client.'],
    'add_account': ['Hesap ekle', 'Add account'],
    'add_account_intro': [
      'Başka bir hesabı Steam istemcisi açık olmadan kasmak için giriş yap. Şifren diske yazılmaz; oturum anahtarı Windows’un güvenli deposunda saklanır.',
      'Sign in to idle another account without the Steam client. Your password is never written to disk; the session key lives in Windows’ secure credential store.'
    ],
    'account_added': ['Hesap eklendi', 'Account added'],
    'nickname': ['Takma ad', 'Nickname'],
    'nickname_optional': ['Takma ad (isteğe bağlı)', 'Nickname (optional)'],
    'remove_title': ['Hesap kaldırılsın mı?', 'Remove this account?'],
    'remove_msg': [
      'Oturum kapatılır ve hesap listeden silinir. Kayıtlı giriş anahtarı da silinir.',
      'The session is closed and the account is removed from the list. The saved login key is deleted too.'
    ],
    'relogin': ['Yeniden giriş yap', 'Sign in again'],
    'session_expired': ['Oturum süresi dolmuş. Kasmaya devam etmek için yeniden giriş yap.', 'The session has expired. Sign in again to keep idling.'],
    'need_login': ['Önce bu hesapta oturum aç.', 'Sign in to this account first.'],
    'acc_online': ['Çevrimiçi', 'Online'],
    'acc_offline': ['Çevrimdışı', 'Offline'],
    'acc_steam_off': ['Steam kapalı', 'Steam is off'],
    'acc_connecting': ['Bağlanıyor…', 'Connecting…'],
    'acc_waiting': ['Steam bekleniyor', 'Waiting for Steam'],
    'acc_needs_login': ['Giriş gerekli', 'Sign-in needed'],
    'acc_error': ['Hata', 'Error'],
    'acc_idling': ['{n} oyun kasılıyor', '{n} idling'],

    // giriş akışı
    'with_qr': ['QR kod', 'QR code'],
    'with_password': ['Şifre', 'Password'],
    'qr_instructions': [
      'Telefonda Steam uygulamasını aç → Steam Guard → “QR ile giriş” → kodu okut. Ek kod gerekmez.',
      'Open the Steam mobile app → Steam Guard → “Sign in with QR” → scan the code. No extra code needed.'
    ],
    'try_again': ['Tekrar dene', 'Try again'],
    'username': ['Kullanıcı adı', 'Username'],
    'password': ['Şifre', 'Password'],
    'password_note': ['Şifre yalnızca girişte bir kez kullanılır ve saklanmaz.', 'The password is used once to sign in and is never stored.'],
    'sign_in': ['Giriş yap', 'Sign in'],
    'guard_2fa': ['Steam Guard kodu', 'Steam Guard code'],
    'guard_email': ['E-posta kodu', 'Email code'],
    'guard_msg': ['Mobil uygulamandaki ya da e-postana gelen kodu gir.', 'Enter the code from your mobile app or the email Steam sent.'],
    'verify': ['Doğrula', 'Verify'],
    'wrong_code': ['Kod hatalı, tekrar dene.', 'Wrong code, try again.'],
    'st_logged_on': ['Çevrimiçi', 'Online'],
    'st_connecting': ['Bağlanıyor', 'Connecting'],
    'st_disconnected': ['Bağlantı koptu, yeniden deneniyor', 'Disconnected, retrying'],
    'st_token_invalid': ['Oturum geçersiz', 'Session invalid'],
    'st_bad_password': ['Kullanıcı adı veya şifre hatalı', 'Wrong username or password'],
    'st_rate_limited': ['Çok fazla deneme — birkaç dakika bekle', 'Too many attempts — wait a few minutes'],
    'st_error': ['Hata', 'Error'],

    // Steam / durum
    'steam_not_running': ['Steam kapalı', 'Steam not running'],
    'steam_not_signed': ['Steam’de oturum açık değil', 'Not signed in to Steam'],
    'steam_ready': ['Steam hazır', 'Steam ready'],
    'steam_missing': ['Steam kurulumu bulunamadı.', 'Steam installation not found.'],
    'queued_waiting_steam': [
      'Seçtiğin oyunlar sırada. Steam açılıp oturum açılınca kendiliğinden başlar.',
      'Your games are queued. They start automatically once Steam is running and signed in.'
    ],
    'queued_not_connected': ['Oyunlar sırada; hesap bağlanınca başlayacak.', 'Games are queued and will start once the account connects.'],
    'worker_missing': [
      'idle_worker.exe bulunamadı. Uygulamayı “tool\\build.ps1” ile derle ya da paketin tam çıkarıldığından emin ol.',
      'idle_worker.exe is missing. Build with “tool\\build.ps1” or make sure the package was fully extracted.'
    ],

    // motor
    'engine': ['Ağ motoru (Python)', 'Network engine (Python)'],
    'engine_desc': [
      'Başka hesapları Steam istemcisi olmadan kasmak için küçük bir Python motoru kullanılır. “Bu bilgisayar” modu Python gerektirmez.',
      'Idling other accounts without the Steam client uses a small Python engine. The “This PC” mode does not need Python.'
    ],
    'engine_ready': ['Motor hazır', 'Engine ready'],
    'engine_setup': ['Motoru kur', 'Set up engine'],
    'engine_python_missing': ['Python 3 bulunamadı. Başka hesaplar için kurman gerekir.', 'Python 3 was not found. It is required for other accounts.'],
    'engine_deps_missing': ['Motorun gerektirdiği paketler eksik.', 'The packages the engine needs are missing.'],
    'download_python': ['Python indir', 'Download Python'],
    'install_deps': ['Paketleri kur', 'Install packages'],
    'installing': ['Kuruluyor…', 'Installing…'],
    'recheck': ['Yeniden denetle', 'Re-check'],

    // kütüphane
    'search_hint': ['Oyun adı ya da AppID ara…', 'Search by game name or AppID…'],
    'tab_installed': ['Kurulu', 'Installed'],
    'tab_library': ['Kütüphane', 'Library'],
    'tab_favorites': ['Favoriler', 'Favorites'],
    'tab_idling': ['Kasılanlar', 'Idling'],
    'games_only': ['Yalnız oyunlar', 'Games only'],
    'installed': ['kurulu', 'installed'],
    'custom': ['özel', 'custom'],
    'idle': ['Kas', 'Idle'],
    'stop': ['Durdur', 'Stop'],
    'waiting': ['Bekliyor', 'Waiting'],
    'retrying': ['Deniyor', 'Retrying'],
    'fav_add': ['Favorilere ekle', 'Add to favorites'],
    'fav_remove': ['Favorilerden çıkar', 'Remove from favorites'],
    'remove_custom': ['Özel oyunu sil', 'Remove custom game'],
    'limit_reached': ['Steam aynı anda en fazla {n} oyunu destekler.', 'Steam supports at most {n} games at once.'],
    'total_idling': ['{a} hesap · {g} oyun kasılıyor', '{a} accounts · {g} games idling'],
    'nothing_idling': ['Şu an hiçbir şey kasılmıyor', 'Nothing is idling right now'],
    'stop_here': ['Bu hesabı durdur', 'Stop this account'],
    'stop_everything': ['Hepsini durdur', 'Stop everything'],
    'empty_fav': ['Henüz favori yok', 'No favorites yet'],
    'empty_fav_msg': ['Bir oyunun kalbine dokun; sık kullandıkların burada toplanır.', 'Tap the heart on a game; your regulars are collected here.'],
    'empty_idling': ['Kasılan oyun yok', 'No games idling'],
    'empty_idling_msg': ['Bir oyunun yanındaki “Kas” düğmesine bas.', 'Press the “Idle” button next to a game.'],
    'empty_search': ['Eşleşen oyun yok', 'No matching games'],
    'empty_search_msg': ['Başka bir ad ya da AppID dene; “Yalnız oyunlar” filtresini kapatmak da yardımcı olabilir.', 'Try another name or AppID; turning off “Games only” may help.'],
    'empty_pc': ['Oyun bulunamadı', 'No games found'],
    'empty_pc_msg': ['Steam kurulu ve en az bir oyun yüklü olmalı. Tüm kütüphaneni görmek için Web API anahtarı ekleyebilirsin.', 'Steam must be installed with at least one game. Add a Web API key to see your whole library.'],
    'api_key_hint_short': ['Ayarlar → Web API anahtarı', 'Settings → Web API key'],
    'empty_remote': ['Kütüphane yüklenmedi', 'Library not loaded'],
    'empty_remote_msg': ['Hesap bağlanınca oyunların burada listelenir. Bu arada AppID ile oyun ekleyebilirsin.', 'Your games are listed here once the account connects. Meanwhile you can add a game by AppID.'],
    'loading_library': ['Kütüphane yükleniyor…', 'Loading library…'],
    'loading_library_msg': ['Hesabındaki oyunlar Steam’den alınıyor. Birkaç saniye sürebilir.', 'Fetching the games on your account from Steam. This can take a few seconds.'],

    // AppID
    'add_appid': ['AppID ile oyun ekle', 'Add a game by AppID'],
    'add_appid_tip': ['Listede olmayan bir oyunu AppID ile ekle', 'Add a game that is not listed, by AppID'],
    'add_appid_msg': [
      'Oyunun AppID’si mağaza sayfasının adresindeki sayıdır (store.steampowered.com/app/730 → 730).',
      'A game’s AppID is the number in its store URL (store.steampowered.com/app/730 → 730).'
    ],
    'name_optional': ['Ad (isteğe bağlı)', 'Name (optional)'],
    'err_appid': ['Geçerli bir AppID yaz.', 'Enter a valid AppID.'],

    // ayarlar
    'set_tray': ['Kapatınca tepside çalışmaya devam et', 'Keep running in the tray when closed'],
    'set_tray_d': ['X’e basınca kasma durmaz; uygulama tepsiye iner.', 'The X button hides to the tray; idling continues.'],
    'set_login': ['Windows ile birlikte başlat', 'Launch with Windows'],
    'set_login_d': ['Kasılan oyunlar bilgisayar açılınca kendiliğinden sürdürülür.', 'Idling games resume by themselves when your PC starts.'],
    'set_min': ['Küçültülmüş başlat', 'Start minimized'],
    'set_min_d': ['Pencere açılmadan doğrudan tepsiye gider.', 'Goes straight to the tray without opening the window.'],
    'api_key': ['Steam Web API anahtarı', 'Steam Web API key'],
    'api_key_hint': [
      'İsteğe bağlı. “Bu bilgisayar” için kurulu olmayanlar dahil tüm kütüphaneni ve oynama sürelerini gösterir. Anahtar Windows’un güvenli deposunda saklanır.',
      'Optional. Shows your whole library, including uninstalled games, and playtimes for “This PC”. The key is kept in Windows’ secure credential store.'
    ],
    'get_api_key': ['Ücretsiz anahtar al', 'Get a free key'],
    'secrets_note': [
      'Hesap listesi ve favoriler yukarıdaki klasörde düz JSON olarak durur; oturum anahtarları ve API anahtarı orada DEĞİL, Windows Kimlik Bilgisi Yöneticisi’ndedir.',
      'The account list and favorites sit in the folder above as plain JSON; session keys and the API key are NOT there — they are in Windows Credential Manager.'
    ],
    'disclaimer': [
      'Resmî değildir; Valve ile bağlantısı yoktur. Kasma, Steam hizmet koşullarına ya da bazı oyunların kurallarına aykırı olabilir; sorumluluk sana aittir.',
      'Unofficial; not affiliated with Valve. Idling may violate Steam’s terms or some games’ rules; use at your own risk.'
    ],

    // tepsi
    'tray_show': ['Pencereyi göster', 'Show window'],
    'tray_stop_all': ['Hepsini durdur', 'Stop everything'],
    'tray_quit': ['Çıkış', 'Quit'],
    'tray_idling': ['{n} oyun kasılıyor', '{n} games idling'],
  };
}
