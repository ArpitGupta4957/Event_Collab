import 'package:event_media_viewer/core/constants.dart';
import 'package:event_media_viewer/core/theme.dart';
import 'package:event_media_viewer/providers/event_provider.dart';
import 'package:event_media_viewer/providers/photo_provider.dart';
import 'package:event_media_viewer/providers/theme_provider.dart';
import 'package:event_media_viewer/screens/splash_screen.dart';
import 'package:event_media_viewer/services/supabase_service.dart';
import 'package:event_media_viewer/services/unsplash_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(const EventMediaViewerApp());
}

class EventMediaViewerApp extends StatelessWidget {
  const EventMediaViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EventProvider(
            supabaseService: SupabaseService(Supabase.instance.client),
          )..fetchEvents(),
        ),
        ChangeNotifierProvider(
          create: (_) => PhotoProvider(unsplashService: UnsplashService()),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Event Media Viewer',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
