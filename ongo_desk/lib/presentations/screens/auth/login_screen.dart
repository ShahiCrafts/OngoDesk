import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    bool rememberMe = false;
    @override
    Widget build(BuildContext context) {

      final size = MediaQuery.of(context).size;
      const orangeColor = Color(0xFFFF5C00);

      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: size.width * 0.24,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 4,),

                      Text(
                        ".OngoDesk",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 32,),

                const Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),

                const SizedBox(height: 8,),

                TextField(
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    hintText: "example@gmail.com",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(8)
                    ),

                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                  ),
                ),

                const SizedBox(height: 24,),

                const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w500
                  ),
                ),

                const SizedBox(height: 8,),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "************",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                  ),
                ),

                const SizedBox(height: 6,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe, 
                          activeColor: orangeColor, 
                          onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        }),

                        const Text(
                          "Remember me",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),

                    TextButton(onPressed: () {

                    }, child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87
                      ),
                      ))
                  ],
                ),

                const SizedBox(height: 20,),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ), 
                  child: Text(
                    "Login Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                    )),
                ),

                const SizedBox(height: 30,),

                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1, endIndent: 12,)),
                    Text(
                      "or sign-in with",
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1, endIndent: 12,))
                  ],
                ),

                const SizedBox(height: 30,),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {

                    }, 

                    icon: Image.asset(
                      'assets/icons/google.png',
                      width: 24,
                      height: 24,
                    ),

                    label: Text(
                      "Sign-in with google",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                    ),
                  ),
                ),

                const SizedBox(height: 82,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(width: 4,),

                    GestureDetector(
                      onTap: () {

                      },

                      child: Text(
                        "Sign-up",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: orangeColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
}