import 'package:flutter/material.dart';

class RequestCard extends StatefulWidget {
  final String name;
  final String time;

  const RequestCard({super.key, required this.name, required this.time});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool declined = false;
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff1B1E4A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.purple.withOpacity(.35)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Text(widget.time, style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              /// ACCEPT
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      accepted = true;
                      declined = false;
                    });
                  },
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffFF6FD8), Color(0xff7AA8FF)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        accepted ? "Accepted" : "Accept",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              /// DECLINE
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      declined = true;
                      accepted = false;
                    });
                  },
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: declined
                          ? Colors.red.withOpacity(.35)
                          : Colors.black.withOpacity(.45),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.orange.withOpacity(.5)),
                    ),
                    child: Center(
                      child: Text(
                        declined ? "Declined" : "Decline",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
