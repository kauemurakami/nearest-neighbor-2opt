import 'dart:math';

class Point {
  final String name;
  final double x, y;
  Point(this.name, this.x, this.y);

  double distanceTo(Point other) {
    return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2));
  }
}

List<Point> nearestNeighbor(List<Point> points) {
  if (points.isEmpty) return [];

  List<Point> route = [];
  Set<Point> unvisited = points.toSet();
  Point current = points.first;
  route.add(current);
  unvisited.remove(current);

  while (unvisited.isNotEmpty) {
    Point next = unvisited.reduce((a, b) => current.distanceTo(a) < current.distanceTo(b) ? a : b);
    route.add(next);
    unvisited.remove(next);
    current = next;
  }

  return route;
}

List<Point> twoOpt(List<Point> route) {
  bool improved = true;
  while (improved) {
    improved = false;
    for (int i = 1; i < route.length - 2; i++) {
      for (int j = i + 1; j < route.length - 1; j++) {
        if (_distanceImprovement(route, i, j)) {
          _reverseSegment(route, i, j);
          improved = true;
        }
      }
    }
  }
  return route;
}

bool _distanceImprovement(List<Point> route, int i, int j) {
  double before = route[i - 1].distanceTo(route[i]) + route[j].distanceTo(route[j + 1]);
  double after = route[i - 1].distanceTo(route[j]) + route[i].distanceTo(route[j + 1]);
  return after < before;
}

void _reverseSegment(List<Point> route, int i, int j) {
  while (i < j) {
    Point temp = route[i];
    route[i] = route[j];
    route[j] = temp;
    i++;
    j--;
  }
}

void main() {
  List<Point> points = [Point("A", 0, 0), Point("B", 2, 3), Point("C", 5, 1), Point("D", 6, 4), Point("E", 8, 2)];

  List<Point> initialRoute = nearestNeighbor(points);
  List<Point> optimizedRoute = twoOpt(initialRoute);

  print("Rota inicial:");
  initialRoute.forEach((p) => print("${p.name}: (${p.x}, ${p.y})"));

  print("\nRota otimizada:");
  optimizedRoute.forEach((p) => print("${p.name}: (${p.x}, ${p.y})"));
}
