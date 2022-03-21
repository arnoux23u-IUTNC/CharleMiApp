import '../../main.dart';
import 'no_internet.dart';
import '../navigation/appbar_back.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context, ConnectivityResult result, Widget child) {
        final bool connected = result != ConnectivityResult.none;
        return connected
            ? Scaffold(
                appBar: const AppBarBack("Paramètres"),
                body: SettingsList(
                  sections: [
                    SettingsSection(
                      title: const Text('Général'),
                      tiles: <SettingsTile>[
                        SettingsTile.switchTile(
                          onToggle: (value) {
                            setState(() {
                              CharlemiappInstance.themeChangeProvider.darkTheme = value;
                            });
                          },
                          initialValue: !CharlemiappInstance.themeChangeProvider.darkTheme,
                          enabled: true,
                          leading: const Icon(Icons.format_paint),
                          title: const Text('Thème clair (Bêta)'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const NoInternet();
      },
      child: Container(),
    );
  }
}
