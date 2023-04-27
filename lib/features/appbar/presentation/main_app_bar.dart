import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../authentication/presentation/bloc/authentication_event.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  TextButton _buildMenuItem(String text, String iconName, VoidCallback onPressed) {
    IconData icon;

    switch(iconName) {
      case mdSchoolIcon: icon = Icons.school; break;
      case logoutIcon: icon = Icons.logout_rounded; break;
      default: icon = Icons.school; break;
    }
    
    return TextButton.icon(onPressed: onPressed, icon: Icon(icon, size: 25), label: Text(text));
  }

  List<TextButton> _buildAppBarActions(ResponsiveWrapperData responsive
    , AuthenticationBloc authProvider, NavigatorState navigator) {
    if(responsive.isLargerThan(TABLET)) {
      final menu = authProvider.state.authenticatedUser?.platformMenus.map((menu) {
        return _buildMenuItem(menu.name, menu.icon, () { navigator.pushNamed(menu.redirectTo); });
      }).toList() ?? [];

      if(menu.isNotEmpty) {
        menu.add(_buildMenuItem('Cerrar Sesión', logoutIcon, () => authProvider.add(LogoutRequestedEvent())));
      }

      return menu;
    }
    else { return []; }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final responsive = ResponsiveWrapper.of(context);
    final authProvider = context.read<AuthenticationBloc>();

    return AppBar(
      elevation: 4,
      title: const Text('ITPSM'),
      automaticallyImplyLeading: false,
      actions: _buildAppBarActions(responsive, authProvider, navigator),
      leading: Builder(
        builder: (BuildContext context) {
          return responsive.isLargerThan(TABLET) ?
          const SizedBox() :
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () { Scaffold.of(context).openDrawer(); },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
    );
  }
}