// Packages
import 'package:flutter/material.dart';

// Packages
import 'package:provider/provider.dart';

// Services
import './services/navigation_service.dart';

// Providers
import './providers/authentication_provider.dart';

// Pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import './pages/register_page.dart';

// Utils
import './utils/contains.dart';

void main() {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitializationComplete: () {
      runApp(
        MainApp(),
      );
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) {
            return AuthenticationProvider();
          },
        )
      ],
      child: MaterialApp(
        title: TITLE,
        theme: ThemeData(
          backgroundColor: COLORS["DARK_BLUE_2"],
          scaffoldBackgroundColor: COLORS["DARK_BLUE_2"],
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: COLORS["DARK_BLUE"],
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: ROUTES["LOGIN"]!,
        routes: {
          ROUTES["LOGIN"]!: (BuildContext context) => LoginPage(),
          ROUTES["REGISTER"]!: (BuildContext context) => RegisterPage(),
          ROUTES["HOME"]!: (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}
