// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Test numeric types.
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasm/wasm.dart';

void main() {
  test('numerics', () {
    // int64_t addI64(int64_t x, int64_t y) { return x + y; }
    // int32_t addI32(int32_t x, int32_t y) { return x + y; }
    // double addF64(double x, double y) { return x + y; }
    // float addF32(float x, float y) { return x + y; }
    var data = Uint8List.fromList([
      0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x19, 0x04, 0x60, //
      0x02, 0x7e, 0x7e, 0x01, 0x7e, 0x60, 0x02, 0x7f, 0x7f, 0x01, 0x7f, 0x60,
      0x02, 0x7c, 0x7c, 0x01, 0x7c, 0x60, 0x02, 0x7d, 0x7d, 0x01, 0x7d, 0x03,
      0x05, 0x04, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x01, 0x70, 0x01, 0x01,
      0x01, 0x05, 0x03, 0x01, 0x00, 0x02, 0x06, 0x08, 0x01, 0x7f, 0x01, 0x41,
      0x80, 0x88, 0x04, 0x0b, 0x07, 0x2e, 0x05, 0x06, 0x6d, 0x65, 0x6d, 0x6f,
      0x72, 0x79, 0x02, 0x00, 0x06, 0x61, 0x64, 0x64, 0x49, 0x36, 0x34, 0x00,
      0x00, 0x06, 0x61, 0x64, 0x64, 0x49, 0x33, 0x32, 0x00, 0x01, 0x06, 0x61,
      0x64, 0x64, 0x46, 0x36, 0x34, 0x00, 0x02, 0x06, 0x61, 0x64, 0x64, 0x46,
      0x33, 0x32, 0x00, 0x03, 0x0a, 0x21, 0x04, 0x07, 0x00, 0x20, 0x01, 0x20,
      0x00, 0x7c, 0x0b, 0x07, 0x00, 0x20, 0x01, 0x20, 0x00, 0x6a, 0x0b, 0x07,
      0x00, 0x20, 0x00, 0x20, 0x01, 0xa0, 0x0b, 0x07, 0x00, 0x20, 0x00, 0x20,
      0x01, 0x92, 0x0b,
    ]);

    var inst = wasmModuleCompileSync(data).builder().build();
    var addI64 = inst.lookupFunction('addI64');
    var addI32 = inst.lookupFunction('addI32');
    var addF64 = inst.lookupFunction('addF64');
    var addF32 = inst.lookupFunction('addF32');

    var i64 = addI64(0x123456789ABCDEF, 0xFEDCBA987654321) as int;
    expect(i64, 0x1111111111111110);

    var i32 = addI32(0xABCDEF, 0xFEDCBA) as int;
    expect(i32, 0x1aaaaa9);

    var f64 = addF64(1234.5678, 8765.4321) as double;
    expect(f64, closeTo(9999.9999, 1e-6));

    var f32 = addF32(1234.5678, 8765.4321) as double;
    expect(f32, closeTo(9999.9999, 1e-3));
  });
}