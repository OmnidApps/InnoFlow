package com.omnidapps.innoflow

// TODO: move to a dedicated plugin file

import android.content.ContentResolver
import android.database.Cursor
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.omnidapps.innoflow/workflows"
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getWorkflows" -> {
                    GlobalScope.launch(Dispatchers.IO) {
                        val workflows = getAutomateWorkflows()
                        launch(Dispatchers.Main) {
                            channel.invokeMethod("updateWorkflows", workflows)
                            result.success(null)
                        }
                    }
                }
                "executeWorkflow" -> {
                    val workflowId = call.argument<String>("id")
                    // Here you would create an Intent to execute the workflow in Automate
                    val intent = Intent("com.llamalab.automate.intent.action.EXECUTE_FLOW")
                    intent.putExtra("com.llamalab.automate.intent.extra.FLOW_ID", workflowId)
                    startActivity(intent)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getAutomateWorkflows(): String {
        val contentUri = Uri.parse("content://com.llamalab.automate.provider/flows")
        val projection = arrayOf("_id", "name", "description")
        val jsonArray = JSONArray()

        contentResolver.query(contentUri, projection, null, null, null)?.use { cursor ->
            while (cursor.moveToNext()) {
                jsonArray.put(JSONObject().apply {
                    put("id", cursor.getString(cursor.getColumnIndexOrThrow("_id")))
                    put("name", cursor.getString(cursor.getColumnIndexOrThrow("name")))
                    put("description", cursor.getString(cursor.getColumnIndexOrThrow("description")))
                    put("category", "Automate")
                })
            }
        }

        return jsonArray.toString()
    }
}