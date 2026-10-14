library;

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../core/theme.dart';
import '../engine/remote_account.dart';
import '../state/app_state.dart';
import 'dialogs.dart';
import 'library_view.dart';
import 'widgets.dart';

class Shell extends StatelessWidget {
  const Shell({super.key, required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => Scaffold(
          body: Column(children: [
            _TitleBar(app: app),
            Expanded(
              child: Row(children: [
                SizedBox(width: 268, child: Sidebar(app: app)),
                const VerticalDivider(width: 1),
                Expanded(child: LibraryView(app: app)),
              ]),
            ),
          ]),
        ),
      );
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.app});
  final AppState app;
  @override
  Widget build(BuildContext context) => Container(
        height: 44,
        color: C.panel,
        child: Row(children: [
          Expanded(
            child: DragToMoveArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Row(children: [
                  const Icon(Icons.play_circle_fill_rounded, size: 19, color: C.blue),
                  const SizedBox(width: 10),
                  const Text('IDLE HUB',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.8)),
                ]),
              ),
            ),
          ),
          _WinBtn(Icons.remove_rounded, () => windowManager.minimize()),
          _WinBtn(Icons.crop_square_rounded, () async {
            (await windowManager.isMaximized()) ? windowManager.unmaximize() : windowManager.maximize();
          }, size: 15),
          _WinBtn(Icons.close_rounded, () => windowManager.close(), danger: true),
        ]),
      );
}

class _WinBtn extends StatefulWidget {
  const _WinBtn(this.icon, this.onTap, {this.danger = false, this.size = 18});
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;
  final double size;
  @override
  State<_WinBtn> createState() => _WinBtnState();
}

class _WinBtnState extends State<_WinBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 48,
            height: 44,
            color: _h ? (widget.danger ? C.red : C.surface2) : Colors.transparent,
            child: Icon(widget.icon, size: widget.size, color: C.text),
          ),
        ),
      );
}

// ── Kenar çubuğu ────────────────────────────────────────────────────────────

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context) {
    final s = app.s;
    return Container(
      color: C.panel,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(s.t('accounts').toUpperCase(),
              style: const TextStyle(color: C.text3, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.6)),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              _AccountTile(
                app: app,
                id: thisPcId,
                title: s.t('this_pc'),
                subtitle: app.thisUser.persona.isNotEmpty ? app.thisUser.persona : s.t('this_pc_sub'),
              ),
              for (final a in app.accounts)
                _AccountTile(
                  app: app,
                  id: a.id,
                  title: a.display.isEmpty ? s.t('connecting') : a.display,
                  subtitle: a.accountName,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => showAddAccount(context, app),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(s.t('add_account')),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Row(children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => showSettings(context, app),
                icon: const Icon(Icons.settings_rounded, size: 19),
                label: Align(alignment: Alignment.centerLeft, child: Text(s.t('settings'))),
                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
              ),
            ),
            _TotalChip(app: app),
          ]),
        ),
      ]),
    );
  }
}

class _TotalChip extends StatelessWidget {
  const _TotalChip({required this.app});
  final AppState app;
  @override
  Widget build(BuildContext context) {
    final n = app.totalLive();
    if (n == 0) return const SizedBox.shrink();
    return Tooltip(
      message: app.s.t('total_idling', {'a': '${app.liveAccounts()}', 'g': '$n'}),
      child: Pill('$n', color: C.green, icon: Icons.bolt_rounded),
    );
  }
}

class _AccountTile extends StatefulWidget {
  const _AccountTile({required this.app, required this.id, required this.title, required this.subtitle});
  final AppState app;
  final String id;
  final String title;
  final String subtitle;
  @override
  State<_AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<_AccountTile> {
  bool _h = false;

  (Color, String) _status() {
    final app = widget.app;
    final s = app.s;
    if (widget.id == thisPcId) {
      final n = app.thisPc.runningCount;
      if (n > 0) return (C.green, s.t('acc_idling', {'n': '$n'}));
      if (app.thisPc.wanted.isNotEmpty) return (C.amber, s.t('acc_waiting'));
      if (app.thisPc.steamReady) return (C.blue, s.t('acc_online'));
      return (C.text3, s.t('acc_steam_off'));
    }
    final r = app.remotes[widget.id];
    final a = app.accountOf(widget.id);
    if (r == null) return (C.text3, s.t('acc_offline'));
    switch (r.state) {
      case RemoteState.loggedOn:
        final n = a?.appIds.length ?? 0;
        return n > 0 ? (C.green, s.t('acc_idling', {'n': '$n'})) : (C.blue, s.t('acc_online'));
      case RemoteState.connecting:
      case RemoteState.disconnected:
        return (C.amber, s.t('acc_connecting'));
      case RemoteState.tokenInvalid:
      case RemoteState.badPassword:
        return (C.red, s.t('acc_needs_login'));
      case RemoteState.error:
        return (C.red, s.t('acc_error'));
      default:
        return (C.text3, s.t('acc_offline'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sel = widget.app.selected == widget.id;
    final (color, status) = _status();
    final letter = widget.title.isEmpty ? '?' : widget.title.characters.first.toUpperCase();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => widget.app.select(widget.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: sel ? C.blue.withValues(alpha: 0.12) : (_h ? C.surface : Colors.transparent),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: sel ? C.blue.withValues(alpha: 0.5) : Colors.transparent),
            ),
            child: Row(children: [
              Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: widget.id == thisPcId
                            ? [const Color(0xFF2B6CB0), const Color(0xFF4DA3FF)]
                            : [const Color(0xFF5B4FCF), const Color(0xFF8B7BFF)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: widget.id == thisPcId
                      ? const Icon(Icons.desktop_windows_rounded, size: 19, color: Colors.white)
                      : Text(letter, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                Positioned(
                  right: -3,
                  bottom: -3,
                  child: Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(color: C.panel, shape: BoxShape.circle),
                    child: StatusDot(color, size: 9, pulse: color == C.green),
                  ),
                ),
              ]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: sel ? C.text : C.text)),
                  const SizedBox(height: 1),
                  Text(status, style: TextStyle(color: color == C.text3 ? C.text3 : color, fontSize: 11.5)),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
