import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_platform_menu_model.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_role_model.dart';

import '../../constants/constants.dart';

const dummyAuthUserModel = AuthenticatedUserModel(
  id: 15, 
  name: 'Aurelie Ankunding', 
  email: studentEmail, 
  token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxNyIsImp0aSI6ImYyZTE3Njg5Yzk2MmExNGYxODQ1ZjMwOWY2ZTVjNGEzNjdiNjc1ZWMxMGYxY2FmNmI1ZTdlZTk3YWFmNzFjM2YwOTFmNDViMWUyYmE1NjE5IiwiaWF0IjoxNjc5MDMxNjcyLjk4MTY5MSwibmJmIjoxNjc5MDMxNjcyLjk4MTY5MywiZXhwIjoxNjc5MDM4ODcyLjk1NTUxLCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.lWqM6G30DRMFvUbGOAYRXvqgC3CqHpyxVm9tos37Fg3J4uQJV-JQwfdd-DIshIb_FfAaD62llcJcPs7Cn_nsbY7k33Z9mlma2N3-YvXj-2nOzwOM-7axoiobL4lj5_OO5wvXIQNXC04FrUz_bWYLJntoBSXBF98zWkxkyvWdlpycfiuigan6MPXBzz6_mbFvQZepUQlzKRGThKmtOzn4eYHp9w8UYSxUIIkCJuXlB4VlE_6dpt_zOqLDyTrVRjUUGddYxirTJCWpBzqbRXIOjaS5vZJZF_ImfCDd0p4kpPGY24Eg-jy3KdHDx0CAwGGNbeYA1EUmD2G-Iuz7-xK0QOhfmLt5LU152EQbnFKZKoL5IeVMnhQonj0X1p6Q_Ha-4YKbwwonjMifhM095Pi4GxI0KRdfatwwYJLbjGpX6PD7iu1TKRq0jF-zClSX4Me4EWf9iZqUjjDimgmc0PxxF4AAA_yRDeKE8ZvskTiCoiScJgbTZWl-fCZSwZpfiOJT8B7RAx1Pjij9WoE-PRVGOXS0hzZ3XHd_RvxXVUhMphT8dn9hXSe3GYq1iBhVX_RNSJV7NsJAQx4aaCFRt6KdC2315sIODSTc11R_8S94ye33ly8OnpFDmzYSGiCQXUvcyhRnCG-2LKTq_lgatuddXT-LDrN-SW2mGjVVh7ASQM0', 
  tokenType: 'Bearer',
  expiresAt: '2023-03-17 05:41:13',
  systemReferenceId: 10,
  roles: [
    AuthenticatedUserRoleModel(id: 1, name: 'student')
  ],
  platformMenus: [
    AuthenticatedUserPlatformMenuModel(id: 8, name: 'Información personal', redirectTo: 'dashboard/informacion-personal', icon: 'MdSchool'),
    AuthenticatedUserPlatformMenuModel(id: 9, name: 'Inscripción de materias', redirectTo: 'dashboard/inscripcion-de-materias', icon: 'MdSchool'),
    AuthenticatedUserPlatformMenuModel(id: 10, name: 'Historial academico', redirectTo: 'dashboard/historial-academico', icon: 'MdSchool'),
    AuthenticatedUserPlatformMenuModel(id: 11, name: 'Ver notas', redirectTo: 'dashboard/notas', icon: 'MdSchool'),
  ]
);