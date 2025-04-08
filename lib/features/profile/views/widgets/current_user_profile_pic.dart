import 'package:flutter/material.dart';
import 'package:my_todo/core/widgets/network_image_view.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/state/global_state_store.dart';
import 'package:provider/provider.dart';

class CurrentUserProfilePic extends StatelessWidget {
  CurrentUserProfilePic({super.key});

  final _state = locator<GlobalStateStore>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _state,
      builder: (context, child) {
        context.watch<GlobalStateStore>();
        return CircleAvatar(
          child: Center(
            child: NetworkImageView(
              avatarUrl: _state.currentUser?.email,
            ),
          ),
        );
      },
    );
  }
}
