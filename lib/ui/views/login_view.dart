import 'package:renty_crud_version/ui/shared/ui_helpers.dart';
import 'package:renty_crud_version/ui/widgets/busy_button.dart';
import 'package:renty_crud_version/ui/widgets/input_field.dart';
import 'package:renty_crud_version/ui/widgets/text_link.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:renty_crud_version/viewmodels/login_view_model.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child:
                        Image.asset('assets/images/logo.png', fit: BoxFit.fill),
                  ),
                  InputField(
                    placeholder: 'Email',
                    controller: emailController,
                  ),
                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Password',
                    password: true,
                    controller: passwordController,
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BusyButton(
                        title: 'Login',
                        busy: model.busy,
                        onPressed: () {
                          model.logInWithEmail(
                              emailController.text, passwordController.text);
                        },
                      )
                    ],
                  ),
                  verticalSpaceMedium,
                  TextLink(
                    'Not registered? Tap here.',
                    onPressed: () {
                      Navigator.pushNamed(context, "SignUp");
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}
