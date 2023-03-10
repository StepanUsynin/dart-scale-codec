import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' as Crypto;

Future<Uint8List> doubleSha256(Uint8List data) async {
  var sha256 = Crypto.Sha256();
  var sink = sha256.newHashSink();
  sink.add(data.toList());
  sink.close();
  var sink2 = sha256.newHashSink();
  sink2.add((await sink.hash()).bytes);
  sink2.close();
  return Uint8List.fromList((await sink2.hash()).bytes);
}
