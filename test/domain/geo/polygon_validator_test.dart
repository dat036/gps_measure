import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/geo/local_projection.dart';
import 'package:gps_measurement/domain/geo/polygon_validator.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

void main() {
  final proj = LocalProjection(const GeoPoint(lat: 21, lng: 105.8));
  List<GeoPoint> ring(List<(double, double)> xy) => xy.map(proj.toGeo).toList();

  group('selfIntersects', () {
    test('simple convex and concave rings do not intersect', () {
      expect(
        PolygonValidator.selfIntersects(
          ring([(0, 0), (100, 0), (100, 100), (0, 100)]),
        ),
        isFalse,
      );
      expect(
        PolygonValidator.selfIntersects(
          ring([(0, 0), (80, 0), (80, 30), (30, 30), (30, 90), (0, 90)]),
        ),
        isFalse,
      );
    });

    test('bow-tie intersects', () {
      expect(
        PolygonValidator.selfIntersects(
          ring([(0, 0), (100, 100), (100, 0), (0, 100)]),
        ),
        isTrue,
      );
    });

    test('crossing via the closing edge', () {
      expect(
        PolygonValidator.selfIntersects(
          ring([(0, 0), (100, 0), (0, 50), (100, 100), (50, -20)]),
        ),
        isTrue,
      );
    });

    test('touching / collinear overlap counts', () {
      // Vertex (50,0) lies on the edge (0,0)→(100,0)… of a spike.
      expect(
        PolygonValidator.selfIntersects(
          ring([(0, 0), (100, 0), (100, 50), (50, 0), (0, 50)]),
        ),
        isTrue,
      );
    });

    test('triangles and huge rings are not checked', () {
      expect(
        PolygonValidator.selfIntersects(ring([(0, 0), (1, 0), (0, 1)])),
        isFalse,
      );
      final big = [
        for (var i = 0; i < 301; i++) (i.toDouble(), i.isEven ? 0.0 : 10.0),
      ];
      expect(PolygonValidator.selfIntersects(ring(big)), isFalse);
    });
  });

  group('isDegenerate', () {
    test('fewer than 3 distinct points', () {
      final p = ring([(0, 0), (10, 0)]);
      expect(PolygonValidator.isDegenerate([...p, p.first]), isTrue);
    });

    test('tiny area', () {
      expect(
        PolygonValidator.isDegenerate(ring([(0, 0), (0.5, 0), (0, 0.5)])),
        isTrue,
      );
      expect(
        PolygonValidator.isDegenerate(ring([(0, 0), (10, 0), (0, 10)])),
        isFalse,
      );
    });
  });

  test('LocalProjection round-trips', () {
    final g = proj.toGeo((123.4, -56.7));
    final (x, y) = proj.toXY(g);
    expect(x, closeTo(123.4, 1e-6));
    expect(y, closeTo(-56.7, 1e-6));
  });
}
