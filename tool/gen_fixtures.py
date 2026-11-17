"""Generates Phase 1 test fixtures (deterministic).

  python tool/gen_fixtures.py

- test/fixtures/area_cases.json: polygons whose expected area comes from a
  method INDEPENDENT of GeoCalculator's spherical-excess formula:
    * exact latitude-band formula for lat/lng rectangles,
    * L'Huilier's theorem for triangles,
    * Lambert azimuthal equal-area projection of great-circle-densified
      edges + shoelace for everything else.
  All on a sphere of radius 6378137 m (what Google Maps uses for areas).
  Expected perimeters: haversine, R = 6371008.8 m.
- test/fixtures/gpx/*.gpx: SYNTHETIC walks with realistic GPS error
  (correlated AR(1) noise, low-accuracy bursts, a speed spike, a duplicate
  timestamp, mocked fixes). Replace/extend with real recordings (plan P1-04).
"""
import json
import math
import os
import random
from datetime import datetime, timedelta, timezone

R_AREA = 6378137.0
R_DIST = 6371008.8
ROOT = os.path.join(os.path.dirname(__file__), '..', 'test', 'fixtures')


# ---------------------------------------------------------------- geometry
def haversine(a, b, r=R_DIST):
    la1, lo1, la2, lo2 = map(math.radians, (a[0], a[1], b[0], b[1]))
    h = math.sin((la2 - la1) / 2) ** 2 + math.cos(la1) * math.cos(la2) * math.sin((lo2 - lo1) / 2) ** 2
    return 2 * r * math.asin(min(1, math.sqrt(h)))


def perimeter(ring):
    return sum(haversine(ring[i], ring[(i + 1) % len(ring)]) for i in range(len(ring)))


def slerp(a, b, f):
    la1, lo1, la2, lo2 = map(math.radians, (a[0], a[1], b[0], b[1]))
    d = haversine(a, b, 1.0)
    if d < 1e-15:
        return a
    wa, wb = math.sin((1 - f) * d) / math.sin(d), math.sin(f * d) / math.sin(d)
    x = wa * math.cos(la1) * math.cos(lo1) + wb * math.cos(la2) * math.cos(lo2)
    y = wa * math.cos(la1) * math.sin(lo1) + wb * math.cos(la2) * math.sin(lo2)
    z = wa * math.sin(la1) + wb * math.sin(la2)
    return (math.degrees(math.atan2(z, math.hypot(x, y))), math.degrees(math.atan2(y, x)))


def laea_area(ring, densify=200):
    """Great-circle polygon area via Lambert azimuthal equal-area + shoelace."""
    lat0 = math.radians(sum(p[0] for p in ring) / len(ring))
    lon0 = math.radians(sum(p[1] for p in ring) / len(ring))
    pts = []
    for i in range(len(ring)):
        a, b = ring[i], ring[(i + 1) % len(ring)]
        for k in range(densify):
            pts.append(slerp(a, b, k / densify))
    xy = []
    for la, lo in pts:
        la, lo = math.radians(la), math.radians(lo)
        k = math.sqrt(2 / (1 + math.sin(lat0) * math.sin(la) + math.cos(lat0) * math.cos(la) * math.cos(lo - lon0)))
        xy.append((R_AREA * k * math.cos(la) * math.sin(lo - lon0),
                   R_AREA * k * (math.cos(lat0) * math.sin(la) - math.sin(lat0) * math.cos(la) * math.cos(lo - lon0))))
    s = 0.0
    for i in range(len(xy)):
        x0, y0 = xy[i]
        x1, y1 = xy[(i + 1) % len(xy)]
        s += x0 * y1 - x1 * y0
    return abs(s) / 2


def band_rectangle(lat, lng, width_m, height_m):
    dlat = math.degrees(height_m / R_AREA)
    dlng = math.degrees(width_m / (R_AREA * math.cos(math.radians(lat))))
    ring = [(lat, lng), (lat, lng + dlng), (lat + dlat, lng + dlng), (lat + dlat, lng)]
    area = R_AREA ** 2 * math.radians(dlng) * (math.sin(math.radians(lat + dlat)) - math.sin(math.radians(lat)))
    return ring, area


