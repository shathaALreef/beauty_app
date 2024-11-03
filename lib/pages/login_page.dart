import 'package:flutter/material.dart';
import 'dart:math';
import 'package:beauty_app/pages/profile_page.dart'; // Import the ProfilePage for navigation

// The main SignInPage widget, which is stateful because it will manage animations and form state
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

// The state class for SignInPage, containing all the logic and UI elements
class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  // Define custom colors used throughout the UI
  final Color primaryColor = Color(0xFF7d98d5); // Main theme color
  final Color darkColor = Color(0xFF333333); // Text and icon color
  final Color secondaryColor = Color(0xFFa273c5); // Accent color
  final Color lightColor2 = Color(0xFFF9F9F9); // Background color
  final Color lightColor = Color(0xFFF9F6EE); // Button text color

  final _formKey =
      GlobalKey<FormState>(); // Key for the form to validate inputs
  bool _obscureText = true; // For toggling password visibility

  // Animation controller for bubbles in the background
  late AnimationController _animationController;
  List<Bubble> bubbles = []; // List to hold bubble objects
  final Random random = Random(); // Random number generator
  final List<double> bubbleSizes = [30, 40, 50]; // Different sizes for bubbles

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for the bubble animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 14), // Duration of the animation cycle
    )..repeat(); // Repeat the animation indefinitely

    // Add a listener to update bubble positions on each tick of the animation
    _animationController.addListener(() {
      updateBubbles();
    });
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is disposed
    _animationController.dispose();
    super.dispose();
  }

  // Method to generate bubbles with random positions and properties
  void generateBubbles(double width, double height) {
    bubbles.clear(); // Clear any existing bubbles
    for (int i = 0; i < 9; i++) {
      // Generate 9 bubbles
      bubbles.add(
        Bubble(
          x: random.nextDouble() * width, // Random x-position
          y: random.nextDouble() * height, // Random y-position
          radius:
              bubbleSizes[random.nextInt(bubbleSizes.length)], // Random size
          speed:
              random.nextDouble() * 0.5 + 0.5, // Random speed for subtle effect
          color: Color.lerp(primaryColor, secondaryColor, random.nextDouble())!
              .withOpacity(
                  0.2), // Random color between primary and secondary with transparency
        ),
      );
    }
  }

  // Method to update the position of each bubble
  void updateBubbles() {
    setState(() {
      for (var bubble in bubbles) {
        bubble.y -= bubble.speed; // Move the bubble upwards
        if (bubble.y + bubble.radius < 0) {
          // If the bubble moves off the top of the screen
          // Reset bubble to the bottom with new random position and size
          bubble.y = MediaQuery.of(context).size.height + bubble.radius;
          bubble.x = random.nextDouble() * MediaQuery.of(context).size.width;
          bubble.radius = bubbleSizes[random.nextInt(bubbleSizes.length)];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access screen dimensions for positioning elements
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Generate bubbles if the list is empty
    if (bubbles.isEmpty) {
      generateBubbles(width, height);
    }

    return Scaffold(
      backgroundColor: lightColor2, // Set the background color
      body: Stack(
        children: [
          // Bubbles background using CustomPaint
          CustomPaint(
            painter: BubblePainter(bubbles), // Custom painter to draw bubbles
            child: Container(
              width: width,
              height: height,
            ),
          ),
          // Main content of the sign-in page
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 60), // Spacing at the top

                // Welcome Back message
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor, // Use primary color for text
                  ),
                ),
                SizedBox(height: 5), // Spacing between text and image

                // Circular image below the welcome text
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Make the container circular
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/mobile_login.png'), // Profile image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10), // Spacing before the form

                // The sign-in form
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey, // Assign the form key
                          child: Column(
                            children: [
                              // Email Input Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(
                                      0xFFFFFFF9), // Input field background color
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkColor
                                          .withOpacity(0.1), // Shadow color
                                      blurRadius: 20,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Enter your email',
                                    prefixIcon:
                                        Icon(Icons.email, color: primaryColor),
                                    filled: true,
                                    fillColor: Color(
                                        0xFFFFFFF9), // Fill color for the input
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: darkColor.withOpacity(
                                              0.1)), // Border color when not focused
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color:
                                              primaryColor), // Border color when focused
                                    ),
                                  ),
                                  validator: (value) {
                                    // Validation logic for the email field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 20), // Spacing between fields
                              // Password Input Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFF9),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkColor.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  obscureText:
                                      _obscureText, // Control visibility of the password
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    prefixIcon:
                                        Icon(Icons.lock, color: primaryColor),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Toggle icon based on password visibility
                                        _obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: darkColor.withOpacity(0.5),
                                      ),
                                      onPressed: () {
                                        // Toggle password visibility
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFFFFFF9),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: darkColor.withOpacity(0.1)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: primaryColor),
                                    ),
                                  ),
                                  validator: (value) {
                                    // Validation logic for the password field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                              // Forgot Password link
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Navigate to Forgot Password screen
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              // Sign In Button
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, proceed with sign-in
                                    int notificationCount =
                                        5; // Example notification count
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePage(
                                            notificationCount:
                                                notificationCount), // Navigate to ProfilePage
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: lightColor, // Text color
                                  backgroundColor:
                                      primaryColor, // Button background color
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 90, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 30),
                              // Register Now link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Don\'t have an account?',
                                      style: TextStyle(color: darkColor)),
                                  TextButton(
                                    onPressed: () {
                                      // Navigate to Registration screen
                                    },
                                    child: Text(
                                      'Register Now',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Class representing a bubble for the background animation
class Bubble {
  double x; // X-coordinate
  double y; // Y-coordinate
  double radius; // Radius of the bubble
  double speed; // Speed at which the bubble moves
  Color color; // Color of the bubble

  Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.color,
  });
}

// Custom painter to draw bubbles on the canvas
class BubblePainter extends CustomPainter {
  List<Bubble> bubbles;

  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Draw each bubble as a circle on the canvas
    for (var bubble in bubbles) {
      paint.color = bubble.color; // Set the color for the bubble
      canvas.drawCircle(Offset(bubble.x, bubble.y), bubble.radius, paint);
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) =>
      true; // Always repaint for animation
}
