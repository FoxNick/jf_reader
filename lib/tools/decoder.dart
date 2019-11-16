import 'package:fast_gbk/fast_gbk.dart';
import 'dart:typed_data';
import 'dart:convert';
String tryDecodeListData(List<int> listData){
  Uint32List list = Uint32List.fromList(listData);
  ByteBuffer buffer = list.buffer;
  ByteData data = ByteData.view(buffer);
  return tryDecode(data);
}
String tryDecode(ByteData data){
  List<Encoding> codecs = [utf8,gbk];
  for (var codec in codecs) {
    String content = _decode(data,codec);
    if(content != null){
      return content;
    }
  }
  return null;
}
String _decode(ByteData data,Encoding codec){
  try {
    return codec.decode(data.buffer.asUint8List());
  } catch (e) {
    return null;
  }
}