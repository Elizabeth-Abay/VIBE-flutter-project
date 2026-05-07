import 'package:flutter/material.dart';
import '../widgets/notification_card.dart';
import '../widgets/request_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff05072A),

      /// BOTTOM NAVBAR
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(14),
        height: 70,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(153, 153, 153, 1), // silver color
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.home_outlined, color: Colors.white),

            const Icon(Icons.chat_bubble_outline, color: Colors.white),

            /// RECTANGLE + BUTTON
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),

            const Icon(Icons.bookmark_border, color: Colors.white),

            const Icon(Icons.person_outline, color: Colors.white),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// LOGO
                  Image.asset(
                    "assets/vibe_logo.png",
                    height: 55,
                    fit: BoxFit.contain,
                  ),

                  /// RIGHT ICONS
                  Row(
                    children: const [
                      Icon(Icons.notifications, color: Colors.amber, size: 20),

                      SizedBox(width: 12),

                      Icon(Icons.person, color: Colors.lightBlue, size: 20),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// TITLE
            const Text(
              "Notifications",
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w500,
                fontFamily: "Serif",
              ),
            ),

            const SizedBox(height: 28),

            /// TABS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    /// UPDATES TAB
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isUpdates = true;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Updates",
                              style: TextStyle(
                                color: isUpdates
                                    ? Colors.white
                                    : Colors.white54,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              height: 3,
                              width: 90,
                              color: isUpdates
                                  ? const Color(0xffD946EF)
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// REQUESTS TAB
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isUpdates = false;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Requests",
                              style: TextStyle(
                                color: !isUpdates
                                    ? Colors.white
                                    : Colors.white54,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              height: 3,
                              width: 90,
                              color: !isUpdates
                                  ? const Color(0xffD946EF)
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(child: isUpdates ? buildUpdates() : buildRequests()),
          ],
        ),
      ),
    );
  }

  /// UPDATES LIST
  Widget buildUpdates() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: const [
        NotificationCard(text: "Abebe accepted your request", time:   "2m ago"),

        NotificationCard(text: "Selam accepted your request", time: "3m ago"),
      ],
    );
  }

  /// REQUESTS LIST
  Widget buildRequests() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: const [
        RequestCard(name: "Selam", time: "2m ago"),

        RequestCard(name: "Abebe", time: "15m ago"),
      ],
    );
  }
}
