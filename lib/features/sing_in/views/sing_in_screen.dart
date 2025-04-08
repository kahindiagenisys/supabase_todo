import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/form_state_extensions.dart';
import 'package:my_todo/core/functions/show_toast_message.dart';
import 'package:my_todo/core/widgets/buttons/app_button_widget.dart';
import 'package:my_todo/core/widgets/text_field/text_field_widget.dart';
import 'package:my_todo/features/sing_in/view_models/sing_in_view_model.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/route/app_route.dart';
import 'package:my_todo/utils/validations.dart';
import 'package:nb_utils/nb_utils.dart';

@RoutePage()
class SingInScreen extends StatefulWidget {
  const SingInScreen({super.key});

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  final _singIn = locator<SingInViewModel>();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

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
                  40.height,
                  Text(
                    "Log in",
                    style: context.textTheme.displayMedium,
                  ),
                  20.height,
                  Text(
                    "Track your task progress effortlessly!",
                    style: context.textTheme.bodySmall,
                  ),
                  70.height,
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
                    validator: validatePassword,
                    onFieldSubmitted: (_) => handleLoginAction(),
                  ),
                  40.height,
                  AppButtonWidget(
                    text: "Log in",
                    margin: EdgeInsets.zero,
                    onTap: handleLoginAction,
                    // isLoading: _singIn.isLoadingLogin,
                    // enabled: !_singIn.isLoadingLogin,
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("I don't have account!, "),
                      InkWell(
                        onTap: () {
                          context.router.push(SingUpRoute());
                        },
                        child: Text(
                          "create an account",
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

    await _singIn.login(
      email: email,
      password: password,
      onSuccess: (message) {
        context.router.replace(const HomeRoute());
      },
      onError: (message) {
        showErrorToastMessage(message: message);
      },
    );
  }
}
