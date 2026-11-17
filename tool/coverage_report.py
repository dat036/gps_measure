"""Line coverage per directory from coverage/lcov.info (excludes generated).

  flutter test --coverage && python tool/coverage_report.py [dir ...]
Default dirs: lib/domain lib/core/format. Exits 1 if lib/domain < 90%.
"""
import sys
from collections import OrderedDict

GENERATED = ('.freezed.dart', '.g.dart')


def load(path='coverage/lcov.info'):
    cov, cur = OrderedDict(), None
    with open(path, encoding='utf-8') as fh:
        for line in fh:
            line = line.strip()
            if line.startswith('SF:'):
                cur = line[3:].replace(chr(92), '/')
                cov[cur] = [0, 0]
            elif line.startswith('DA:'):
                hits = int(line[3:].split(',')[1])
                cov[cur][1] += 1
                cov[cur][0] += hits > 0
    return cov


def main(dirs):
    cov = load()
    failed = False
    for d in dirs:
        hit = total = 0
        for f, (h, n) in cov.items():
            if d in f and not f.endswith(GENERATED):
                hit += h
                total += n
                if n and h < n:
                    print(f'  {f[f.index(d):]:60} {h}/{n}  {100 * h / n:5.1f}%')
        pct = 100 * hit / total if total else 0
        print(f'{d:62} {hit}/{total}  {pct:5.1f}%')
        if d == 'lib/domain' and pct < 90:
            failed = True
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:] or ['lib/domain', 'lib/core/format']))
