import 'package:auth_app/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../../util/animation/fade_animation.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_widgets.dart'; // Assuming this contains your custom widget `buildRoundedButton`

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool allowDailyReport = false;
  bool allowWeeklySummary = true;
  bool _obscureText = true;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up failed')),
      );
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

  Widget backBtn({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 0.5,
          ),
        ),
        child: Center(
          child: Icon(icon, size: 30),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              backBtn(
                icon: Icons.arrow_back_ios_new,
                onPressed: () {
                  Navigator.of(context).popAndPushNamed('/login');
                },
              ),
              SizedBox(
                width: 70,
                height: 70,
                child: Image.asset("assets/star.png"),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sign Up',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          _buildEmailField(),
          _buildPasswordField(),
          _buildConfirmPasswordField(),
          _buildSwitch(
            value: allowDailyReport,
            onChanged: (value) => setState(() => allowDailyReport = value),
            label: "Daily reports",
            description: "Get a daily activity report via email.",
          ),
          _buildSwitch(
            value: allowWeeklySummary,
            onChanged: (value) => setState(() => allowWeeklySummary = value),
            label: "Weekly Summary",
            description: "Get a weekly activity report via email.",
          ),
          _buildSignUpButton(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don’t have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(FadeRoute(page: LoginPage()));
                },
                child:
                    const Text('Login', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
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
          onChanged: (value) =>
              context.read<MyFormBloc>().add(EmailChanged(email: value)),
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

  Widget _buildPasswordField() {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return _buildTextField(
          controller: _passwordController,
          label: 'Password',
          obscureText: _obscureText,
          onChanged: (value) =>
              context.read<MyFormBloc>().add(PasswordChanged(password: value)),
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
            }          },
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscureText = !_obscureText),
            child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey),
          ),
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

  Widget _buildConfirmPasswordField() {
    return _buildTextField(
      controller: _confirmPasswordController,
      label: 'Confirm Password',
      obscureText: _obscureText,
      onChanged: (value) =>
          context.read<MyFormBloc>().add(PasswordChanged(password: value)),
      validator: (value) {
        if (value == "") {
          return null;
        }
        if (_passwordController.value != _confirmPasswordController.value)
          return "not match your password";
      },
      suffixIcon: GestureDetector(
        onTap: () => setState(() => _obscureText = !_obscureText),
        child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey),
      ),
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
          decoration: _buildInputDecoration(suffixIcon: suffixIcon),
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration({Widget? suffixIcon}) {
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
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildSwitch({
    required bool value,
    required Function(bool) onChanged,
    required String label,
    required String description,
  }) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey,
          activeTrackColor: Colors.black,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(description),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return buildRoundedButton(
          text: "Sign up",
          onClick: () => context.read<MyFormBloc>().add(FormSubmitted()),
        );
      },
    );
  }
}
