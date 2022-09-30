package com.example.cashblock_adcash_flutter

import android.app.Activity
import android.util.Log
import android.view.View
import android.widget.Toast
import com.avatye.cashblock.unit.adcash.AdError
import com.avatye.cashblock.unit.adcash.BannerAdSize
import com.avatye.cashblock.unit.adcash.loader.BannerAdLoader
import com.avatye.cashblock.unit.adcash.view.BannerAdView
import io.flutter.plugin.platform.PlatformView

class NativeView(val activity: Activity, val placementId: String?, val bannerAdSize: BannerAdSize, val id: Int, val creationParams: Map<String?, Any?>?) : PlatformView {
    private val bannerAdView: BannerAdView by lazy {
        BannerAdView(activity, null)
    }
    private var bannerAdLoader: BannerAdLoader? = null


    fun setView() {
        // BannerAdLoader
        bannerAdLoader = BannerAdLoader(ownerActivity = activity, placementId = placementId ?: "", bannerAdSize = bannerAdSize, listener = object : BannerAdLoader.BannerListener {
            override fun onLoaded(adView: View, size: BannerAdSize) {

                // 배너 로드 성공
                // 사용자 정의 배너뷰 컨테이너(ViewGroup)
                bannerAdView.removeAllViews()
                bannerAdView.addView(adView)
                Toast.makeText(activity, "Loader::onLoaded", Toast.LENGTH_SHORT).show()
            }

            override fun onFailed(error: AdError) {
                // 로드 실패
                // adError.errorCode : 실패코드
                // adError.errorMessage : 실패사유
                Log.e("asd", "NativeView -> setView -> onFailed -> [ errorCode: ${error.errorCode}, errorMessage: ${error.errorMessage} ]")
                Toast.makeText(activity, "onFailed::${error.errorMessage}", Toast.LENGTH_SHORT).show()
            }

            override fun onClicked() {
                // 배너 클릭 이벤트
                Toast.makeText(activity, "onClicked", Toast.LENGTH_SHORT).show()
            }
        })
        bannerAdLoader?.requestAd()
    }

    override fun getView(): View? {

        return bannerAdView
    }

    override fun dispose() {

    }
}