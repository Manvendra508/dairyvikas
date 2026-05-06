import 'package:flutter/material.dart';

extension WidgetPadding on Widget {
  Widget get p4 => Padding(padding: const EdgeInsets.all(4), child: this);
  Widget get p8 => Padding(padding: const EdgeInsets.all(8), child: this);
  Widget get p12 => Padding(padding: const EdgeInsets.all(12), child: this);
  Widget get p16 => Padding(padding: const EdgeInsets.all(16), child: this);

  Widget pv(double v) => Padding(
    padding: EdgeInsets.symmetric(vertical: v),
    child: this,
  );
  Widget ph(double h) => Padding(
    padding: EdgeInsets.symmetric(horizontal: h),
    child: this,
  );

  Widget pm({double? all, double? h, double? v}) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: h ?? 0,
      vertical: v ?? 0,
    ).add(EdgeInsets.all(all ?? 0)),
    child: this,
  );
}
