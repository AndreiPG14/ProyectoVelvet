import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:velvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:velvet/features/auth/presentation/providers/login_form_provider.dart';
import 'package:velvet/features/shared/widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomShapeAppBar(),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: _LoginView(),
      ),
    );
  }
}

class CustomShapeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        color: Theme.of(context).primaryColorLight,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120.0);
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.4)
      ..cubicTo(size.width / 4, 3 * (size.height / 2), 3 * (size.width / 4),
          size.height / 2, size.width, size.height * 0.9)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _LoginView extends ConsumerWidget {
  const _LoginView({super.key});

  void showErrorDialog(BuildContext context, String message) {
    if (message == '') return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          surfaceTintColor: Colors.white,
          content: Text(
            message,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Intentar de nuevo'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void loadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);
    final size = MediaQuery.of(context).size;
    final obscureText = ref.watch(obscuretextProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage!.isNotEmpty &&
          next.authStatus == AuthStatus.notAuthenticated &&
          previous!.isLoading) {
        if (Navigator.canPop(context)) {
          context.pop();
        }
        showErrorDialog(context, next.errorMessage!);
      }
      if (next.isLoading &&
          !previous!.isLoading &&
          next.errorMessage!.isNotEmpty) {
        loadingDialog(context);
      }
      if (next.authStatus == AuthStatus.authenticated) {
        if (Navigator.canPop(context)) {
          context.pop();
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.10),
        Center(
          child: Image.asset(
            'assets/images/velvet_png.png',
            width: size.width * 0.54,
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            'Iniciar sesión',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.036),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), 
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomTextFormField(
                    hint: 'Usuario',
                    prefixIcon: Icon(Icons.person_outline),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) =>
                        ref.read(loginFormProvider.notifier).userChanged(value),
                    errorMessage: loginForm.isFormPosted
                        ? loginForm.username.errorMessage
                        : null,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomTextFormField(
                    hint: 'Contraseña',
                    obscureText: obscureText,
                    onChanged: (value) => ref
                        .read(loginFormProvider.notifier)
                        .passwordChanged(value),
                    errorMessage: loginForm.isFormPosted
                        ? loginForm.password.errorMessage
                        : null,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.visibility,
                        size: size.width * 0.06,
                      ),
                      onPressed: () {
                        ref.read(obscuretextProvider.notifier).state =
                            !ref.read(obscuretextProvider.notifier).state;
                      },
                    ),
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SizedBox(
                height: 48,
                width: size.width,
                child: FilledButton(
                  onPressed: () {
                    ref.read(loginFormProvider.notifier).onFormSubmitted();
                  },
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
