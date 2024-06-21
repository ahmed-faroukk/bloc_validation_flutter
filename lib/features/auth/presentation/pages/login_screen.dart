import 'package:auth_app/features/auth/presentation/pages/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../../util/animation/fade_animation.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_widgets.dart'; // Assuming this contains your custom widget `buildRoundedButton`

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isValid = false; // Flag to control button state


  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyFormBloc>(
      create: (context) => MyFormBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: BlocListener<MyFormBloc, MyFormState>(
          listener: _onFormStateChanged,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            onChanged: _updateButtonState,
            child: _buildFormContent(),
          ),
        ),
      ),
    );
  }

  void _onFormStateChanged(BuildContext context, MyFormState state) {
    if (state.status == FormzSubmissionStatus.inProgress) {
      _showLoadingIndicator(context);
    } else if (state.status == FormzSubmissionStatus.success) {
      _dismissLoadingIndicator(context);
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (state.status == FormzSubmissionStatus.failure) {
      _dismissLoadingIndicator(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }

  void _showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _dismissLoadingIndicator(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _updateButtonState() {
    setState(() {
      _isValid = _formKey.currentState!.validate();
    });
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  width: 70, height: 70, child: Image.asset("assets/star.png")),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Log In',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          _buildEmailField(),
          _buildPasswordField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Navigate to forget password screen
                },
                child: const Text('Forgot password?',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          _buildLoginButton(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 95,
                child: Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
              ),
              Text("Or Login With"),
              SizedBox(
                width: 95,
                child: Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          _buildSocialLoginButtons(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Don’t have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(FadeRoute(page: SignUpPage()));
                },
                child: const Text(
                  'SignUp',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return _buildTextField(
          controller: _emailController,
          label: 'Email address',
          onChanged: (value) {
            context.read<MyFormBloc>().add(EmailChanged(email: value));
            _formKey.currentState?.validate();
          },
          validator: (value) {
            if (value == "") {
              return null;
            }
             if (state.email.error != null) {
               return "Please ensure the email entered is valid";
             }
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: _buildInputDecoration(),
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  bool _obscureText = true;

  Widget _buildPasswordField() {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _passwordController,
              decoration:
                  _buildInputDecorationForPass(obscureText: _obscureText),
              obscureText: true,
              onChanged: (value) {
                context.read<MyFormBloc>().add(
                      PasswordChanged(password: value),
                    );
              },
              validator: (value) {
                if (value == "") {
                  return null;
                }
                if (state.password.error != null) {
                      if (value!.length <= 8 ) {
                        return "Password must be more than 8 characters";
                      } else if (!_containsNumbers(value)) {
                        return "Password must contain at least one number";
                      } else if (!_containsLetters(value)) {
                        return "Password must contain at least one letter";
                      }
                }
              },
            ),
          ],
        );
      },
    );
  }
  bool _containsNumbers(String value) {
    return value.contains(RegExp(r'\d'));
  }

  bool _containsLetters(String value) {
    return value.contains(RegExp(r'[a-zA-Z]'));
  }

  InputDecoration _buildInputDecorationForPass({bool obscureText = true}) {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          // Toggle the obscureText state
          obscureText = !obscureText;
        },
        child: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return buildRoundedButton(
            text: "Login",
            onClick: () {
              context.read<MyFormBloc>().add(
                    FormSubmitted(),
                  );
            });
      },
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(iconPath: "assets/facebook.png", onPressed: () {}),
        _buildSocialButton(iconPath: "assets/google.png", onPressed: () {}),
        _buildSocialButton(iconPath: "assets/apple.png", onPressed: () {}),
      ],
    );
  }

  Widget _buildSocialButton(
      {required String iconPath, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.grey.shade400, // Gray border color
                  width: 0.5, // Border width
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 30, height: 30, child: Image.asset(iconPath)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

