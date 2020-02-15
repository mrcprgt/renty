import 'package:renty_crud_version/ui/shared/ui_helpers.dart';
import 'package:renty_crud_version/ui/widgets/busy_button.dart';
import 'package:renty_crud_version/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:renty_crud_version/viewmodels/signup_view_model.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>.withConsumer(
      viewModel: SignUpViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                // scrollDirection: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 38,
                    ),
                  ),
                  verticalSpaceLarge,
                  InputField(
                    placeholder: 'Full Name',
                    decoration: new InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email)),
                    controller: fullNameController,
                  ),
                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Email',
                    decoration: new InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email)),
                    controller: emailController,
                  ),
                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Password',
                    decoration: new InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),

                      // Icon(Icons.visibility_off)
                    ),
                    password: true,
                    controller: passwordController,
                    additionalNote:
                        'Password has to be a minimum of 6 characters.',
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BusyButton(
                        title: 'Sign Up',
                        busy: model.busy,
                        onPressed: () {
                          model.signUp(emailController.text,
                              passwordController.text, fullNameController.text);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
