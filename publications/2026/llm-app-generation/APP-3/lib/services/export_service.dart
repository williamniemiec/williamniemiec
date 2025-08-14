import 'dart:io';

import 'package:apex_altimeter/models/session.dart';
import 'package:csv/csv.dart';
import 'package:gpx/gpx.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  Future<String> exportToGpx(
      Session session, List<Map<String, dynamic>> data) async {
    final gpx = Gpx();
    gpx.version = '1.1';
    gpx.creator = 'Apex Altimeter';
    gpx.wpts = data
        .where((d) => d.containsKey('latitude'))
        .map((d) => Wpt(
              lat: d['latitude'],
              lon: d['longitude'],
              ele: d['altitude'],
              time: DateTime.parse(d['timestamp']),
            ))
        .toList();

    final xml = GpxWriter().asString(gpx, pretty: true);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${session.name}.gpx');
    await file.writeAsString(xml);
    return file.path;
  }

  Future<String> exportToCsv(
      Session session, List<Map<String, dynamic>> data) async {
    final List<List<dynamic>> rows = [];
    rows.add(data.first.keys.toList());
    for (final row in data) {
      rows.add(row.values.toList());
    }

    final csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${session.name}.csv');
    await file.writeAsString(csv);
    return file.path;
  }
}