
import 'dart:convert';
import 'dart:js' as js;
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:js_util' as js_util; // Import dart:js_util
import 'dart:html' as html;
import 'package:http/http.dart' as http;


class ServiceIP{



String? getUserAgent() {
  dynamic userAgent = html.window.navigator.userAgent;
  return userAgent;
}

String? getDevicePlatform(){
  dynamic devicePlatform  = html.window.navigator.platform;
  return devicePlatform;
}



Future<String?> _getLocalIpWithWebRTC() async {
  try {
    // Use eval to run the WebRTC JavaScript logic
    final promise = js.context.callMethod('eval', [
      """
      (function() {
        return new Promise((resolve, reject) => {
          const rtc = new RTCPeerConnection({iceServers:[]});
          rtc.createDataChannel('');
          rtc.createOffer()
            .then((offer) => rtc.setLocalDescription(offer))
            .catch((err) => reject(err));

          rtc.onicecandidate = (event) => {
            if (event && event.candidate && event.candidate.candidate) {
              const candidate = event.candidate.candidate;
              const ipMatch = candidate.match(/([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3})/);
              if (ipMatch) {
                resolve(ipMatch[1]);
              }
            }
          };
        });
      })();
      """
    ]);

    // Convert the JavaScript Promise to a Dart Future and await its result
    final localIp = await js_util.promiseToFuture(promise);
    debugPrint('_getLocalIpWithWebRTC: $localIp');
    return localIp.toString();
  } catch (e) {
    debugPrint('Error retrieving local IP address with WebRTC: $e');
    return null;
  }
}



  Future<String?> getIpAddress() async {
  if (kIsWeb) {
    // For Flutter Web
    return await _getWebIpAddress();
  } else {
    // For Other Platforms
    return await _getLocalIpAddress();
  }
}

Future<String?> _getWebIpAddress() async {
  try {
    final localIp = js.context.callMethod('eval', [
      "(function() { return window.location.hostname; })()"
    ]);
    debugPrint('_getWebIpAddress $localIp');
    return localIp;
  } catch (e) {
    debugPrint('Error retrieving local IP address: $e');
    return null;
  }

}

 Future<String?> _getLocalIpAddress() async {
  try {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLinkLocal: false,
    );

    for (var interface in interfaces) {
      for (var address in interface.addresses) {
        // Return the first non-loopback IPv4 address
        if (!address.isLoopback) {
          debugPrint('getIpAddress (Local): ${address.address}');
          return address.address;
        }
      }
    }
  } catch (e) {
    debugPrint('Error retrieving local IP address: $e');
  }
  return null; // Return null if no address found
  }


  Future<dynamic> getPublicIp() async {
  var response = await http.get(Uri.parse('https://api.ipify.org?format=json'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    debugPrint("Public IP: ${data['ip']}");
    return data['ip'];
  } else {
    debugPrint("Failed to get IP");
  }
}
}
