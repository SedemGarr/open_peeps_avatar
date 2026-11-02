import 'package:flutter_test/flutter_test.dart';
import 'package:open_peeps_avatar/open_peeps_avatar.dart';

void main() {
  test('decode never throws on codes from storage, however malformed', () {
    for (final code in [-1, 0, 0xFFFFFFFF, 0xFF000000, 0x00FF00FF, 1 << 52, 9007199254740991]) {
      expect(() => AvatarLook.decode(code), returnsNormally, reason: 'code $code');
    }
  });

  test('valid codes still decode to themselves', () {
    const look = AvatarLook(head: 3, face: 2, facialHair: 1, accessory: 1, skin: 2, outfit: 4, pose: 5);
    expect(AvatarLook.decode(look.encode()).encode(), look.encode());
  });
}
