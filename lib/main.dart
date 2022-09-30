import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:developer';

enum AdCashBannerType {
  BANNER_LOADER_320_50("BL32050"),
  BANNER_LOADER_320_100("BL320100"),
  BANNER_LOADER_300_250("BL300250"),
  INTERSTITIAL("INTERSTITIAL");

  final String bannerName;

  const AdCashBannerType(this.bannerName);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ADCash Sample App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 7, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              const Text(
                "BANNER",
                style: TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /** Banner-Loader[320*50], bannerType:BL32050  */
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              Center(
                child: CustomBanner(bannerConnector: "Banner Loader", size: "320*50", bannerType: AdCashBannerType.BANNER_LOADER_320_50.bannerName),
              ),

              /** Banner-Loader[320*100],  bannerType:BL320100  */
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              Center(
                child: CustomBanner(
                  bannerConnector: "Banner Loader",
                  size: "320*100",
                  bannerType: AdCashBannerType.BANNER_LOADER_320_100.bannerName,
                ),
              ),

              /** Banner-Loader[300*250],  bannerType:BL300250  */
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              Center(
                child: CustomBanner(
                  bannerConnector: "Banner Loader",
                  size: "300*250",
                  bannerType: AdCashBannerType.BANNER_LOADER_300_250.bannerName,
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
              const Text(
                "INTERSTITIAL",
                style: TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /** Interstitial 전면 ,  bannerType:INTERSTITIAL  */
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              Center(
                child: CustomBanner(
                  bannerConnector: "Interstitial",
                  size: "전면",
                  bannerType: AdCashBannerType.INTERSTITIAL.bannerName,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBanner extends StatefulWidget {
  const CustomBanner({Key? key, required this.bannerConnector, required this.size, required this.bannerType}) : super(key: key);

  final String bannerConnector;
  final String size;
  final String bannerType;

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  static const platform = MethodChannel('avatye.cashblock.adcash/sample');

  String getBannerPlacementID() {
    if (widget.bannerType == AdCashBannerType.BANNER_LOADER_320_50.bannerName) {
      return "b3c48897-921c-4b25-909f-56e69f2ab275";
    } else if (widget.bannerType == AdCashBannerType.BANNER_LOADER_320_100.bannerName) {
      return "8acac3d7-690b-44bb-8619-638f7e812f99";
    } else if (widget.bannerType == AdCashBannerType.BANNER_LOADER_300_250.bannerName) {
      return "b86a6eaa-ac27-4f7d-8548-db88ca468c5a";
    } else if (widget.bannerType == AdCashBannerType.INTERSTITIAL.bannerName) {
      return "1a29bd86-2f1f-43d9-b649-5064f2fd33b0";
    } else {
      return "";
    }
  }

  Future<void> _loadAdCash() async {
    try {
      await platform.invokeMethod('cashBlock_adcash_load', <String, dynamic>{'placemnetID': getBannerPlacementID(), 'bannerType': widget.bannerType});
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('_MyHomePageState -> _initCashBlock() --> error ${e.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _loadAdCash();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailView(
                      bannerConnector: widget.bannerConnector,
                      size: widget.size,
                      placemnetId: getBannerPlacementID(),
                      bannerType: widget.bannerType,
                    )));
      },
      child: Container(
        color: const Color(0x12345675),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${widget.bannerConnector} [Size:${widget.size}]",
                  style: const TextStyle(
                    fontSize: 15.5,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: TextEditingController(text: getBannerPlacementID()),
                        autofocus: true,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          labelText: '광고 지면을 입력해주세요',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    size: 18,
                    color: Colors.black,
                    Icons.navigate_next,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailView extends StatefulWidget {
  const DetailView({Key? key, required this.bannerConnector, required this.size, required this.placemnetId, required this.bannerType}) : super(key: key);
  final String bannerConnector;
  final String size;
  final String placemnetId;
  final String bannerType;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  double getBannerWidth() {
    if (widget.bannerType == AdCashBannerType.INTERSTITIAL.bannerName) {
      return double.infinity;
    } else if (widget.bannerType == AdCashBannerType.BANNER_LOADER_300_250.bannerName) {
      return 300.0;
    } else {
      return 320.0;
    }
  }

  double getBannerHeight() {
    if (widget.bannerType == AdCashBannerType.BANNER_LOADER_320_50.bannerName) {
      return 50.0;
    } else if (widget.bannerType == AdCashBannerType.BANNER_LOADER_320_100.bannerName) {
      return 100.0;
    } else if (widget.bannerType == AdCashBannerType.BANNER_LOADER_300_250.bannerName) {
      return 250.0;
    } else {
      return 500.0;
    }
  }

  Widget makeBannerWidget() {
    // PlatformView 사용 유무
    if (widget.bannerType == AdCashBannerType.INTERSTITIAL.bannerName) {
      return Container(
        color: const Color(0x12345675),
        width: getBannerWidth(),
        height: getBannerHeight(),
      );
    } else {
      return Container(
        color: const Color(0x12345675),
        width: getBannerWidth(),
        height: getBannerHeight(),
        child: Expanded(
          child: AndroidView(
            viewType: widget.bannerType,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADCash Sample App"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 7, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              Text(
                "${widget.bannerConnector}: ${widget.size}",
                style: const TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              const SizedBox(width: 500, child: Divider(color: Colors.grey, thickness: 1.0)),
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              Text(
                widget.placemnetId,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              Center(
                child: makeBannerWidget(),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
              const SizedBox(width: 500, child: Divider(color: Colors.grey, thickness: 0.2)),
            ],
          ),
        ),
      ),
    );
  }
}
