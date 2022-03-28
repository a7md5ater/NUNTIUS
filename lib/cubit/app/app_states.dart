abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppLoadingState extends AppStates{}
class AppErrorState extends AppStates{
  final String error;
  AppErrorState(this.error);
}
class AppLogoutState extends AppStates{}

class AppChangeNavBarState extends AppStates{}

class AppGetContactsState extends AppStates{}

class AppAddNewContactState extends AppStates{}