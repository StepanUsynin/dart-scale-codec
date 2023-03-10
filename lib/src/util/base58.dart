import 'dart:typed_data';
import 'package:cryptography/cryptography.dart' as Crypto;
import 'package:bs58/bs58.dart' show base58;

Future<String> base58CheckEncode(Uint8List data, [int address_type = 42]) async {
  int checksumLength = 1;
  if (data.length == 32) {
    checksumLength = 2;
  }
  var address = [address_type] + data.toList();
  var blake2b = Crypto.Blake2b();
  var sink = blake2b.newHashSink();
  sink.add('SS58PRE'.codeUnits + address);
  sink.close();
  var checksum = (await sink.hash()).bytes.sublist(0, checksumLength);
  return base58.encode(Uint8List.fromList(address + checksum));
}

Future<Uint8List> base58CheckDecode(String b58Str) async {
  var decoded = base58.decode(b58Str);
  int checksumLength = 1;
  if (decoded.length == 1 + 32 + 2) {
    checksumLength = 2;
  }

  var blake2b = Crypto.Blake2b();
  var sink = blake2b.newHashSink();
  var address = decoded.sublist(0, decoded.length - checksumLength);
  var checksum = decoded.sublist(decoded.length - checksumLength);
  sink.add('SS58PRE'.codeUnits + address);
  sink.close();
  for (var i = 0; i < checksumLength; i++) {
    if (checksum[i] != (await sink.hash()).bytes[i]) {
      throw "Base58 checksum error";
    }
  }
  return Uint8List.fromList(address.sublist(1));
}
