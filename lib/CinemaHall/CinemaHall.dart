import 'package:cinema/SelectedSeatsPage/selectedseatpage.dart';
import 'package:flutter/material.dart';

class Cinemahall extends StatefulWidget {
  final int Platinum;
  final int Gold;
  final int Silver;
  final int PlatinumPrize;
  final int GoldPrize;
  final int SilverPrize;

  const Cinemahall({
    super.key,
    required this.Platinum,
    required this.Gold,
    required this.Silver,
    required this.PlatinumPrize,
    required this.GoldPrize,
    required this.SilverPrize,
  });

  @override
  State<StatefulWidget> createState() {
    return _CinemahallState();
  }
}

class _CinemahallState extends State<Cinemahall> {
  List<String> selectedSeats = [];

  List<Widget> generateSeats(
      int seatCount, Color color, String seatPrefix, int price) {
    int seatsPerRow = 4;
    return List<Widget>.generate(seatCount, (index) {
      String rowLetter = String.fromCharCode(65 + (index ~/ seatsPerRow));
      int seatNumber = (index % seatsPerRow) + 1;
      String seatLabel = "$rowLetter$seatPrefix$seatNumber";

      bool isSelected = selectedSeats.contains(seatLabel);

      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedSeats.remove(seatLabel);
                  } else {
                    if (selectedSeats.length < 5) {
                      selectedSeats.add(seatLabel);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You can only select up to 5 seats'),
                        ),
                      );
                    }
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                  color: isSelected
                      ? const Color.fromARGB(255, 255, 238, 0)
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.event_seat,
                  color: color,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 3.4),
            Text(
              seatLabel,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });
  }

  void _showCinemaHallImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: 400,
            child: Image.asset(
              'assets/images/cinemahall.jpeg',
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Displaying selected seats
            Text(
              'Selected: ${selectedSeats.length}/5',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Displaying seat prices
            Row(
              children: [
                Text('P: ₹${widget.PlatinumPrize}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Text('G: ₹${widget.GoldPrize}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Text('S: ₹${widget.SilverPrize}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/image.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adding the Cinema Screen
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'SCREEN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      'Platinum Seats',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: generateSeats(
                      widget.Platinum,
                      const Color.fromARGB(255, 0, 0, 0),
                      'P',
                      widget.PlatinumPrize),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Gold Seats',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: generateSeats(
                      widget.Gold,
                      const Color.fromARGB(255, 0, 0, 0),
                      'G',
                      widget.GoldPrize),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Silver Seats',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: generateSeats(
                      widget.Silver,
                      const Color.fromARGB(255, 0, 0, 0),
                      'S',
                      widget.SilverPrize),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (selectedSeats.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectedSeatsPage(
                      selectedSeats: selectedSeats,
                      seatPrize: selectedSeats.map((seat) {
                        if (seat.contains('P')) {
                          return widget.PlatinumPrize;
                        } else if (seat.contains('G')) {
                          return widget.GoldPrize;
                        } else {
                          return widget.SilverPrize;
                        }
                      }).toList(),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No seats selected!'),
                  ),
                );
              }
            },
            child: const Icon(Icons.check_circle),
            heroTag: 'selectSeats',
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _showCinemaHallImage,
            child: const Icon(Icons.image),
            heroTag: 'showImage',
          ),
        ],
      ),
    );
  }
}
