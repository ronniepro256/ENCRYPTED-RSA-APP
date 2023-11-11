import 'package:flutter/material.dart';

void main() async {
  runApp(EncryptedApp());
}

class EncryptedApp extends StatelessWidget {
  const EncryptedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Encrypted Chat",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController prime1Controller = TextEditingController();
  TextEditingController prime2Controller = TextEditingController();
  String encryptedMessage = "";

  String decryptedMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encryption App"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: "Enter your message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
            SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: prime1Controller,
                  decoration: InputDecoration(
                    labelText: "Enter first prime number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )),
                SizedBox(width: 16.0),
                Expanded(
                    child: TextField(
                  controller: prime2Controller,
                  decoration: InputDecoration(
                    labelText: "Enter second prime number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: encryptMessage,
              child: Text("ENCRYPT"),
            ),
            SizedBox(
              height: 16.0,
              width: 10.0,
            ),
            Text("Message: $encryptedMessage"),
            SizedBox(
              height: 16.0,
              width: 10.0,
            ),
            ElevatedButton(
              onPressed: decryptMessage,
              child: Text("DECRYPT"),
            ),
            SizedBox(height: 16.0),
            Text("Original Message: $decryptedMessage"),
          ],
        ),
      ),
    );
  }

  void encryptMessage() {
    String message = messageController.text;
    int prime1 = int.parse(prime1Controller.text);
    int prime2 = int.parse(prime2Controller.text);

    int n = prime1 * prime2;
    int phi = (prime1 - 1) * (prime2 - 1);
    int e = calculateE(phi);
    int d = calculateD(e, phi);

    String encrypted = rsaEncrypt(message, e, n);

    setState(() {
      encryptedMessage = encrypted;
    });
  }

  void decryptMessage() {
    String encrypted = encryptedMessage;
    int prime1 = int.parse(prime1Controller.text);
    int prime2 = int.parse(prime2Controller.text);

    int n = prime1 * prime2;
    int phi = (prime1 - 1) * (prime2 - 1);
    int e = calculateE(phi);
    int d = calculateD(e, phi);

    String decrypted = rsaDecrypt(encrypted, d, n);

    setState(() {
      decryptedMessage = decrypted;
    });
  }

  int calculateE(int phi) {
    int e = 2;
    while (e < phi) {
      if (gcd(e, phi) == 1) {
        return e;
      }
      e++;
    }
    return 0;
  }

  int calculateD(int e, int phi) {
    int d = 2;
    while ((d * e) % phi != 1) {
      d++;
    }
    return d;
  }

  int gcd(int a, int b) {
    if (b == 0) {
      return a;
    }
    return gcd(b, a % b);
  }

  String rsaEncrypt(String message, int e, int n) {
    String encrypted = "";
    for (int i = 0; i < message.length; i++) {
      int charCode = message.codeUnitAt(i);
      int encryptedCharCode = modPow(charCode, e, n);
      encrypted += String.fromCharCode(encryptedCharCode);
    }
    return encrypted;
  }

  String rsaDecrypt(String encrypted, int d, int n) {
    String decrypted = "";
    for (int i = 0; i < encrypted.length; i++) {
      int charCode = encrypted.codeUnitAt(i);
      int decryptedCharCode = modPow(charCode, d, n);
      decrypted += String.fromCharCode(decryptedCharCode);
    }
    return decrypted;
  }

  int modPow(int base, int exponent, int modulus) {
    if (exponent == 0) {
      return 1;
    }
    int result = 1;
    base = base % modulus;
    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result = (result * base) % modulus;
      }
      exponent = exponent >> 1;
      base = (base * base) % modulus;
    }
    return result;
  }
}
