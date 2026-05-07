import 'package:flutter/material.dart';

class RequestCard extends StatefulWidget {
  final String name;
  final String time;
  final String image;

  const RequestCard({
    super.key,
    required this.name,
    required this.time,
    required this.image,
  });

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
          // heelllfjskjhghg
          Row(
            children: [
              /// PROFILE IMAGE
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(widget.image),
              ),

              const SizedBox(width: 12),

              /// NAME
              Expanded(
                child: Text(
                  widget.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),

              /// TIME
              Text(widget.time, style: const TextStyle(color: Colors.white54)),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              /// ACCEPT BUTTON
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

              /// DECLINE BUTTON
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
