import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/form_state_extensions.dart';
import 'package:my_todo/core/functions/show_toast_message.dart';
import 'package:my_todo/core/widgets/buttons/app_button_widget.dart';
import 'package:my_todo/core/widgets/text_field/text_field_widget.dart';
import 'package:my_todo/features/sing_up/view_models/sing_up_view_model.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/route/app_route.dart';
import 'package:my_todo/utils/validations.dart';
import 'package:nb_utils/nb_utils.dart';

@RoutePage()
class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final _singUp = locator<SingUpViewModel>();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final color = context.theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Sign Up",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Join us and start managing your tasks effectively!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 70),
                  TextFieldWidget(
                    outSidePadding: 0,
                    textFieldType: TextFieldType.EMAIL_ENHANCED,
                    hintText: "Email",
                    labelText: "Email",
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    validator: validateEmail,
                    nextFocusNode: _passwordFocusNode,
                  ),
                  20.height,
                  TextFieldWidget(
                    outSidePadding: 0,
                    textFieldType: TextFieldType.PASSWORD,
                    hintText: "Password",
                    labelText: "Password",
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    nextFocusNode: _confirmPasswordFocusNode,
                    validator: validatePassword,
                  ),
                  20.height,
                  TextFieldWidget(
                    outSidePadding: 0,
                    textFieldType: TextFieldType.PASSWORD,
                    hintText: "Confirm password",
                    labelText: "Confirm password",
                    focusNode: _confirmPasswordFocusNode,
                    controller: _confirmPasswordController,
                    validator: (value) => validateConfirmPassword(
                        value, _passwordController.text),
                    onFieldSubmitted: (_) => handleLoginAction(),
                  ),
                  40.height,
                  AppButtonWidget(
                    text: "Sing up",
                    margin: EdgeInsets.zero,
                    onTap: handleLoginAction,
                    isLoading: _singUp.isLoading,
                    enabled: !_singUp.isLoading,
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("I have account!, "),
                      InkWell(
                        onTap: () {
                          context.maybePop();
                        },
                        child: Text(
                          "log in",
                          style: TextStyle(color: color.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleLoginAction() async {
    if (_formKey.currentState.isNotValid) return;
    final email = _emailController.text.toLowerCase().trim();
    final password = _passwordController.text.trim();

    await _singUp.createUser(
      email: email,
      password: password,
      onError: (message) {
        showErrorToastMessage(message: message);
      },
      onSuccess: (message) {
        context.maybePop();
        showSuccessToastMessage(message: message);
      },
    );
  }
}
