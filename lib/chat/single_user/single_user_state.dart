part of 'single_user_cubit.dart';

abstract class SingleUserState extends Equatable {
  const SingleUserState();
}

class SingleUserInitial extends SingleUserState {
  @override
  List<Object> get props => [];
}


class SingleUserLoaded extends SingleUserState {

  final String uid;
  SingleUserLoaded({required this.uid});
  @override
  List<Object> get props => [uid];
}


class SingleUserFailure extends SingleUserState {
  @override
  List<Object> get props => [];
}

class SingleUserLoading extends SingleUserState {
  @override
  List<Object> get props => [];
}

