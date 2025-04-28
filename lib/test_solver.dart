// test_solver.dart
import 'package:poker_solver/poker_solver.dart' as solver;

// Hilfsfunktion zum Drucken der Details einer Hand
void printHandDetails(solver.Hand hand) {
  // print('  Name: ${hand.name}'); // Name (z.B. "Pair")
  // print('  Description: ${hand.descr}'); // Beschreibung (z.B. "Pair of Kings")

  // // Drucke das gesamte Objekt, um mehr Hinweise zu bekommen
  // print('  toString(): ${hand.toString()}');
  // print('---------------\n');
}

void main() {
  final hand = solver.Hand.solveHand(["Kd", "Ks", "Qh", "Jc", "9d"]);

  printHandDetails(hand);
}
