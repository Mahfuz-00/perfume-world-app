import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Data/Repositories/sign_in_repositories_impl.dart';
import '../../Dashboard Page/Page/dashboard_UI.dart';
import '../Bloc/sign_in_bloc.dart'; // Import Fluttertoast

class FingerScanOverlay extends StatefulWidget {
  const FingerScanOverlay({Key? key}) : super(key: key);

  @override
  State<FingerScanOverlay> createState() => _FingerScanOverlayState();
}

class _FingerScanOverlayState extends State<FingerScanOverlay> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticated = false;
  String _errorMessage = '';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    // Trigger biometric authentication immediately.
    _authenticate();
  }

  // Function to handle biometric authentication
  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      // Check if biometric authentication is available
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        setState(() {
          _errorMessage = "Biometric authentication is not available.";
        });

        /* Fluttertoast.showToast(
          msg: "Biometric authentication is not available.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          // Show at the top
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );*/
      }
      if (isAvailable) {
        /*
        Fluttertoast.showToast(
          msg: "Biometric authentication is available.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          // Show at the top
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );*/
      }

      // Attempt to authenticate with biometrics (fingerprint or face)
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        // Reason for authentication
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true, // Show error dialogs if authentication fails
          stickyAuth: true, // Keep authentication session alive
        ),
      );

      setState(() {
        _isAuthenticated = authenticated;
        if (!authenticated) {
          _errorMessage = "Authentication failed!";
        } else {
          _errorMessage = '';
        }
      });

      if (authenticated) {
        // Successfully authenticated
        Fluttertoast.showToast(
          msg: "Authentication Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          // Show at the top
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // If no token, check if "Remember Me" is checked in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedEmail = prefs.getString('savedEmail');
        String? savedPassword = prefs.getString('savedPassword');
        String? isCheckedString = prefs.getString('rememberMe');

        if (isCheckedString == 'true') {
          isChecked = true;
        } else {
          isChecked = false;
        }

        print('Email: ${savedEmail}');
        print('Password: ${savedPassword}');

        print("Remember Me in biometric: $isChecked");

        if (isChecked) {
          // If "Remember Me" is checked, retrieve saved email and password
          String? savedEmail = await SharedPreferences.getInstance()
              .then((prefs) => prefs.getString('savedEmail'));
          String? savedPassword = await SharedPreferences.getInstance()
              .then((prefs) => prefs.getString('savedPassword'));

          print('Email: ${savedEmail}');
          print('Password: ${savedPassword}');
          print('RememberMe: $isChecked');
          // Trigger the sign-in event
          BlocProvider.of<SignInBloc>(context).add(
            PerformSignInEvent(
              username: savedEmail!,
              password: savedPassword!,
              rememberMe: isChecked,
            ),
          );

          // After successful authentication, check for the token.
          final repository = SigninRepositoryImpl();
          String? token = await repository.getToken();

          if (token != null && token.isNotEmpty) {
            Fluttertoast.showToast(
              msg: "Authentication Successful!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            // Navigate to Dashboard if the token exists.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          }
        } else {
          // Token is needed; inform the user and optionally fall back to manual sign-in.
          Fluttertoast.showToast(
            msg:
                "No valid token found. Please sign in using email and password. and check remember me for biometric login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        // Authentication failed
        Fluttertoast.showToast(
          msg: "Authentication failed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          // Show at the top
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error during authentication: $e";
      });
      print('Error Messeage during biometric authentication: $e');
      Fluttertoast.showToast(
        msg: "Error during authentication: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        // Show at the top
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInFailure) {
            // Handle failure (e.g., show a snackbar)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
            print('Sign In Error: ${state.error}');
          } else if (state is SignInSuccess) {
            // Handle success (e.g., navigate to Dashboard)
            Navigator.pushReplacementNamed(context, '/Home');
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Semi-transparent overlay
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
              // Centered content with fingerprint scan option (icon)
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Verify it\'s You',
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                            fontFamily: 'Roboto'),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'This App requires your fingerprint confirmation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.textGrey,
                            fontFamily: 'Roboto'),
                      ),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          // Do nothing when the icon is tapped
                        },
                        child: const Icon(
                          Icons.fingerprint,
                          size: 45.0,
                          color: AppColors.textNavyBlue,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the overlay
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Fingerprint scan UI at the bottom of the screen
         /*     Positioned(
                bottom: 30,
                left: MediaQuery.of(context).size.width * 0.4,
                child: GestureDetector(
                  onTap: _authenticate,
                  // Trigger the fingerprint scan when tapped
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 40.0,
                      color: AppColors.textNavyBlue,
                    ),
                  ),
                ),
              ),*/
            ],
          );
        },
      ),
    );
  }
}
