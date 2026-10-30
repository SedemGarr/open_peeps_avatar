// GENERATED from the SVG path data in assets/peeps (do not edit by hand).
// Neck anchors let any head sit on any body: bodies and poses are cropped
// at the neck, and heads share one canvas, so the head's chin point is
// placed on the body's neck stump.

import 'dart:ui';

import 'package:open_peeps_avatar/src/models/peep_atom.dart';

class PeepAnchors {
  const PeepAnchors._();

  /// Chin/neck point on the 473x567 head canvas.
  static const Offset headChin = Offset(288.7, 516.1);

  /// Neck stump on each bust body (818x733), keyed by atom name.
  static const Map<String, Offset> bodyNeck = {
    'Blazer Black Tee': Offset(488.6, -76.7),
    'Button Shirt 1': Offset(422.5, -41.6),
    'Button Shirt 2': Offset(454.5, -32.0),
    'Coffee': Offset(418.9, -24.1),
    'Device': Offset(419.0, -42.2),
    'Dress': Offset(463.2, -31.5),
    'Explaining': Offset(431.0, -60.0),
    'Fur Jacket': Offset(427.8, -62.7),
    'Gaming': Offset(448.3, -49.8),
    'Gym Shirt': Offset(420.6, -42.3),
    'Hoodie': Offset(458.7, -38.1),
    'Killer': Offset(461.4, -66.6),
    'Macbook': Offset(497.9, -28.7),
    'Paper': Offset(473.6, -31.8),
    'Pointing Up': Offset(464.2, -71.1),
    'Polka Dot Jacket': Offset(463.4, -40.7),
    'Polo and Sweater': Offset(463.4, -59.6),
    'Shirt and Coat': Offset(463.7, -43.3),
    'Sporty Tee': Offset(445.7, -36.2),
    'Striped Pocket Tee': Offset(397.8, -33.1),
    'Striped Tee': Offset(455.1, -44.4),
    'Sweater Dots': Offset(455.7, -14.8),
    'Sweater': Offset(468.6, -22.1),
    'Tee 1': Offset(465.4, -37.4),
    'Tee 2': Offset(465.1, -40.7),
    'Tee Arms Crossed': Offset(420.0, -45.5),
    'Tee Selena': Offset(407.8, -34.1),
    'Thunder T-Shirt': Offset(451.6, -55.7),
    'Turtleneck': Offset(447.9, -33.6),
    'Whatever': Offset(456.7, -23.6),
  };

  /// Headless full-body poses with their neck stumps.
  static const List<({PeepAtom atom, Offset neck})> poses = [
    (
      atom: PeepAtom(
        name: 'blazer-1',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(758.1, -70.6),
    ),
    (
      atom: PeepAtom(
        name: 'blazer-2',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(758.1, -70.6),
    ),
    (
      atom: PeepAtom(
        name: 'blazer-3',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(750.1, -62.8),
    ),
    (
      atom: PeepAtom(
        name: 'blazer-4',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(750.1, -62.8),
    ),
    (
      atom: PeepAtom(
        name: 'crossed_arms-1',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(675.3, -8.7),
    ),
    (
      atom: PeepAtom(
        name: 'crossed_arms-2',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(705.7, -48.7),
    ),
    (
      atom: PeepAtom(
        name: 'easing-1',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(714.5, -37.4),
    ),
    (
      atom: PeepAtom(
        name: 'easing-2',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(714.5, -37.4),
    ),
    (
      atom: PeepAtom(
        name: 'pointing_finger-1',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(804.4, -22.3),
    ),
    (
      atom: PeepAtom(
        name: 'pointing_finger-2',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(771.5, -24.3),
    ),
    (
      atom: PeepAtom(
        name: 'polka_dots',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(665.6, -37.2),
    ),
    (
      atom: PeepAtom(
        name: 'resting-1',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(814.2, -43.5),
    ),
    (
      atom: PeepAtom(
        name: 'resting-2',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(814.3, -43.5),
    ),
    (
      atom: PeepAtom(
        name: 'robot_dance-1',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(683.2, -25.1),
    ),
    (
      atom: PeepAtom(
        name: 'robot_dance-2',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(683.2, -25.1),
    ),
    (
      atom: PeepAtom(
        name: 'robot_dance-3',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(683.2, -25.1),
    ),
    (
      atom: PeepAtom(
        name: 'shirt-1',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(729.8, -46.9),
    ),
    (
      atom: PeepAtom(
        name: 'shirt-2',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(729.6, -47.9),
    ),
    (
      atom: PeepAtom(
        name: 'shirt-3',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(752.1, -72.1),
    ),
    (
      atom: PeepAtom(
        name: 'shirt-4',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(752.1, -72.1),
    ),
    (
      atom: PeepAtom(
        name: 'walking-1',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(726.5, -36.3),
    ),
    (
      atom: PeepAtom(
        name: 'walking-2',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(726.5, -36.3),
    ),
    (
      atom: PeepAtom(
        name: 'walking-3',
        directoryName: 'pose/standing',
        imageHeight: 2500.0,
        imageWidth: 1645.0,
      ),
      neck: Offset(726.5, -36.3),
    ),
    (
      atom: PeepAtom(
        name: 'bike',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(607.2, -44.4),
    ),
    (
      atom: PeepAtom(
        name: 'closed_legs-1',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(630.3, -61.9),
    ),
    (
      atom: PeepAtom(
        name: 'closed_legs-2',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(630.3, -61.9),
    ),
    (
      atom: PeepAtom(
        name: 'crossed_legs',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(704.1, -38.8),
    ),
    (
      atom: PeepAtom(
        name: 'hands_back-1',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(637.3, -89.0),
    ),
    (
      atom: PeepAtom(
        name: 'hands_back-2',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(637.3, -89.0),
    ),
    (
      atom: PeepAtom(
        name: 'mid-1',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(521.1, -80.1),
    ),
    (
      atom: PeepAtom(
        name: 'mid-2',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(521.1, -80.1),
    ),
    (
      atom: PeepAtom(
        name: 'one_leg_up-1',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(630.2, -77.0),
    ),
    (
      atom: PeepAtom(
        name: 'one_leg_up-2',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(630.2, -77.0),
    ),
    (
      atom: PeepAtom(
        name: 'wheelchair',
        directoryName: 'pose/sitting',
        imageHeight: 1856.0,
        imageWidth: 1534.0,
      ),
      neck: Offset(692.3, -54.1),
    ),
  ];
}
