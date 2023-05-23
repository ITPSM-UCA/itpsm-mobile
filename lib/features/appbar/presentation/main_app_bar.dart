import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../authentication/presentation/bloc/authentication_event.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final String appBarTitle;
  final Widget? appBarTitle;

  const MainAppBar({super.key, this.appBarTitle});

  TextButton _buildMenuItem(String text, String iconName, VoidCallback onPressed) {
    IconData icon;

    switch(iconName) {
      case mdSchoolIcon: icon = Icons.school; break;
      case logoutIcon: icon = Icons.logout_rounded; break;
      default: icon = Icons.school; break;
    }

    // Changes in the API need to be done to remove this patch
    if(text == gradesConsultation) {
      icon = Icons.class_;
    }
    
    return TextButton.icon(onPressed: onPressed, icon: Icon(icon, size: 25), label: Text(text));
  }

  List<TextButton> _buildAppBarActions(ResponsiveWrapperData responsive
    , AuthenticationBloc authProvider, NavigatorState navigator) {
    if(responsive.isLargerThan(TABLET)) {
      final menu = authProvider.state.authenticatedUser?.platformMenus.where((menu) => menu.name == academicRecord || menu.name == gradesConsultation).map((menu) {
        return _buildMenuItem(menu.name, menu.icon, () { navigator.pushReplacementNamed(menu.redirectTo); });
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
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);
    final responsive = ResponsiveWrapper.of(context);
    final authProvider = context.read<AuthenticationBloc>();

    return AppBar(
      elevation: 4,
      title: appBarTitle,
      automaticallyImplyLeading: false,
      actions: _buildAppBarActions(responsive, authProvider, navigator),
      leading: Builder(
        builder: (BuildContext context) {
          return responsive.isLargerThan(TABLET) ?
          const SizedBox() :
          IconButton(
            icon: Icon(Icons.menu, color: theme.colorScheme.primary),
            onPressed: () { Scaffold.of(context).openDrawer(); },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
    );
  }
}