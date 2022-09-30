package com.example.cashblock_adcash_flutter

import android.app.Activity
import android.content.Context
import com.avatye.cashblock.unit.adcash.BannerAdSize
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(val activity: Activity, val placementId: String?, val bannerAdSize: BannerAdSize) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return NativeView(
            activity = activity, placementId = placementId, bannerAdSize = bannerAdSize, id = viewId, creationParams = creationParams
        ).apply {
            setView()
        }
    }
}