def lhuilier(tri):
    a = haversine(tri[1], tri[2], 1.0)
    b = haversine(tri[0], tri[2], 1.0)
    c = haversine(tri[0], tri[1], 1.0)
    s = (a + b + c) / 2
    t = math.tan(s / 2) * math.tan((s - a) / 2) * math.tan((s - b) / 2) * math.tan((s - c) / 2)
    return 4 * math.atan(math.sqrt(t)) * R_AREA ** 2


def offset(origin, east_m, north_m):
    lat = origin[0] + math.degrees(north_m / R_DIST)
    lng = origin[1] + math.degrees(east_m / (R_DIST * math.cos(math.radians(origin[0]))))
    return (lat, lng)


# ---------------------------------------------------------------- area cases
def area_cases():
    cases = []

    def add(name, ring, area, method, note=''):
        cases.append({
            'name': name,
            'method': method,
            'note': note,
            'points': [[round(p[0], 9), round(p[1], 9)] for p in ring],
            'area_m2': round(area, 4),
            'perimeter_m': round(perimeter(ring), 4),
        })

    for name, lat, lng in [('square_100m_equator', 0.0, 0.0),
                           ('square_100m_hanoi_21N', 21.0285, 105.8542),
                           ('square_100m_60N', 60.0, 10.0)]:
        ring, area = band_rectangle(lat, lng, 100, 100)
        add(name, ring, area, 'latitude band (exact)')

    ring, area = band_rectangle(11.0, 106.5, 1000, 1000)
    add('farm_1km_binh_duong_11N', ring, area, 'latitude band (exact)')

    tri = [(10.7769, 106.7009), (10.7831, 106.7098), (10.7702, 106.7121)]
    add('triangle_hcmc', tri, lhuilier(tri), "L'Huilier")

    o = (21.0366, 105.8340)
    l_shape = [offset(o, e, n) for e, n in [(0, 0), (80, 0), (80, 30), (30, 30), (30, 90), (0, 90)]]
    add('concave_l_shape_hanoi', l_shape, laea_area(l_shape), 'LAEA + shoelace')

    # Irregular paddy parcel shape (Thai Binh), traced by hand on satellite.
    paddy = [(20.44612, 106.33915), (20.44701, 106.34083), (20.44655, 106.34201),
             (20.44540, 106.34236), (20.44466, 106.34120), (20.44503, 106.33979)]
    add('rice_field_thai_binh', paddy, laea_area(paddy), 'LAEA + shoelace',
        'Cross-check with the Google Maps ruler (plan P1-02).')

    region = [(12.20, 108.30), (12.28, 108.35), (12.24, 108.42), (12.17, 108.38)]
    add('large_region_10km_dak_lak', region, laea_area(region), 'LAEA + shoelace')
    return cases


# ---------------------------------------------------------------- GPX
class Ar1:
    """Correlated GPS error: x_t = phi x_{t-1} + e, stationary sigma."""

    def __init__(self, rng, sigma, phi=0.9):
        self.rng, self.phi = rng, phi
        self.inn = sigma * math.sqrt(1 - phi * phi)
        self.e = rng.gauss(0, sigma)
        self.n = rng.gauss(0, sigma)

    def step(self):
        self.e = self.phi * self.e + self.rng.gauss(0, self.inn)
        self.n = self.phi * self.n + self.rng.gauss(0, self.inn)
        return self.e, self.n


def write_gpx(path, name, fixes, desc):
    lines = ['<?xml version="1.0" encoding="UTF-8"?>',
             '<gpx version="1.1" creator="LandMeasure tool/gen_fixtures.py" '
             'xmlns="http://www.topografix.com/GPX/1/1">',
             f'  <metadata><name>{name}</name><desc>{desc}</desc></metadata>',
             f'  <trk><name>{name}</name><trkseg>']
    for f in fixes:
        ext = f'<accuracy>{f["acc"]:.1f}</accuracy>'
        if f.get('mocked'):
            ext += '<mocked>true</mocked>'
        lines.append(f'    <trkpt lat="{f["lat"]:.8f}" lon="{f["lng"]:.8f}">'
                     f'<time>{f["t"].strftime("%Y-%m-%dT%H:%M:%SZ")}</time>'
                     f'<extensions>{ext}</extensions></trkpt>')
    lines += ['  </trkseg></trk>', '</gpx>', '']
    with open(path, 'w', encoding='utf-8', newline='\n') as fh:
        fh.write('\n'.join(lines))


