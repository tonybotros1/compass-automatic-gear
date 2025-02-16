import 'dart:js_interop';
import 'dart:typed_data';

@JS('Uint8Array')
@staticInterop
class JSUint8Array {
  external factory JSUint8Array(JSAny arrayBuffer);
}

extension JSUint8ArrayExtension on JSUint8Array {
  external int get length;
  external int operator [](int index);
}

/// Converts a JavaScript ArrayBuffer (from FileReader.result) into a Dart Uint8List.
Uint8List convertJSArrayBufferToUint8List(JSAny jsArrayBuffer) {
  final jsUint8Array = JSUint8Array(jsArrayBuffer);
  final len = jsUint8Array.length;
  final result = Uint8List(len);
  for (int i = 0; i < len; i++) {
    result[i] = jsUint8Array[i];
  }
  return result;
}
