import 'package:flutter/material.dart';
import 'package:gps_measurement/core/format/money_formatter.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/units/land_value.dart';

/// A land price: amount per `unit` in `currency`.
typedef LandPrice = ({double? price, AreaUnit unit, String currency});

/// The measurement's stored price, else an empty one in [fallbackUnit] and
/// the [region]'s currency.
LandPrice landPriceOf(
  Measurement m, {
  required AreaUnit fallbackUnit,
  required String? region,
}) => (
  price: m.unitPrice,
  unit: m.unitPriceArea ?? fallbackUnit,
  currency: m.unitPriceCurrency ?? LandValue.currencyForRegion(region),
);

/// Unit price + "per" unit + "Estimated value ≈ 1,87 tỷ" (`plan.md`
/// P8-04, `design.md` §5.6). Reports every change through [onChanged].
class LandValueField extends StatefulWidget {
  const LandValueField({
    required this.areaM2,
    required this.initial,
    required this.onChanged,
    super.key,
  });

  final double? areaM2;
  final LandPrice initial;
  final ValueChanged<LandPrice> onChanged;

  @override
  State<LandValueField> createState() => _LandValueFieldState();
}

class _LandValueFieldState extends State<LandValueField> {
  late final TextEditingController _text;
  late AreaUnit _unit = widget.initial.unit;
  double? _price;

  String get _locale => Localizations.localeOf(context).toString();

  @override
  void initState() {
    super.initState();
    _price = widget.initial.price;
    _text = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_text.text.isEmpty && _price != null) {
      _text.text = MoneyFormatter.input(_price!, locale: _locale);
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged((
    price: _price,
    unit: _unit,
    currency: widget.initial.currency,
  ));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final currency = widget.initial.currency;
    final estimate = LandValue.estimate(
      areaM2: widget.areaM2,
      unitPrice: _price,
      priceUnit: _unit,
    );
    final invalid = _text.text.trim().isNotEmpty && (_price ?? 0) <= 0;
    const border = OutlineInputBorder(borderRadius: LmRadius.smAll);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _text,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (t) {
                  setState(
                    () => _price = MoneyFormatter.parse(t, locale: _locale),
                  );
                  _emit();
                },
                decoration: InputDecoration(
                  labelText: l10n.landValueUnitPrice,
                  suffixText: currency,
                  errorText: invalid ? l10n.landValueInvalid : null,
                  border: border,
                ),
              ),
            ),
            const SizedBox(width: LmSpacing.s8),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<AreaUnit>(
                initialValue: _unit,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.landValueUnit,
                  border: border,
                ),
                items: [
                  for (final u in AreaUnit.values)
                    DropdownMenuItem(
                      value: u,
                      // The field label already says "Per".
                      child: Text(
                        UnitFormatter.areaSymbol(u),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (u) {
                  if (u == null) return;
                  setState(() => _unit = u);
                  _emit();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: LmSpacing.s8),
        Text(
          widget.areaM2 == null
              ? l10n.landValueNeedsArea
              : estimate == null
              ? ''
              : l10n.landValueEstimated(
                  MoneyFormatter.format(
                    estimate,
                    locale: _locale,
                    currency: currency,
                  ),
                ),
          style: LmTypography.bodyLg.copyWith(
            fontWeight: FontWeight.w600,
            color: widget.areaM2 == null
                ? colors.textSecondary
                : colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
