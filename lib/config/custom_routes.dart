import 'package:buddy_go/features/Dashboard/screns/dashboard_screen.dart';
import 'package:buddy_go/features/Profile/screens/buddy_wink_screen.dart';
import 'package:buddy_go/features/Profile/screens/profile_event_screen.dart';
import 'package:buddy_go/features/Profile/screens/profile_screen.dart';
import 'package:buddy_go/features/authentication/screens/verify_screen.dart';
import 'package:buddy_go/features/Home/screens/home_screen.dart';
import 'package:buddy_go/features/Onboarding/screens/about_me_screen.dart';
import 'package:buddy_go/features/Onboarding/screens/choose_avatar_screen.dart';
import 'package:buddy_go/features/chat/screens/channel_list_page.dart';
import 'package:buddy_go/features/events/screen/event_screen.dart';
import 'package:buddy_go/features/home/screens/create_event_screen.dart';
import 'package:buddy_go/features/home/screens/winks_screen.dart';
import 'package:buddy_go/features/search/screens/search_event_screen.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:buddy_go/models/user_model.dart';
import 'package:buddy_go/widgets/participant_box.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:page_transition/page_transition.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/Onboarding/screens/choose_ai_avatar.dart';
import '../features/splashscreen/splash_screen.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const SplashScreen(),
        );
      case LoginScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: LoginScreen.routename),
          builder: (_) => LoginScreen(),
        );
      case ChooseAvatarScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ChooseAvatarScreen.routename),
          builder: (_) => ChooseAvatarScreen(),
        );
      case ProfileScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ProfileScreen.routename),
          builder: (_) => ProfileScreen(
            id: settings.arguments as String,
          ),
        );
      case AboutMeScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AboutMeScreen.routename),
          builder: (_) => AboutMeScreen(
            image: (settings.arguments as Map)["image"],
            user: (settings.arguments as Map)["user"],
          ),
        );
      case CreateEventScreen.routename:
        return PageTransition(
          type: PageTransitionType.bottomToTop,
          duration: Duration(milliseconds: 500),
          settings: const RouteSettings(name: CreateEventScreen.routename),
          child: CreateEventScreen(
            eventModel: settings.arguments == null
                ? null
                : settings.arguments as EventModel,
          ),
        );
      case BuddyWinkScreen.routename:
        return PageTransition(
          type: PageTransitionType.leftToRight,
          duration: Duration(milliseconds: 500),
          settings: const RouteSettings(name: BuddyWinkScreen.routename),
          child: BuddyWinkScreen(
            users: settings.arguments as List<User>,
          ),
        );
      case ChannelListPage.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ChannelListPage.routename),
          builder: (_) => ChannelListPage(),
        );
      case EventScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: EventScreen.routename),
          builder: (_) => EventScreen(
            event: (settings.arguments as Map)["event"],
          ),
        );
      case ProfileEventScreen.routename:
        return PageTransition(
          type: PageTransitionType.leftToRight,
          duration: Duration(milliseconds: 500),
          settings: const RouteSettings(name: BuddyWinkScreen.routename),
          child: ProfileEventScreen(
            eventModels: settings.arguments as List<EventModel>,
          ),
        );
      case SearchEvent.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SearchEvent.routename),
          builder: (_) => const SearchEvent(),
        );
      case DashBoardScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: DashBoardScreen.routename),
          builder: (_) => const DashBoardScreen(),
        );
      case WinkScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: WinkScreen.routename),
          builder: (_) => const WinkScreen(),
        );
      case ChooseAIAvatarScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ChooseAIAvatarScreen.routename),
          builder: (_) => const ChooseAIAvatarScreen(),
        );
      case VerifyPhoneNumberScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: LoginScreen.routename),
          builder: (_) => const VerifyPhoneNumberScreen(),
        );
      case HomeScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: HomeScreen.routename),
          builder: (_) => const HomeScreen(),
        );
      case SplashScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SplashScreen.routename),
          builder: (_) => const SplashScreen(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
