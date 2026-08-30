package com.example.rituals

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.provider.AlarmClock
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

/**
 * Hands alarms to whichever clock app the device uses, via the public
 * `AlarmClock.ACTION_SET_ALARM` intent.
 *
 * There is no companion API for listing or cancelling an alarm created this
 * way, so this bridge only ever creates them.
 */
class AlarmBridge(private val activity: Activity) {

    companion object {
        const val CHANNEL = "com.example.rituals/alarm"

        private val EVERY_DAY = arrayListOf(
            Calendar.MONDAY,
            Calendar.TUESDAY,
            Calendar.WEDNESDAY,
            Calendar.THURSDAY,
            Calendar.FRIDAY,
            Calendar.SATURDAY,
            Calendar.SUNDAY,
        )
    }

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setAlarm" -> setAlarm(call, result)
            else -> result.notImplemented()
        }
    }

    private fun setAlarm(call: MethodCall, result: MethodChannel.Result) {
        val hour = call.argument<Int>("hour")
        val minute = call.argument<Int>("minute")
        if (hour == null || minute == null) {
            result.error("INVALID_TIME", "hour and minute are required", null)
            return
        }

        val label = call.argument<String>("label").orEmpty()
        val daily = call.argument<Boolean>("daily") ?: false

        val intent = Intent(AlarmClock.ACTION_SET_ALARM).apply {
            putExtra(AlarmClock.EXTRA_HOUR, hour)
            putExtra(AlarmClock.EXTRA_MINUTES, minute)
            putExtra(AlarmClock.EXTRA_MESSAGE, label)
            // Set it without pulling the user out into the clock app.
            putExtra(AlarmClock.EXTRA_SKIP_UI, true)
            if (daily) {
                putExtra(AlarmClock.EXTRA_DAYS, EVERY_DAY)
            }
        }

        // resolveActivity needs the <queries> entry in AndroidManifest.xml to
        // see the clock app on Android 11+.
        if (intent.resolveActivity(activity.packageManager) == null) {
            result.success(false)
            return
        }

        try {
            activity.startActivity(intent)
            result.success(true)
        } catch (e: ActivityNotFoundException) {
            result.success(false)
        } catch (e: SecurityException) {
            result.error("PERMISSION_DENIED", e.message, null)
        }
    }
}
