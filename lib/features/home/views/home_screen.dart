import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/build_context_extensions.dart';
import 'package:my_todo/core/widgets/network_image_view.dart';
import 'package:my_todo/features/home/views/widgets/my_task_list.dart';
import 'package:my_todo/features/home/views/widgets/task_form.dart';
import 'package:my_todo/features/profile/views/widgets/current_user_profile_pic.dart';
import 'package:my_todo/features/sing_in/view_models/sing_in_view_model.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/route/app_route.dart';
import 'package:my_todo/state/global_state_store.dart';
import 'package:nb_utils/nb_utils.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _singIn = locator<SingInViewModel>();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskForm,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Welcome ',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(height: 0),
                        ),
                        InkWell(
                          onTap: _logOut,
                          child: Text(
                            '| Log out',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(height: 2, color: color.primary),
                          ),
                        ),
                      ],
                    ),
                    5.height,
                    Text(
                      'Track your task progress effortlessly!',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
                CurrentUserProfilePic()
              ],
            ),
              MyTaskList(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTaskForm() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const TaskForm(),
      ),
    );
  }

  void _logOut() async {
    final isLogOut = await showConfirmDialog(
      context,
      "Are you sure you want to log out?",
    );

    if (isLogOut && mounted) {
      context.router.replaceAll([SingInRoute()]);
      _singIn.logout();
    }
  }
}
