import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/presentation/state/bloc/auth/auth_bloc.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';
import 'package:refreshi_test/presentation/widgets/spacing/padding_constants.dart';
import 'package:refreshi_test/presentation/widgets/spacing/radius_constants.dart';
import 'package:refreshi_test/presentation/widgets/spacing/spacer_constants.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final border = textFieldRadius.copyWith(
      borderSide: BorderSide(color: colors.onSurface.withValues(alpha: 0.28)),
    );
    final emailController = TextEditingController(text: '');
    final passwordController = TextEditingController(text: '');

    InputDecoration fieldDecoration(String hint) {
      return InputDecoration(
        hintText: hint,
        hintStyle: type.bodyMedium.copyWith(color: colors.onSurface),
        filled: true,
        fillColor: colors.surface,
        isDense: true,
        contentPadding: allPadding12,
        border: border,
        enabledBorder: border,
        focusedBorder: textFieldRadius.copyWith(
          borderSide: BorderSide(color: colors.primary),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 72,
        titleSpacing: 24,
        title: Image.asset(
          'assets/images/logo.png',
          key: const Key('login-logo'),
          height: 32,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
      body: Align(
        alignment: const Alignment(0, -0.4),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: allPadding24,
            child: BlocConsumer<AuthBloc, AuthState>(
              bloc: context.read<AuthBloc>(),
              listener: (context, state) {
                if (state.isLoading) {
                  //TODO: Show loading overlay
                  return;
                }
                if (state.status == DataStatus.error) {
                  //TODO: Show error toast
                  return;
                }
                if (state.status == DataStatus.success) {
                  context.router.push(const CatalogRoute());
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: type.headlineSmall.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                    hSpacer24,
                    TextField(
                      key: const Key('login-email'),
                      style: type.bodyLarge.copyWith(
                        color: colors.onBackground,
                      ),
                      cursorColor: colors.primary,
                      keyboardType: TextInputType.emailAddress,
                      decoration: fieldDecoration('Email'),
                      controller: emailController,
                      onChanged: (String email) {
                        context.read<AuthBloc>().add(AuthEvent.setEmail(email: email));
                      },
                    ),
                    hSpacer12,
                    TextField(
                      key: const Key('login-password'),
                      style: type.bodyLarge.copyWith(
                        color: colors.onBackground,
                      ),
                      cursorColor: colors.primary,
                      obscureText: true,
                      decoration: fieldDecoration('Password'),
                      controller: passwordController,
                      onChanged: (String password) {
                        context.read<AuthBloc>().add(AuthEvent.setPassword(email: password));
                      },
                    ),
                    hSpacer32,
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        minimumSize: const Size(230, 52),
                        padding: hPadding32.add(vPadding16),
                        textStyle: type.labelLarge,
                      ),
                      onPressed: () =>
                          context.read<AuthBloc>().add(AuthEvent.authenticateUser()),
                      child: const Text('Log in'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
