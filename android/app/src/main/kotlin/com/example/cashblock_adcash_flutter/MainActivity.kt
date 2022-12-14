package com.example.cashblock_adcash_flutter

import android.util.Log
import com.avatye.cashblock.unit.adcash.AdError
import com.avatye.cashblock.unit.adcash.BannerAdSize
import com.avatye.cashblock.unit.adcash.InterstitialAdType
import com.avatye.cashblock.unit.adcash.loader.InterstitialAdLoader
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        const val METHOD_CHANNEL = "avatye.cashblock.adcash/sample"
    }

    private var interstitialAdLoader: InterstitialAdLoader? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {

                "cashBlock_adcash_load" -> {
                    val placemnetID: String? = call.argument("placemnetID")
                    val bannerType: String? = call.argument("bannerType")
                    Log.e("asd", "MainActivity -> configureFlutterEngine -> [ placemnetID: $placemnetID, bannerType: $bannerType ]")


                    if (bannerType == "INTERSTITIAL") {
                        loadInterstitialAd(placementId = placemnetID)
                    } else {
                        flutterEngine.platformViewsController.registry.registerViewFactory(bannerType ?: "", NativeViewFactory(this, placemnetID, getBannerAdSize(bannerType)))
                    }
                }
            }
        }
    }

    private fun loadInterstitialAd(placementId: String?) {
        interstitialAdLoader = InterstitialAdLoader(ownerActivity = activity, placementId = placementId ?: "", listener = object : InterstitialAdLoader.InterstitialListener {
            override fun onLoaded(executor: InterstitialAdLoader.InterstitialExecutor, adType: InterstitialAdType) {
                // interstitialExecutor??? show() ????????? ?????? ????????? ?????? ?????????.
                executor.show()
            }

            override fun onOpened() {
                // ?????? ?????? ??????
            }

            override fun onClosed(completed: Boolean) {
                // ?????? ??????
                // completed: ????????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ??????
            }

            override fun onFailed(error: AdError) {
                // ?????? ??????
            }

            override fun onClicked() {
                // ?????? ??????
            }
        }).apply { requestAd() }
    }


    private fun getBannerAdSize(bannerType: String?): BannerAdSize {
        return when (bannerType) {
            "BL32050" -> BannerAdSize.W320XH50
            "BL320100" -> BannerAdSize.W320XH100
            "BL300250" -> BannerAdSize.W300XH250
            else -> BannerAdSize.W320XH50
        }
    }
}
