library sign_in;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_service/firebase_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:layout_builder/layout_builder.dart';
import 'package:sign_in/presentation/painters/apple_logo.dart';
import 'package:sign_in/presentation/painters/google_logo.dart';

part 'controllers/sign_in_controller.dart';
part 'core/enums/sign_in_suppliers.dart';
part 'core/models/auth_state.dart';
part 'core/models/sign_in_event.dart';
part 'core/models/sign_in_localizations.dart';
part 'core/models/sign_in_state.dart';
part 'core/models/sign_in_theme.dart';
part 'core/models/user.dart';
part 'presentation/common_widgets/sign_in_button.dart';
part 'presentation/sign_in_landing_page.dart';
part 'presentation/sign_in_navigator.dart';
part 'presentation/sign_in_email_page.dart';
part 'presentation/sign_in_email_password_page.dart';
part 'presentation/sign_in_button.dart';
part 'sign_in.freezed.dart';
part 'sign_in.g.dart';

final signInControllerProvider =
    StateNotifierProvider<SignInController, SignInState>((ref) {
  final service = ref.watch(authServiceProvider);
  return SignInController(service);
});

final authStateProvider = Provider<AuthState>((ref) {
  final authStateChanges = ref.watch(authStateChangesProvider);

  return authStateChanges.when(
    loading: () => const AuthState.initializing(),
    error: (error, _) => AuthState.error(error.toString()),
    data: (user) {
      if (user == null) {
        return const AuthState.notAuthed();
      } else {
        final user = ref.watch(userStreamProvider);
        return user.when(
          loading: () {
            final isSigninIn = ref.watch(signInControllerProvider.select(
              (state) => (state == const SignInState.success()),
            ));
            if (isSigninIn) {
              return const AuthState.notAuthed();
            } else {
              return const AuthState.initializing();
            }
          },
          error: (error, _) => AuthState.error(error.toString()),
          data: (user) {
            if (user == null) {
              return const AuthState.waitingUserCreation();
            } else {
              if (user.isComplete) {
                return AuthState.authed(user);
              } else {
                return const AuthState.needUserInformation();
              }
            }
          },
        );
      }
    },
  );
});

final signInLocalizationsProvider = Provider<SignInLocalizations>(
  (_) => const SignInLocalizations(),
);

final signInSuppliersProvider = Provider<List<SignInSupplier>>(
  (_) => [
    SignInSupplier.apple,
    SignInSupplier.google,
    SignInSupplier.anonymous,
  ],
);

final signInThemeProvider = Provider<SignInTheme>((ref) {
  final appTheme = ref.watch(appThemeProvider);
  final formTheme = ref.watch(formThemeProvider);

  return SignInTheme(
    buttonBackgroundColor: formTheme.rowBackgroundColor,
    buttonTextColor: appTheme.textColor,
  );
});

final _userRef =
    FirebaseFirestore.instance.collection("users").withConverter<User>(
          fromFirestore: (snapshot, _) {
            final userFromJson = User.fromJson(snapshot.data()!);
            return userFromJson.copyWith(id: snapshot.id);
          },
          toFirestore: (user, _) => user.toJson(),
        );

final userStreamProvider = StreamProvider<User?>((ref) {
  final authStateChanges = ref.watch(authStateChangesProvider);

  return authStateChanges.maybeWhen(
    data: (user) => user != null
        ? _userRef.doc(user.uid).snapshots().map((snapshot) => snapshot.data())
        : const Stream.empty(),
    orElse: () => const Stream.empty(),
  );
});
