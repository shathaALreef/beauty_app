import 'dart:math'; // Importing math library for random number generation
import 'package:flutter/material.dart'; // Importing Flutter material design package

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Removes the debug banner
    home: ProfilePage(), // Sets the home screen to ProfilePage
  ));
}

// ProfilePage is a StatefulWidget because it maintains mutable state
class ProfilePage extends StatefulWidget {
  final int notificationCount; // Number of notifications to display

  ProfilePage({Key? key, this.notificationCount = 0}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// State class for ProfilePage
class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  int _selectedIndex =
      4; // Initial index for bottom navigation bar (Profile tab)
  bool _receiveNotifications = true; // State for notification toggle
  bool _nightMode = false; // State for night mode toggle

  // Custom colors used throughout the app
  final Color primaryColor = Color(0xFF7d98d5); // Main theme color
  final Color darkColor = Color(0xFF333333); // Dark color for text/icons
  final Color secondaryColor = Color(0xFFa273c5); // Secondary theme color
  final Color lightColor = Color(0xFFF9F6EE); // Light color for text/icons
  final Color lightColor2 = Color(0xFFF9F9F9); // Background color

  late AnimationController _bubbleController; // Controller for bubble animation
  List<Bubble> bubbles = []; // List to hold bubble objects
  final Random random = Random(); // Random number generator
  final List<double> bubbleSizes = [30, 40, 50]; // Possible sizes for bubbles

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for the bubbles
    _bubbleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat(); // Repeat the animation indefinitely

    // Add a listener to update bubbles on each animation tick
    _bubbleController.addListener(() => setState(updateBubbles));

    // Initialize bubbles after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      generateBubbles(size.width, size.height);
    });
  }

  // Generates initial bubbles with random positions and properties
  void generateBubbles(double width, double height) {
    bubbles.clear(); // Clear existing bubbles
    for (int i = 0; i < 9; i++) {
      bubbles.add(Bubble(
        x: random.nextDouble() * width, // Random x-position
        y: random.nextDouble() * height, // Random y-position
        radius: bubbleSizes[random.nextInt(bubbleSizes.length)], // Random size
        speed:
            random.nextDouble() * 0.5 + 0.5, // Random speed for subtle effect
        color: Color.lerp(primaryColor, secondaryColor, random.nextDouble())!
            .withOpacity(0.2), // Random color with transparency
      ));
    }
  }

  // Updates the position of each bubble to create an upward floating effect
  void updateBubbles() {
    for (var bubble in bubbles) {
      bubble.y -= bubble.speed; // Move bubble upwards
      if (bubble.y + bubble.radius < 0) {
        // If the bubble moves off the top of the screen
        bubble.y = MediaQuery.of(context).size.height +
            bubble.radius; // Reset to bottom
        bubble.x = random.nextDouble() *
            MediaQuery.of(context).size.width; // Random x-position
      }
    }
  }

  @override
  void dispose() {
    _bubbleController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  // Handles the tap on bottom navigation items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor2, // Set the background color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar height
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, // Gradient starts at the top left
              end: Alignment.bottomRight, // Gradient ends at the bottom right
              colors: [
                primaryColor,
                secondaryColor,
              ],
            ),
          ),
          child: AppBar(
            title: Text(
              "Account Settings",
              style: TextStyle(color: lightColor), // Title text style
            ),
            backgroundColor:
                Colors.transparent, // Transparent to show the gradient
            elevation: 0, // Remove shadow under AppBar
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background bubbles
          CustomPaint(
            painter: BubblePainter(bubbles), // Custom painter for bubbles
            child: Container(),
          ),
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0), // Padding around the content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture with edit option
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/5857.jpg'), // Profile image
                      ),
                      // Edit icon overlaid on profile picture
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(
                                0.8), // Background color for the "+" button
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: Color(0xFFFFFFF9), // Icon color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Profile options container with rounded corners
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor, // Background color of the container
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      // Notification setting with toggle switch
                      _buildProfileOptionWithToggle(
                        title: "Notification",
                        icon: Icons.notifications,
                        value: _receiveNotifications,
                        onChanged: (value) {
                          setState(() {
                            _receiveNotifications = value; // Update state
                          });
                        },
                      ),
                      // Favorites option
                      _buildProfileOption(
                        title: "Favorites",
                        icon: Icons.favorite_border,
                      ),
                      // Payment option
                      _buildProfileOption(
                        title: "Payment",
                        icon: Icons.payment,
                      ),
                      // Help option
                      _buildProfileOption(
                        title: "Help",
                        icon: Icons.help_outline,
                      ),
                      // Privacy option
                      _buildProfileOption(
                        title: "Privacy",
                        icon: Icons.lock_outline,
                      ),
                      // Night Mode setting with toggle switch
                      _buildProfileOptionWithToggle(
                        title: "Night Mode",
                        icon: Icons.nightlight_round,
                        value: _nightMode,
                        onChanged: (value) {
                          setState(() {
                            _nightMode = value; // Update state
                          });
                        },
                      ),
                      // Change Password option
                      _buildProfileOption(
                        title: "Change Password",
                        icon: Icons.lock,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),
                // Sign Out button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle logout action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          secondaryColor, // Button background color
                      padding:
                          EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                          fontSize: 20, color: lightColor), // Button text style
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Custom bottom navigation bar
      bottomNavigationBar: CreativeBottomNavigationBar(
        selectedIndex: _selectedIndex, // Current selected index
        onItemTapped: _onItemTapped, // Callback when an item is tapped
        secondaryColor: secondaryColor, // Color for selected items
      ),
    );
  }

  // Builds a profile option row with a toggle switch
  Widget _buildProfileOptionWithToggle({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged, // Callback when switch is toggled
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Space between icon/title and switch
        children: [
          Row(
            children: [
              Icon(icon, color: lightColor), // Option icon
              SizedBox(width: 16),
              Text(
                title,
                style:
                    TextStyle(fontSize: 20, color: lightColor), // Option title
              ),
            ],
          ),
          Switch(
            value: value, // Current value of the switch
            onChanged: onChanged, // Update value when toggled
            activeColor: lightColor, // Switch color when active
          ),
        ],
      ),
    );
  }

  // Builds a profile option row without a toggle switch
  Widget _buildProfileOption({
    required String title,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Vertical padding
      child: Row(
        children: [
          Icon(icon, color: lightColor), // Option icon
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 20, color: lightColor), // Option title
            ),
          ),
        ],
      ),
    );
  }
}

