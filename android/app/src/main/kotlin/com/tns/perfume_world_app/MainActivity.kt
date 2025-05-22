package com.tns.perfume_world_app

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.text.Layout
import android.util.Log
import androidx.lifecycle.lifecycleScope
import com.zcs.sdk.DriverManager
import com.zcs.sdk.Printer
import com.zcs.sdk.SdkResult
import com.zcs.sdk.Sys
import com.zcs.sdk.print.PrnStrFormat
import com.zcs.sdk.print.PrnTextFont
import com.zcs.sdk.print.PrnTextStyle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date

class MainActivity : FlutterActivity() {
    private val CHANNEL = "ZCSPOSSDK"
    private val mDriverManager: DriverManager = DriverManager.getInstance()
    private val mSys: Sys = mDriverManager.getBaseSysDevice()
    private val mPrinter: Printer = mDriverManager.getPrinter()
    private var isSdkInitialized = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeSdk" -> {
                    val success = initializeSdk()
                    result.success(success)
                }
                "printInvoice" -> {
                    val success = printInvoice(call.arguments as Map<String, Any>)
                    result.success(success)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun initializeSdk(): Boolean {
        try {
            var status: Int = mSys.sdkInit()
            if (status != SdkResult.SDK_OK) {
                mSys.sysPowerOn()
                Thread.sleep(1000)
                status = mSys.sdkInit()
                if (status != SdkResult.SDK_OK) {
                    Log.e("SDK Initialization", "Failed to initialize SDK: status=$status")
                    return false
                }
            }
            isSdkInitialized = true
            return true
        } catch (e: Exception) {
            Log.e("SDK Initialization", "Failed to initialize SDK", e)
            return false
        }
    }

    private fun printInvoice(data: Map<String, Any>): String {
        try {
            Log.d("Print Data", data.toString())
            val printStatus: Int = mPrinter.getPrinterStatus()
            if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                Log.e("Invoice Printing", "Printer out of paper")
                return "paper_out"
            }
            val format = PrnStrFormat()
            format.setTextSize(24) // Normal font size
            format.setStyle(PrnTextStyle.NORMAL)
            format.setFont(PrnTextFont.DEFAULT)

            // Mushak and BIN
            format.setAli(Layout.Alignment.ALIGN_CENTER)
            mPrinter.setPrintAppendString("Mushak - 6.3", format)
            mPrinter.setPrintAppendString("", format) // Space


            // In printInvoice function
            // Load and print logo
            val imagePath = data["imagePath"]?.toString()
            if (!imagePath.isNullOrEmpty()) {
                try {
                    Log.d("Invoice Printing", "Loading logo from path: $imagePath")
                    val assetPath = imagePath.replace("assets/", "flutter_assets/assets/images/")
                    Log.d("Invoice Printing", "Asset path: $assetPath")
                    val inputStream = try {
                        assets.open(assetPath)
                    } catch (e: Exception) {
                        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                            .invokeMethod("showError", "Failed to open logo asset: $assetPath")
                        null
                    }
                    if (inputStream == null) {
                        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                            .invokeMethod("showError", "Input stream is null for logo: $assetPath")
                    } else {
                        val bitmap = BitmapFactory.decodeStream(inputStream)
                        inputStream.close()
                        if (bitmap == null) {
                            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                                .invokeMethod("showError", "Failed to decode logo bitmap: $assetPath")
                        } else {
                            // Resize bitmap to fit printer width (e.g., 384px for 58mm printer)
                            val printerWidth = 384
                            val scaledBitmap = if (bitmap.width > printerWidth) {
                                Bitmap.createScaledBitmap(bitmap, printerWidth, (bitmap.height * printerWidth / bitmap.width), true)
                            } else {
                                bitmap
                            }
                            mPrinter.setPrintAppendBitmap(scaledBitmap, Layout.Alignment.ALIGN_CENTER)
                            Log.d("Invoice Printing", "Logo printed successfully: ${scaledBitmap.width}x${scaledBitmap.height}")
                            bitmap.recycle()
                            if (scaledBitmap != bitmap) scaledBitmap.recycle()
                        }
                    }
                } catch (e: Exception) {
                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                        .invokeMethod("showError", "Failed to load or print logo: $imagePath")
                }
            } else {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "No imagePath provided in print data")
            }

            // Store Name
            format.setTextSize(48) // 2x normal size
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("PERFUME WORLD", format)

            // Address
            format.setTextSize(24)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString("Chadiwala mansion, House #32(1st Floor),", format)
            mPrinter.setPrintAppendString("Block #G, Road #11, Banani, Dhaka-1213", format)
            mPrinter.setPrintAppendString("Mobile: 01781474070", format)
            mPrinter.setPrintAppendString("", format) // Space

            // Date & Invoice Info
            format.setAli(Layout.Alignment.ALIGN_NORMAL)
            mPrinter.setPrintAppendString(
                "Date & Time: ${SimpleDateFormat("MM/dd/yyyy HH:mm").format(Date())}",
                format
            )
            mPrinter.setPrintAppendString("Invoice No.: ${data["invoiceNumber"]}", format)
            mPrinter.setPrintAppendString("Customer Name: ${data["customerName"] ?: "No customer"}", format)
            mPrinter.setPrintAppendString("Customer Mobile: ${data["customerPhone"] ?: ""}", format)
            mPrinter.setPrintAppendString("", format) // Space

            // Items Table Header
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("------------------------------------", format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString("Items        Qty    Rate    Amount", format)
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("------------------------------------", format)

            // Items
            format.setStyle(PrnTextStyle.NORMAL)
            val items = data["cartItems"] as List<Map<String, Any>>
            var subTotal = 0.0
            items.forEach { item ->
                val name = item["productName"].toString()
                val qty = item["quantity"].toString().toIntOrNull() ?: 0
                val price = item["price"].toString().toDoubleOrNull() ?: 0.0
                val discount = item["discount"].toString().toDoubleOrNull() ?: 0.0
                val amount = (price * qty - discount)

                // Handle long item names
                val maxNameLength = 12 // Adjust based on printer width
                if (name.length > maxNameLength) {
                    val chunks = name.chunked(maxNameLength)
                    chunks.forEachIndexed { index, chunk ->
                        if (index == 0) {
                            mPrinter.setPrintAppendString(
                                String.format("%-12s %3d %7.2f %8.2f", chunk, qty, price, amount),
                                format
                            )
                        } else {
                            mPrinter.setPrintAppendString(chunk, format)
                        }
                    }
                } else {
                    mPrinter.setPrintAppendString(
                        String.format("%-12s %3d %7.2f %8.2f", name, qty, price, amount),
                        format
                    )
                }
                subTotal += amount
            }

            // Totals
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("------------------------------------", format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString(
                String.format("%-24s %7.2f", "Sub Total", subTotal),
                format
            )
            mPrinter.setPrintAppendString("------------------------------------", format)

            // Discounts and VAT
            val invoiceDiscount = data["invoiceDiscount"]?.toString()?.toDoubleOrNull() ?: 0.0
            val vat = data["vat"]?.toString()?.toDoubleOrNull() ?: 0.0
            val shipping = data["shipping"]?.toString()?.toDoubleOrNull() ?: 0.0
            val vatAmount = subTotal * (vat / 100)
            val discountAmount = subTotal * (invoiceDiscount / 100)
            val netAmount = subTotal + vatAmount - discountAmount + shipping
            val paidAmount = data["collectedAmount"]?.toString()?.toDoubleOrNull() ?: 0.0
            val changeAmount = paidAmount - netAmount

            mPrinter.setPrintAppendString(
                String.format("%-24s %7.2f", "Discount", discountAmount),
                format
            )
            mPrinter.setPrintAppendString(
                String.format("%-24s %7.2f", "Return Discount Amount (-)", 0.0),
                format
            )
            mPrinter.setPrintAppendString(
                String.format("%-24s %7.2f", "Vat 7.5% (Inclusive)", vatAmount),
                format
            )
            mPrinter.setPrintAppendString(
                String.format("%-24s %7.2f", "Special Discount", discountAmount),
                format
            )
            mPrinter.setPrintAppendString(
                String.format("%-24s %7.2f", "Redeem 0.000 Point Value", 0.0),
                format
            )
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("------------------------------------", format)
            mPrinter.setPrintAppendString(
                String.format("%-24s %7.2f", "Net Amount", netAmount),
                format
            )
            mPrinter.setPrintAppendString("------------------------------------", format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString(
                String.format("%-24s %7.2f", "Paid Amount", paidAmount),
                format
            )
            mPrinter.setPrintAppendString(
                String.format("%-24s %7.2f", "Change Amount", changeAmount),
                format
            )
            mPrinter.setPrintAppendString("", format) // Space

            // Payment Info
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("Payment Info:", format)
            mPrinter.setPrintAppendString("----------------------", format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString("Description          Amount", format)
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("------------------------------------", format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString(
                String.format("%-20s %7.2f", data["paymentMethodName"]?.toString() ?: "N/A", netAmount),
                format
            )
            mPrinter.setPrintAppendString("", format) // Space

            // Taka in Words
            val takaInWords = numberToWords(netAmount.toLong())
            mPrinter.setPrintAppendString("Taka in Word: TK. $takaInWords", format)
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space

            val printStatusResult = mPrinter.setPrintStart()
            if (printStatusResult == SdkResult.SDK_OK) {
                lifecycleScope.launch {
                    delay(500)
                    cutPaper()
                }
                return "true"
            }
            Log.e("Invoice Printing", "Print start failed: $printStatusResult")
            return "false"
        } catch (e: Exception) {
            Log.e("Invoice Printing", "Failed to print invoice", e)
            return "false"
        }
    }

    private fun cutPaper() {
        try {
            val printStatus = mPrinter.getPrinterStatus()
            if (printStatus == SdkResult.SDK_OK) {
                mPrinter.openPrnCutter(1.toByte())
            } else {
                Log.e("Cut Paper", "Printer status not OK: $printStatus")
            }
        } catch (e: Exception) {
            Log.e("Cut Paper", "Failed to cut paper", e)
        }
    }

    private fun numberToWords(number: Long): String {
        if (number == 0L) return "Zero"
        val units = arrayOf("", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine")
        val teens = arrayOf("Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen")
        val tens = arrayOf("", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety")
        val thousands = arrayOf("", "Thousand", "Million", "Billion")

        fun convertLessThanThousand(n: Int): String {
            if (n == 0) return ""
            return when {
                n < 10 -> units[n]
                n < 20 -> teens[n - 10]
                n < 100 -> "${tens[n / 10]} ${units[n % 10]}".trim()
                else -> "${units[n / 100]} Hundred ${convertLessThanThousand(n % 100)}".trim()
            }
        }

        val parts = mutableListOf<String>()
        var num = number
        var thousandIndex = 0
        while (num > 0) {
            val part = (num % 1000).toInt()
            if (part > 0) {
                val partText = convertLessThanThousand(part)
                parts.add(0, if (thousands[thousandIndex].isEmpty()) partText else "$partText ${thousands[thousandIndex]}")
            }
            num /= 1000
            thousandIndex++
        }
        return parts.joinToString(" ").trim()
    }
}