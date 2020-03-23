import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:renty_crud_version/ui/shared/ui_helpers.dart';
import 'package:renty_crud_version/ui/widgets/busy_button.dart';

import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:renty_crud_version/viewmodels/login_view_model.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (context, model, child) => SafeArea(
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: LoginAndSignUpTabView(
                    model: model,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

class LoginAndSignUpTabView extends StatefulWidget {
  final LoginViewModel model;
  const LoginAndSignUpTabView({Key key, this.model}) : super(key: key);
  @override
  _LoginAndSignUpTabViewState createState() => _LoginAndSignUpTabViewState();
}

class _LoginAndSignUpTabViewState extends State<LoginAndSignUpTabView>
    with SingleTickerProviderStateMixin {
  FocusNode focusNode;
  bool obscureText = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _signUpKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.fill),
          ),
          TabBar(
            indicatorColor: Colors.pink,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          verticalSpaceMedium,
          Container(
            height: MediaQuery.of(context).size.height / 2,
            // constraints: (BoxConstraints(
            //     maxHeight: MediaQuery.of(context).size.height,
            //     maxWidth: MediaQuery.of(context).size.width)),
            child: TabBarView(children: <Widget>[
              _buildLoginForm(context),
              _buildSignUpForm(context)
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _fbKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            verticalSpaceSmall,
            FormBuilderTextField(
              attribute: "fullname",
              // autovalidate: true,
              // keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _fbKey.currentState.saveAndValidate(),
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(focusNode);
              },
              validators: [
                FormBuilderValidators.minLength(8,
                    errorText: "Please enter a longer email."),
                FormBuilderValidators.maxLength(30,
                    errorText: "You have entered a very long email!"),
              ],
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: "Full Name"),
            ),
            verticalSpaceSmall,
            FormBuilderTextField(
              attribute: "username",
              // autovalidate: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _fbKey.currentState.saveAndValidate(),
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(focusNode);
              },
              validators: [
                FormBuilderValidators.email(),
                FormBuilderValidators.minLength(8,
                    errorText: "Please enter a longer email."),
                FormBuilderValidators.maxLength(30,
                    errorText: "You have entered a very long email!"),
              ],
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  labelText: "Email"),
            ),
            verticalSpaceSmall,
            FormBuilderTextField(
              attribute: "password",
              obscureText: obscureText,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              focusNode: focusNode,
              validators: [
                FormBuilderValidators.minLength(6,
                    errorText: "Please enter a longer password."),
                FormBuilderValidators.maxLength(30,
                    errorText: "You have entered a very long password!"),
              ],
              onEditingComplete: () => _fbKey.currentState.saveAndValidate(),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    child: !obscureText
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                  labelText: "Password"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _signUpKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            verticalSpaceSmall,
            FormBuilderTextField(
              attribute: "username",
              // autovalidate: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _fbKey.currentState.saveAndValidate(),
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(focusNode);
              },
              validators: [
                FormBuilderValidators.email(),
                FormBuilderValidators.minLength(8,
                    errorText: "Please enter a longer email."),
                FormBuilderValidators.maxLength(30,
                    errorText: "You have entered a very long email!"),
              ],
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  labelText: "Email"),
            ),
            verticalSpaceSmall,
            FormBuilderTextField(
              attribute: "password",
              obscureText: obscureText,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              focusNode: focusNode,
              validators: [
                FormBuilderValidators.minLength(6,
                    errorText: "Please enter a longer password."),
                FormBuilderValidators.maxLength(30,
                    errorText: "You have entered a very long password!"),
              ],
              onEditingComplete: () => _fbKey.currentState.saveAndValidate(),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    child: !obscureText
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                  labelText: "Password"),
            ),
            verticalSpaceMedium,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BusyButton(
                  title: 'Login',
                  busy: widget.model.busy,
                  onPressed: () {
                    //print(_fbKey.currentState.fields["username"].currentState.va)
                    widget.model.logInWithEmail(
                        _fbKey
                            .currentState.fields["username"].currentState.value
                            .toString(),
                        _fbKey
                            .currentState.fields["password"].currentState.value
                            .toString());
                  },
                )
              ],
            ),
            verticalSpaceMedium,
          ],
        ),
      ),
    );
  }
}