// Custom bottom navigation bar with icons and labels
class CreativeBottomNavigationBar extends StatelessWidget {
  final int selectedIndex; // Currently selected index
  final Function(int) onItemTapped; // Callback when an item is tapped
  final Color secondaryColor; // Color for selected items

  CreativeBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.secondaryColor,
  });

  // List of icons for the navigation items
  final List<IconData> icons = [
    Icons.home,
    Icons.category,
    Icons.favorite,
    Icons.shopping_cart,
    Icons.person,
  ];

  // Corresponding labels for the navigation items
  final List<String> labels = [
    "Home",
    "Categories",
    "Favorites",
    "Cart",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Height of the navigation bar
      decoration: BoxDecoration(
        color: Color(0xFFFFFFF9), // Background color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), // Rounded corners at the top
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Shadow color
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Space items evenly
        children: List.generate(icons.length, (index) {
          bool isSelected =
              selectedIndex == index; // Check if the item is selected
          return GestureDetector(
            onTap: () => onItemTapped(index), // Handle tap
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300), // Animation duration
                  curve: Curves.easeOut, // Animation curve
                  decoration: BoxDecoration(
                    color: isSelected
                        ? secondaryColor.withOpacity(0.1)
                        : Colors.transparent, // Highlight selected item
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: secondaryColor
                                  .withOpacity(0.3), // Shadow for selected item
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ]
                        : [],
                  ),
                  padding: EdgeInsets.all(8), // Padding around the icon
                  child: Icon(
                    icons[index],
                    color: isSelected
                        ? secondaryColor
                        : Colors.grey[400], // Icon color
                    size: 26,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  labels[index],
                  style: TextStyle(
                    color: isSelected
                        ? secondaryColor
                        : Colors.grey[600], // Label color
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal, // Font weight
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// Class representing a bubble for the background animation
class Bubble {
  double x; // X-coordinate position
  double y; // Y-coordinate position
  double radius; // Size of the bubble
  double speed; // Speed at which the bubble moves upward
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
  final List<Bubble> bubbles; // List of bubbles to paint

  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint(); // Paint object to define how to paint

    // Draw each bubble as a circle on the canvas
    for (var bubble in bubbles) {
      paint.color = bubble.color; // Set the paint color
      canvas.drawCircle(
          Offset(bubble.x, bubble.y), bubble.radius, paint); // Draw the bubble
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => true; // Always repaint
}
