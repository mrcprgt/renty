import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:renty_crud_version/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:renty_crud_version/viewmodels/login_view_model.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (context, model, child) => SafeArea(
        child: LoadingOverlay(
          opacity: 0.75,
          color: Colors.white,
          progressIndicator: CircularProgressIndicator(
            backgroundColor: Colors.pinkAccent,
          ),
          isLoading: model.busy,
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
  FocusNode loginPasswordFocusNode,
      registerEmailFocusNode,
      registerPasswordFocusNode;
  bool obscureText = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    loginPasswordFocusNode = FocusNode();
    registerEmailFocusNode = FocusNode();
    registerPasswordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.fitHeight),
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
          verticalSpaceSmall,
          FormBuilder(
            key: _fbKey,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: TabBarView(children: <Widget>[
                _buildLoginForm(context),
                _buildSignUpForm(context)
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FormBuilderTextField(
              attribute: "fullname",
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _fbKey.currentState.saveAndValidate(),
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(registerEmailFocusNode);
              },
              validators: [
                FormBuilderValidators.minLength(8,
                    errorText:
                        "Please enter a longer name. Your name can't be that short would it?"),
                FormBuilderValidators.maxLength(30,
                    errorText:
                        "You have entered a very long name! Don't you have a shorter name?"),
              ],
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: "Full Name"),
            ),
            verticalSpaceSmall,
            FormBuilderTextField(
              attribute: "signup_email",
              focusNode: registerEmailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _fbKey.currentState.saveAndValidate(),
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(registerPasswordFocusNode);
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
              attribute: "signup_password",
              obscureText: obscureText,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              focusNode: registerPasswordFocusNode,
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
            _buildRegitrationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FormBuilderTextField(
              attribute: "login_username",
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _fbKey.currentState.saveAndValidate(),
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(loginPasswordFocusNode);
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
              attribute: "login_password",
              obscureText: obscureText,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              focusNode: loginPasswordFocusNode,
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
            _buildLoginButtons(),
            verticalSpaceMedium,
          ],
        ),
      ),
    );
  }

  Column _buildLoginButtons() {
    return Column(
      children: <Widget>[
        SignInButton(
          Buttons.Email,
          text: "Login with Renty Account",
          onPressed: () => widget.model.logInWithEmail(
              _fbKey.currentState.fields["login_username"].currentState.value
                  .toString(),
              _fbKey.currentState.fields["login_password"].currentState.value
                  .toString()),
        ),
        verticalSpaceSmall,
        Text("OR"),
        verticalSpaceSmall,
        SignInButton(
          Buttons.GoogleDark,
          onPressed: () {
            widget.model.signInWithGoogle();
          },
        )
      ],
    );
  }

  Column _buildRegitrationButtons() {
    return Column(
      children: <Widget>[
        SignInButton(
          Buttons.Email,
          text: "Register a Renty Account",
          onPressed: () => widget.model.signUpWithEmail(
            _fbKey.currentState.fields["signup_username"].currentState.value
                .toString(),
            _fbKey.currentState.fields["signup_password"].currentState.value
                .toString(),
            _fbKey.currentState.fields["fullname"].currentState.value
                .toString(),
          ),
        ),
        verticalSpaceSmall,
        Text("OR"),
        verticalSpaceSmall,
        SignInButton(
          Buttons.GoogleDark,
          text: "Register with Google",
          onPressed: () => widget.model.signUpWithEmail(
            _fbKey.currentState.fields["signup_username"].currentState.value
                .toString(),
            _fbKey.currentState.fields["signup_password"].currentState.value
                .toString(),
            _fbKey.currentState.fields["fullname"].currentState.value
                .toString(),
          ),
        ),
      ],
    );
  }
}
