import 'dart:math';

class Point {
  final String name;
  Point(this.name);
}

class DistanceMatrix {
  final Map<String, Map<String, double>> distances;

  DistanceMatrix(List<Point> points, List<List<double>> dist) : distances = _buildDistanceMap(points, dist);

  static Map<String, Map<String, double>> _buildDistanceMap(List<Point> points, List<List<double>> dist) {
    Map<String, Map<String, double>> map = {};
    for (int i = 0; i < points.length; i++) {
      map[points[i].name] = {};
      for (int j = 0; j < points.length; j++) {
        map[points[i].name]![points[j].name] = dist[i][j];
      }
    }
    return map;
  }

  double distanceBetween(Point a, Point b) {
    return distances[a.name]?[b.name] ?? double.infinity;
  }
}

List<Point> nearestNeighbor(List<Point> points, DistanceMatrix matrix) {
  if (points.isEmpty) return [];

  List<Point> route = [];
  Set<Point> unvisited = points.toSet();
  Point current = points.first;
  route.add(current);
  unvisited.remove(current);

  while (unvisited.isNotEmpty) {
    Point next =
        unvisited.reduce((a, b) => matrix.distanceBetween(current, a) < matrix.distanceBetween(current, b) ? a : b);
    route.add(next);
    unvisited.remove(next);
    current = next;
  }

  return route;
}

List<Point> twoOpt(List<Point> route, DistanceMatrix matrix) {
  bool improved = true;
  while (improved) {
    improved = false;
    for (int i = 1; i < route.length - 2; i++) {
      for (int j = i + 1; j < route.length - 1; j++) {
        if (_distanceImprovement(route, i, j, matrix)) {
          _reverseSegment(route, i, j);
          improved = true;
        }
      }
    }
  }
  return route;
}

bool _distanceImprovement(List<Point> route, int i, int j, DistanceMatrix matrix) {
  double before = matrix.distanceBetween(route[i - 1], route[i]) + matrix.distanceBetween(route[j], route[j + 1]);
  double after = matrix.distanceBetween(route[i - 1], route[j]) + matrix.distanceBetween(route[i], route[j + 1]);
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
  List<Point> points = [Point("A"), Point("B"), Point("C"), Point("D"), Point("E")];

  // Matriz de distâncias entre os pontos
  List<List<double>> distances = [
    [0, 3, 10, 7, 6], // Distâncias de A
    [3, 0, 5, 8, 4], // Distâncias de B
    [10, 5, 0, 6, 9], // Distâncias de C
    [7, 8, 6, 0, 2], // Distâncias de D
    [6, 4, 9, 2, 0] // Distâncias de E
  ];

  DistanceMatrix matrix = DistanceMatrix(points, distances);

  List<Point> initialRoute = nearestNeighbor(points, matrix);
  List<Point> optimizedRoute = twoOpt(initialRoute, matrix);

  print("Rota inicial:");
  initialRoute.forEach((p) => print(p.name));

  print("\nRota otimizada:");
  optimizedRoute.forEach((p) => print(p.name));
}
