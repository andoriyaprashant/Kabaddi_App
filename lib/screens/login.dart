import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/navigationbar.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  final _firebase = FirebaseAuth.instance;

  String _username = '';
  String _password = '';
  bool _obscurePassword = true;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
    } else {
      return;
    }

    _formKey.currentState!.save();

    final UserCredentials = await _firebase
        .signInWithEmailAndPassword(email: _username, password: _password)
        .then((value) async {
      user.value = value.user!;
      print("hii  here");
      try {
        // Fetch user data
        var userSnapshot = await FirebaseFirestore.instance
            .collection("Users")
            .where("uid", isEqualTo: value.user?.uid)
            .get();

        // If user data exists, extract the role
        if (userSnapshot.docs.isNotEmpty) {
          userRole.value = userSnapshot.docs[0].data()["role"];
        }

        // Fetch user profile
        var profileSnapshot = await FirebaseFirestore.instance
            .collection("UserProfile")
            .where("uid", isEqualTo: value.user?.uid)
            .get();

        // If profile data exists, set the userProfile value
        if (profileSnapshot.docs.isNotEmpty) {
          userProfile.value = profileSnapshot.docs[0].data();
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NavigationBarWidget()),
        );
      } catch (error) {
        // Handle any errors that occur during data retrieval
        print("Error fetching user data: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred during login.'),
          ),
        );
      }
    }).onError((error, stackTrace) {
      // Handle errors during sign-in
      print("Error during sign-in: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Failed'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Kabadi',
          style: TextStyle(
              fontSize: 40,
              color: Colors.deepOrangeAccent,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 165,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _username = value!;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password ',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _password = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: ElevatedButton(
                    // onPressed: () {
                    //   if (_formKey.currentState!.validate()) {
                    //     _formKey.currentState!.save();
                    //     // You can add authentication logic here
                    //   }
                    // },
                    onPressed: _submit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.deepOrangeAccent),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.infinity, 50)),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  "OR CONNECT WITH",
                  style: TextStyle(),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/google2.png',
                      width: 35,
                      height: 35,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Image.asset(
                      'images/facebook.png',
                      width: 35,
                      height: 35,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Image.asset(
                      'images/twitter2.png',
                      width: 35,
                      height: 35,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
