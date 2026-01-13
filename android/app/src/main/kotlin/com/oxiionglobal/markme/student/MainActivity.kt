package com.oxiionglobal.markme.student

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // ✅ Required to remove Android 15 edge-to-edge warning
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