def rectangle_walk(width, height, speed, dt):
    """Positions (east, north) walking a width x height rectangle CCW."""
    corners = [(0, 0), (width, 0), (width, height), (0, height), (0, 0)]
    out, pos_along = [], 0.0
    total = 2 * (width + height)
    step = speed * dt
    while pos_along <= total - 3:  # stop ~3 m before the start
        d = pos_along
        for (x0, y0), (x1, y1) in zip(corners, corners[1:]):
            seg = math.hypot(x1 - x0, y1 - y0)
            if d <= seg:
                out.append((x0 + (x1 - x0) * d / seg, y0 + (y1 - y0) * d / seg))
                break
            d -= seg
        pos_along += step
    return out


def gpx_fixtures():
    os.makedirs(os.path.join(ROOT, 'gpx'), exist_ok=True)
    t0 = datetime(2026, 9, 28, 7, 0, 0, tzinfo=timezone.utc)
    origin = (21.0000, 105.8000)

    # 1. field loop 100 x 60 m (truth: area 6000 m2, perimeter 320 m).
    rng = random.Random(1)
    noise = Ar1(rng, sigma=2.0)
    fixes = []
    for i, (e, n) in enumerate(rectangle_walk(100, 60, 1.3, 2)):
        ne, nn = noise.step()
        lat, lng = offset(origin, e + ne, n + nn)
        fixes.append({'lat': lat, 'lng': lng, 'acc': rng.uniform(3, 6), 't': t0 + timedelta(seconds=2 * i)})
    for i in (20, 21, 22):  # low-accuracy burst, 15 m off
        lat, lng = offset((fixes[i]['lat'], fixes[i]['lng']), 15, -10)
        fixes[i].update(lat=lat, lng=lng, acc=rng.uniform(35, 50))
    spike = dict(fixes[60])  # teleport 80 m with good accuracy -> speed spike
    spike['lat'], spike['lng'] = offset((spike['lat'], spike['lng']), 80, 0)
    spike['t'] = spike['t'] + timedelta(seconds=1)
    fixes.insert(61, spike)
    fixes.insert(100, dict(fixes[99]))  # duplicate timestamp
    write_gpx(os.path.join(ROOT, 'gpx', 'field_loop.gpx'), 'field_loop', fixes,
              'SYNTHETIC. Truth: rectangle 100x60 m, area 6000 m2, perimeter 320 m.')

    # 2. standing still 3 minutes (truth: 0 m moved).
    rng = random.Random(2)
    noise = Ar1(rng, sigma=3.0, phi=0.95)
    fixes = []
    for i in range(180):
        ne, nn = noise.step()
        lat, lng = offset(origin, ne, nn)
        fixes.append({'lat': lat, 'lng': lng, 'acc': rng.uniform(6, 12), 't': t0 + timedelta(seconds=i)})
    write_gpx(os.path.join(ROOT, 'gpx', 'stationary.gpx'), 'stationary', fixes,
              'SYNTHETIC. Truth: standing still for 180 s.')

    # 3. straight road walk 400 m east, poor-accuracy stretch + mocked fixes.
    rng = random.Random(3)
    noise = Ar1(rng, sigma=2.5)
    fixes = []
    n_fix = int(400 / 1.4 / 2) + 1
    for i in range(n_fix):
        e = min(400.0, i * 2 * 1.4)
        ne, nn = noise.step()
        acc = rng.uniform(4, 8)
        if 60 <= i < 90:  # under trees: accuracy 18-32 m, bigger error
            acc = rng.uniform(18, 32)
            ne, nn = ne * 3, nn * 3
        lat, lng = offset(origin, e + ne, nn)
        fixes.append({'lat': lat, 'lng': lng, 'acc': acc, 't': t0 + timedelta(seconds=2 * i),
                      'mocked': i in (10, 11)})
    write_gpx(os.path.join(ROOT, 'gpx', 'road_walk.gpx'), 'road_walk', fixes,
              'SYNTHETIC. Truth: straight line 400 m east.')


if __name__ == '__main__':
    os.makedirs(ROOT, exist_ok=True)
    with open(os.path.join(ROOT, 'area_cases.json'), 'w', encoding='utf-8', newline='\n') as fh:
        json.dump(area_cases(), fh, indent=2, ensure_ascii=False)
        fh.write('\n')
    gpx_fixtures()
    print('fixtures written to', os.path.abspath(ROOT))
