import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/view/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _version = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadVersion();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? AppTheme.backgroundDark
            : AppTheme.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: themeProvider.themeMode == ThemeMode.dark
                ? AppTheme.textPrimary
                : AppTheme.textPrimaryLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: themeProvider.themeMode == ThemeMode.dark
                ? AppTheme.textPrimary
                : AppTheme.textPrimaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('General'),
          _buildNotificationSetting(),
          _buildSettingsTile(
            icon: Icons.color_lens_outlined,
            title: 'Appearance',
            subtitle: 'Customize app theme and colors',
            onTap: () => _showThemeDialog(themeProvider),
          ),
          _buildSectionTitle('Storage'),
          _buildSettingsTile(
            icon: Icons.folder_outlined,
            title: 'Download Location',
            subtitle: '/storage/emulated/0/Download',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.delete_outline_rounded,
            title: 'Clear Cache',
            subtitle: 'Remove temporary files',
            onTap: _showClearCacheDialog,
          ),
          _buildSectionTitle('About'),
          _buildSettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Version',
            subtitle: _version,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0, left: 16.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          color: themeProvider.themeMode == ThemeMode.dark
              ? AppTheme.textSecondary
              : AppTheme.textSecondaryLight,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListTile(
      leading: Icon(
        icon,
        color: themeProvider.themeMode == ThemeMode.dark
            ? AppTheme.textSecondary
            : AppTheme.textSecondaryLight,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: themeProvider.themeMode == ThemeMode.dark
              ? AppTheme.textPrimary
              : AppTheme.textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          color: themeProvider.themeMode == ThemeMode.dark
              ? AppTheme.textSecondary
              : AppTheme.textSecondaryLight,
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: themeProvider.themeMode == ThemeMode.dark
            ? AppTheme.textSecondary
            : AppTheme.textSecondaryLight,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildNotificationSetting() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SwitchListTile(
      title: Text(
        'Notifications',
        style: GoogleFonts.poppins(
          color: themeProvider.themeMode == ThemeMode.dark
              ? AppTheme.textPrimary
              : AppTheme.textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'Enable or disable push notifications',
        style: GoogleFonts.poppins(
          color: themeProvider.themeMode == ThemeMode.dark
              ? AppTheme.textSecondary
              : AppTheme.textSecondaryLight,
          fontSize: 12,
        ),
      ),
      value: _notificationsEnabled,
      onChanged: _toggleNotifications,
      activeColor: AppTheme.primary,
      secondary: Icon(
        Icons.notifications_none_rounded,
        color: themeProvider.themeMode == ThemeMode.dark
            ? AppTheme.textSecondary
            : AppTheme.textSecondaryLight,
      ),
    );
  }

  void _showThemeDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? AppTheme.surfaceDark
            : AppTheme.surfaceLight,
        title: Text(
          'Choose Theme',
          style: GoogleFonts.poppins(
            color: themeProvider.themeMode == ThemeMode.dark
                ? AppTheme.textPrimary
                : AppTheme.textPrimaryLight,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setTheme(value);
                }
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setTheme(value);
                }
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setTheme(value);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text(
          'Clear Cache',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to clear the cache? This will remove all temporary files.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.primary)),
          ),
          TextButton(
            onPressed: () {
              // Mock cache clearing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully!'),
                  backgroundColor: AppTheme.primary,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }
}
