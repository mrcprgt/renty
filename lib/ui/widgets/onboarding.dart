import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:renty_crud_version/ui/views/login_view.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final introKey = GlobalKey<IntroductionScreenState>();

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome to Renty!",
          body:
              "Renty is a user-driven borrowing platform specifically designed for you.",
          image: _buildImage('onboard1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Borrow the items you want!",
          body:
              "Want an item? Instead of buying a new one, if Renty has it, you can borrow it.",
          image: _buildImage('onboard2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Hassle-free process",
          body: "With a quick and easy setup, you can borrow items easily.",
          image: _buildImage('onboard3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Earn from your items",
          body: "Have unused items? Put them up for rent and earn from them!",
          image: _buildImage('onboard4'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeColor: Colors.pink,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  _buildLoginForms() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
            indicatorColor: Colors.pink,
          )
        ],
      ),
    );
  }
}
