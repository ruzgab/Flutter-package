part of '../sign_in.dart';

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState.initial() = _Initial;
  const factory SignInState.loading() = _Loading;
  const factory SignInState.error(String errorText) = _Error;
}