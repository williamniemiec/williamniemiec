import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_tag_commander/utils/record_info.dart';

class RecordParser {
  static RecordInfo parse(NdefRecord record) {
    final type = String.fromCharCodes(record.type);
    if (record.typeNameFormat == NdefTypeNameFormat.values[1] && type == 'U') {
      final uri = _parseUri(record.payload);
      return RecordInfo(title: 'URL', subtitle: uri.toString());
    }
    if (record.typeNameFormat == NdefTypeNameFormat.values[1] && type == 'T') {
      final languageCodeLength = record.payload[0];
      final text = String.fromCharCodes(record.payload.sublist(languageCodeLength + 1));
      return RecordInfo(title: 'Text', subtitle: text);
    }
    if (record.typeNameFormat == NdefTypeNameFormat.nfcExternal) {
      final payload = String.fromCharCodes(record.payload);
      if (payload.startsWith('WIFI:')) {
        return RecordInfo(title: 'Wi-Fi');
      }
    }
    if (record.typeNameFormat == NdefTypeNameFormat.media) {
      final mimeType = String.fromCharCodes(record.type);
      if (mimeType == 'text/vcard') {
        return RecordInfo(title: 'Contact');
      }
    }
    return RecordInfo(title: 'Unknown Record');
  }

  static Uri _parseUri(List<int> payload) {
    final prefixCode = payload.first;
    final prefix = _uriPrefixes[prefixCode] ?? '';
    final url = '$prefix${String.fromCharCodes(payload.sublist(1))}';
    return Uri.parse(url);
  }

  static const _uriPrefixes = {
    0x01: 'http://www.',
    0x02: 'https://www.',
    0x03: 'http://',
    0x04: 'https://',
    0x05: 'tel:',
    0x06: 'mailto:',
    0x07: 'ftp://anonymous:anonymous@',
    0x08: 'ftp://ftp.',
    0x09: 'ftps://',
    0x0A: 'sftp://',
    0x0B: 'smb://',
    0x0C: 'nfs://',
    0x0D: 'ftp://',
    0x0E: 'dav://',
    0x0F: 'news:',
    0x10: 'telnet://',
    0x11: 'imap:',
    0x12: 'rtsp://',
    0x13: 'urn:',
    0x14: 'pop:',
    0x15: 'sip:',
    0x16: 'sips:',
    0x17: 'tftp:',
    0x18: 'btspp://',
    0x19: 'btl2cap://',
    0x1A: 'btgoep://',
    0x1B: 'tcpobex://',
    0x1C: 'irdaobex://',
    0x1D: 'file://',
    0x1E: 'urn:epc:id:',
    0x1F: 'urn:epc:tag:',
    0x20: 'urn:epc:pat:',
    0x21: 'urn:epc:raw:',
    0x22: 'urn:epc:',
    0x23: 'urn:nfc:',
  };
}