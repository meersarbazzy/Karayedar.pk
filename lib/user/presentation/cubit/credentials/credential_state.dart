part of 'credential_cubit.dart';

abstract class CredentialState extends Equatable {
  const CredentialState();
}

class CredentialInitial extends CredentialState {
  @override
  List<Object> get props => [];
}
class CredentialLoading extends CredentialState {
  @override
  List<Object> get props => [];
}
class CredentialLoaded extends CredentialState {
  @override
  List<Object> get props => [];
}
class CredentialFailure extends CredentialState {
  final String? message; // Optional error message

  CredentialFailure({this.message});

  @override
  List<Object> get props => [message ?? '']; // Include message in props
}