import 'package:cinema/QR_CODE/qr_code.dart';
import 'package:flutter/material.dart';

class SelectedSeatsPage extends StatefulWidget {
  final List<String> selectedSeats;
  final List<int> seatPrize;
  final String upiId = 'jenilparmar94091@okaxis'; // Your UPI ID
  final String userName = 'Jenil'; // Your name/business name

  const SelectedSeatsPage({
    super.key,
    required this.selectedSeats,
    required this.seatPrize,
  });

  @override
  State<SelectedSeatsPage> createState() => _SelectedSeatsPageState();
}

class _SelectedSeatsPageState extends State<SelectedSeatsPage> {
  // Food menu options
  final List<Map<String, dynamic>> foodMenu = [
    {"name": "Burger", "price": 120},
    {"name": "Pizza", "price": 250},
    {"name": "Fries", "price": 70},
    {"name": "Salad", "price": 150},
  ];

  // Selected food items for each seat
  late List<List<Map<String, dynamic>>> selectedFoodItems;

  @override
  void initState() {
    super.initState();
    // Initialize selected food items as empty lists for each seat
    selectedFoodItems = List.generate(widget.selectedSeats.length, (_) => []);
  }

  int calculateTotalCost() {
    // Calculate total cost (seat price + food prices)
    return widget.seatPrize.reduce((a, b) => a + b) +
        selectedFoodItems.fold<int>(
            0,
            (sum, seatFoodItems) =>
                sum +
                seatFoodItems.fold<int>(
                    0, (subSum, item) => subSum + (item['price'] as int)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Selected Seats Information'),
      ),
      body: Container(
        color: Colors.pink[50], // Apply matching background color
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedSeats.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.event_seat),
                    title: Text(
                      widget.selectedSeats[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Multi-Select Food Menu
                        ElevatedButton(
                          onPressed: () {
                            _showFoodSelectionDialog(index);
                          },
                          child: const Text("Select Food"),
                        ),
                        const SizedBox(width: 10),
                        // Seat price
                        Text(
                          "₹${widget.seatPrize[index]}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    subtitle: selectedFoodItems[index].isNotEmpty
                        ? Text(
                            "Food: ${selectedFoodItems[index].map((item) => item['name']).join(', ')}")
                        : const Text("No food selected"),
                  );
                },
              ),
            ),
            // Total fare and Payment Button Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.pink[50], // Same as the background color
              child: Column(
                children: [
                  Text(
                    "Your total fare is ₹${calculateTotalCost()}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to QR code page
                      int totalCost = calculateTotalCost();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodePage(
                            upiId: widget.upiId,
                            userName: widget.userName,
                            totalCost: totalCost,
                          ),
                        ),
                      );
                    },
                    child: Text('Pay ₹${calculateTotalCost()}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Multi-Select Dialog
  void _showFoodSelectionDialog(int seatIndex) {
    List<bool> selected = List.generate(foodMenu.length, (index) {
      return selectedFoodItems[seatIndex].contains(foodMenu[index]);
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Food"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter dialogSetState) {
              return SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: foodMenu.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(foodMenu[index]['name']),
                      subtitle: Text("₹${foodMenu[index]['price']}"),
                      value: selected[index],
                      onChanged: (bool? value) {
                        dialogSetState(() {
                          selected[index] = value!;
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Update main state
                setState(() {
                  selectedFoodItems[seatIndex] = foodMenu
                      .where((item) => selected[foodMenu.indexOf(item)])
                      .toList();
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
