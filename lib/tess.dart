import 'struct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Centers>> _getCenters() async {
  var data = await http.get(Uri.parse(
      "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=199&date=22-05-2021"));
  var jsonData = json.decode(data.body);
  Autogenerated dec = Autogenerated();
  dec = Autogenerated.fromJson(jsonData);
  List<Centers> freecenters = [];
  List<Centers> paidcenters = [];
  for (int i = 0; i < dec.centers.length; i++) {
    for (int j = 0; j < dec.centers[i].sessions.length; j++) {
      if (dec.centers[i].sessions[j].minAgeLimit == 18 &&
          (dec.centers[i].sessions[j].availableCapacity >= 2 ||
              dec.centers[i].sessions[j].availableCapacityDose1 >= 2)) {
        if (dec.centers[i].feeType == "Paid")
          paidcenters.add(dec.centers[i]);
        else
          freecenters.add(dec.centers[i]);
        break;
      }
    }
  }
  print(freecenters.length);
  print(paidcenters.length);
}

void main() {
  Timer.periodic(Duration(seconds: 1), (timer) {
    _getCenters();
  });
  // // _getCenters();
}
