part of 'admin_home_provider.dart';

sealed class AdminHomeState {
  const AdminHomeState();
}

class AdminHomeInitial extends AdminHomeState {
  const AdminHomeInitial();
}

class AdminHomeLoading extends AdminHomeState {
  const AdminHomeLoading();
}

class AdminHomeLoaded extends AdminHomeState {
  const AdminHomeLoaded({required this.stats});

  final AdminStats stats;
}

class AdminHomeError extends AdminHomeState {
  const AdminHomeError({required this.message});

  final String message;
}
