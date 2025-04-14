import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const OFCApp());
  });
}

class OFCApp extends StatelessWidget {
  const OFCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OFC Pineapple',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> deck = [];
  List<String> hand = [];
  List<String> front = [];
  List<String> middle = [];
  List<String> back = [];

  final double cardWidth = 46.2;
  final double cardHeight = 69.3;

  @override
  void initState() {
    super.initState();
    generateRandomHand();
  }

  void generateRandomHand() {
    List<String> suits = ['C', 'D', 'H', 'S'];
    List<String> ranks = [
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'T',
      'J',
      'Q',
      'K',
      'A',
    ];
    deck = [
      for (var suit in suits)
        for (var rank in ranks) '$rank$suit',
    ];
    deck.shuffle(Random());
    hand = deck.take(13).toList();
    front.clear();
    middle.clear();
    back.clear();
  }

  void swapCards(
    String draggedCard,
    List<String> draggedFrom,
    String targetCard,
    List<String> targetList,
  ) {
    int draggedIndex = draggedFrom.indexOf(draggedCard);
    int targetIndex = targetList.indexOf(targetCard);

    if (draggedIndex != -1 && targetIndex != -1) {
      setState(() {
        draggedFrom[draggedIndex] = targetCard;
        targetList[targetIndex] = draggedCard;
      });
    }
  }

  void moveCard(String card, List<String> from, List<String> to, int maxCards) {
    setState(() {
      if (from.contains(card)) from.remove(card);
      if (to.length < maxCards) to.add(card);
    });
  }

  Widget cardImage(String card) {
    return Image.asset(
      'assets/cards/$card.png',
      width: cardWidth,
      height: cardHeight,
      fit: BoxFit.contain,
      errorBuilder:
          (context, error, stackTrace) => Container(
            width: cardWidth,
            height: cardHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              card,
              style: const TextStyle(color: Colors.black, fontSize: 10),
            ),
          ),
    );
  }

  Widget buildDraggableCard(String card, List<String> origin) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (DragTargetDetails<String> details) {
        return details.data != card;
      },
      onAcceptWithDetails: (DragTargetDetails<String> details) {
        final data = details.data;
        final allLists = [hand, front, middle, back];
        for (var list in allLists) {
          if (list.contains(data)) {
            swapCards(data, list, card, origin);
            break;
          }
        }
      },
      builder:
          (context, candidateData, rejectedData) => Draggable<String>(
            data: card,
            feedback: Material(
              color: Colors.transparent,
              child: cardImage(card),
            ),
            childWhenDragging: Opacity(opacity: 0.3, child: cardImage(card)),
            child: cardImage(card),
          ),
    );
  }

  Widget buildDropSlot(
    List<String> sourceList,
    List<String> targetList,
    int maxCards,
    int index,
  ) {
    String? card = index < targetList.length ? targetList[index] : null;
    return DragTarget<String>(
      onWillAcceptWithDetails: (DragTargetDetails<String> details) {
        return true;
      },
      onAcceptWithDetails: (DragTargetDetails<String> details) {
        final data = details.data;
        final allLists = [hand, front, middle, back];
        for (var list in allLists) {
          if (list.contains(data)) {
            if (card != null) {
              swapCards(data, list, card, targetList);
            } else {
              moveCard(data, list, targetList, maxCards);
            }
            break;
          }
        }
      },
      builder:
          (context, candidateData, rejectedData) => Container(
            width: cardWidth,
            height: cardHeight,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white10,
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(6),
            ),
            child:
                card != null
                    ? buildDraggableCard(card, targetList)
                    : const SizedBox.shrink(),
          ),
    );
  }

  Widget buildRow(List<String> cardList, int slots) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        slots,
        (index) =>
            buildDropSlot(hand + front + middle + back, cardList, slots, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        generateRandomHand();
                      });
                    },
                  ),
                ],
              ),
              buildRow(front, 3),
              const SizedBox(height: 4),
              buildRow(middle, 5),
              const SizedBox(height: 4),
              buildRow(back, 5),
              const SizedBox(height: 4),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        hand.length,
                        (index) => buildDropSlot(
                          front + middle + back,
                          hand,
                          13,
                          index,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
