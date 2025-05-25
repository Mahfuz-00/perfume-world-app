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
                "showError" -> {
                    result.success(null)
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
                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                        .invokeMethod("showError", "Failed to initialize SDK: status=$status")
                    return false
                }
            }
            isSdkInitialized = true
            return true
        } catch (e: Exception) {
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                .invokeMethod("showError", "Failed to initialize SDK: ${e.message ?: "Unknown error"}")
            return false
        }
    }

    private fun printInvoice(data: Map<String, Any>): String {
        try {
            Log.d("Print Data", data.toString())
            val printStatus: Int = mPrinter.getPrinterStatus()
            if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "Printer out of paper")
                return "paper_out"
            }
            if (printStatus != SdkResult.SDK_OK) {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "Printer status error: $printStatus")
                return "printer_error"
            }
            val format = PrnStrFormat()
            format.setTextSize(19) // Normal font size
            format.setStyle(PrnTextStyle.NORMAL)
            format.setFont(PrnTextFont.DEFAULT)

            // Mushak - 6.3
            format.setAli(Layout.Alignment.ALIGN_CENTER)
            mPrinter.setPrintAppendString("Mushak - 6.3", format)
            // BIN
            mPrinter.setPrintAppendString("BIN: 000375101-0101 Central", format)
            mPrinter.setPrintAppendString("", format) // Space

            // Load and print logo (100x100)
            try {
                Log.d("Invoice Printing", "Loading logo from drawable resource")
                var bitmap: Bitmap? = null
                for (attempt in 1..3) {
                    try {
                        bitmap = BitmapFactory.decodeResource(resources, R.drawable.tns_logo_4x)
                        break
                    } catch (e: Exception) {
                        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                            .invokeMethod("showError", "Attempt $attempt failed to decode logo resource: ${e.message ?: "Unknown error"}")
                        if (attempt < 3) {
                            Thread.sleep(500)
                            continue
                        }
                        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                            .invokeMethod("showError", "Failed to decode logo resource")
                    }
                }
                if (bitmap == null) {
                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                        .invokeMethod("showError", "Logo bitmap is null")
                } else {
                    Log.d("Invoice Printing", "Bitmap decoded: ${bitmap.width}x${bitmap.height}, byteCount: ${bitmap.byteCount}")
                    // Resize to exactly 100x100 pixels
                    val scaledBitmap = Bitmap.createScaledBitmap(bitmap, 100, 100, true)
                    mPrinter.setPrintAppendBitmap(scaledBitmap, Layout.Alignment.ALIGN_CENTER)
                    Log.d("Invoice Printing", "Logo printed: ${scaledBitmap.width}x${scaledBitmap.height}")
                    bitmap.recycle()
                    if (scaledBitmap != bitmap) scaledBitmap.recycle()
                }
            } catch (e: Exception) {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "Failed to load or print logo: ${e.message ?: "Unknown error"}")
            }
            mPrinter.setPrintAppendString("", format) // Space

            // PERFUME WORLD
            format.setTextSize(25) // Bold title
            format.setStyle(PrnTextStyle.BOLD)
            format.setAli(Layout.Alignment.ALIGN_CENTER)
            mPrinter.setPrintAppendString("PERFUME WORLD", format)

            // Address
            format.setTextSize(19)
            format.setStyle(PrnTextStyle.NORMAL)
            // Wrap address to 63 chars
            val addressLines = listOf(
                "Chadiwala mansion, House #32(1st Floor),",
                "Block #G, Road #11, Banani, Dhaka-1213",
                "Mobile: 01781474070"
            )
            addressLines.forEach { line ->
                line.chunked(63).forEach { chunk ->
                    mPrinter.setPrintAppendString(chunk, format)
                }
            }
            mPrinter.setPrintAppendString("", format) // Space

            // Date & Invoice Info
            format.setAli(Layout.Alignment.ALIGN_NORMAL)
            val infoLines = listOf(
                "Date & Time: ${SimpleDateFormat("MM/dd/yyyy HH:mm").format(Date())}",
                "Invoice No.: ${data["invoiceNumber"] ?: "N/A"}",
                "Customer Name: ${data["customerName"] ?: "No customer"}",
                "Customer Mobile: ${data["customerPhone"] ?: ""}"
            )
            infoLines.forEach { line ->
                line.chunked(63).forEach { chunk ->
                    mPrinter.setPrintAppendString(chunk, format)
                }
            }
            mPrinter.setPrintAppendString("", format) // Space

            // Items Table Header
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("-".repeat(63), format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString(
                String.format("%-35s %-8s %-16s %-12s", "Items", "Qty", "Rate", "Amount"),
                format
            )
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("-".repeat(63), format)


            // Helper function to split a number string into chunks of max 8 chars
            fun splitNumber(value: Double, maxLength: Int = 8): List<String> {
                val formatted = String.format("%.2f", value)
                if (formatted.length <= maxLength) return listOf(formatted)
                return formatted.chunked(maxLength)
            }

            // Items
            format.setStyle(PrnTextStyle.NORMAL)
            val items = try {
                data["cartItems"] as List<Map<String, Any>>
            } catch (e: Exception) {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "Invalid cartItems data: ${e.message ?: "Unknown error"}")
                return "data_error"
            }
            var subTotal = 0.0
            items.forEachIndexed { index, item ->
                try {
                    val name = item["productName"].toString()
                    val qty = item["quantity"].toString().toIntOrNull() ?: 0
                    val price = item["price"].toString().toDoubleOrNull() ?: 0.0
                    val discount = item["discount"].toString().toDoubleOrNull() ?: 0.0
                    val amount = (price * qty - discount)

                    // Split name, rate, and amount if they exceed max lengths
                    val maxNameLength = 19
                    val nameChunks = name.chunked(maxNameLength)
                    val rateChunks = splitNumber(price, 8)
                    val amountChunks = splitNumber(amount, 8)

                    // Find the maximum number of chunks needed
                    val maxChunks = maxOf(nameChunks.size, rateChunks.size, amountChunks.size)


                    // Print rows for each chunk
                    for (chunkIndex in 0 until maxChunks) {
                        val nameChunk = if (chunkIndex < nameChunks.size) nameChunks[chunkIndex] else ""
                        val qtyValue = if (chunkIndex == 0) qty else ""
                        val rateChunk = if (chunkIndex < rateChunks.size) rateChunks[chunkIndex] else ""
                        val amountChunk = if (chunkIndex < amountChunks.size) amountChunks[chunkIndex] else ""

                        mPrinter.setPrintAppendString(
                            String.format("%-15s %-5s %-12s %-12s", nameChunk, qtyValue, rateChunk, amountChunk),
                            format
                        )
                    }
                    subTotal += amount
                } catch (e: Exception) {
                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                        .invokeMethod("showError", "Error processing item at index $index: ${e.message ?: "Unknown error"}")
                    return "data_error"
                }
            }

            // Totals
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("-".repeat(63), format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString(
                String.format("%-66s %8.2f", "Sub Total".take(63), subTotal),
                format
            )
            mPrinter.setPrintAppendString("-".repeat(63), format)

            // Discounts and VAT
            val invoiceDiscount = try {
                data["invoiceDiscount"]?.toString()?.toDoubleOrNull() ?: 0.0
            } catch (e: Exception) {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "Invalid invoiceDiscount value: ${e.message ?: "Unknown error"}")
                return "data_error"
            }
            val shipping = try {
                data["shipping"]?.toString()?.toDoubleOrNull() ?: 0.0
            } catch (e: Exception) {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "Invalid shipping value: ${e.message ?: "Unknown error"}")
                return "data_error"
            }
            val vatAmount = subTotal * 0.075 // VAT = 7.5%
            val discountAmount = subTotal * (invoiceDiscount / 100)
            val netAmount = subTotal + vatAmount - discountAmount + shipping
            val paidAmount = try {
                data["collectedAmount"]?.toString()?.toDoubleOrNull() ?: 0.0
            } catch (e: Exception) {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "Invalid collectedAmount value: ${e.message ?: "Unknown error"}")
                return "data_error"
            }
            val dueAmount = if (netAmount > paidAmount) netAmount - paidAmount else 0.0
            val changeAmount = if (netAmount <= paidAmount) paidAmount - netAmount else 0.0

            mPrinter.setPrintAppendString(
                String.format("%-66s %8.2f", "Discount".take(63), discountAmount),
                format
            )
            mPrinter.setPrintAppendString(
                String.format("%-49s %8.2f", "Return Discount Amount (-)".take(63), 0.0),
                format
            )
            mPrinter.setPrintAppendString(
                String.format("%-58s %8.2f", "Vat 7.5% (Inclusive)".take(63), vatAmount),
                format
            )
            mPrinter.setPrintAppendString(
                String.format("%-59s %8.2f", "Special Discount".take(63), discountAmount),
                format
            )
            mPrinter.setPrintAppendString(
                String.format("%-48s %8.2f", "Redeem 0.000 Point Value".take(63), 0.0),
                format
            )
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("-".repeat(63), format)
            mPrinter.setPrintAppendString(
                String.format("%-60s %8.2f", "Net Amount".take(63), netAmount),
                format
            )
            mPrinter.setPrintAppendString("-".repeat(63), format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString(
                String.format("%-60s %8.2f", "Paid Amount".take(63), paidAmount),
                format
            )
            val amountLine = if (dueAmount > 0.0) {
                String.format("%-60s %8.2f", "Due Amount", dueAmount)
            } else {
                String.format("%-56s %8.2f", "Change Amount", changeAmount)
            }
            Log.d("Invoice Printing", "Amount Line: '$amountLine', Length: ${amountLine.length}")
            mPrinter.setPrintAppendString(amountLine, format)
            mPrinter.setPrintAppendString("", format) // Space

            // Payment Info
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("Payment Info:", format)
            mPrinter.setPrintAppendString("-".repeat(24), format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString(
                String.format("%-40s %8s", "Description", "Amount"),
                format
            )
            format.setStyle(PrnTextStyle.BOLD)
            mPrinter.setPrintAppendString("-".repeat(63), format)
            format.setStyle(PrnTextStyle.NORMAL)
            mPrinter.setPrintAppendString(
                String.format("%-47s %8.2f", (data["paymentMethodName"]?.toString() ?: "N/A").take(30), netAmount),
                format
            )
            mPrinter.setPrintAppendString("", format) // Space

            // Taka in Words
            val takaInWords = numberToWords(netAmount.toLong()).take(100)
            val takaLine = "Taka in Word: $takaInWords Taka Only"
            Log.d("Invoice Printing", "Taka Line: '$takaLine', Length: ${takaLine.length}")
            takaLine.chunked(63).forEach { chunk ->
                mPrinter.setPrintAppendString(chunk, format)
            }
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            format.setAli(Layout.Alignment.ALIGN_CENTER)
            mPrinter.setPrintAppendString("Thank You for Shopping with us".take(63), format)
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space
            mPrinter.setPrintAppendString("", format) // Space

            // Retry print start up to 2 times
            var printStatusResult = SdkResult.SDK_ERROR
            for (attempt in 1..2) {
                printStatusResult = mPrinter.setPrintStart()
                if (printStatusResult == SdkResult.SDK_OK) break
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "Print attempt $attempt failed: status=$printStatusResult")
                Thread.sleep(500)
            }
            if (printStatusResult == SdkResult.SDK_OK) {
                lifecycleScope.launch {
                    delay(500)
                    cutPaper()
                }
                return "true"
            }
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                .invokeMethod("showError", "Print start failed: status=$printStatusResult")
            return "false"
        } catch (e: Exception) {
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                .invokeMethod("showError", "Failed to print invoice: ${e.message ?: "Unknown error"}")
            return "false"
        }
    }

    private fun cutPaper() {
        try {
            val printStatus = mPrinter.getPrinterStatus()
            if (printStatus == SdkResult.SDK_OK) {
                mPrinter.openPrnCutter(1.toByte())
            } else {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("showError", "Printer status not OK for paper cut: $printStatus")
            }
        } catch (e: Exception) {
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                .invokeMethod("showError", "Failed to cut paper: ${e.message ?: "Unknown error"}")
        }
    }

    private fun numberToWords(number: Long): String {
        if (number == 0L) return "Zero"
        val units = arrayOf("", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine")
        val teens = arrayOf("Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen")
        val tens = arrayOf("", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety")
        val thousands = arrayOf("", "Thousand", "Lac", "Crore")

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
            if (thousandIndex == 2) { // Lac (10^5)
                val lacPart = (num % 100).toInt()
                if (lacPart > 0) {
                    val partText = convertLessThanThousand(lacPart)
                    parts.add(0, "$partText ${thousands[thousandIndex]}")
                }
                num /= 100
                thousandIndex++
            } else if (thousandIndex == 3) { // Crore (10^7)
                val crorePart = (num % 100).toInt()
                if (crorePart > 0) {
                    val partText = convertLessThanThousand(crorePart)
                    parts.add(0, "$partText ${thousands[thousandIndex]}")
                }
                num /= 100
                thousandIndex++
            } else {
                val part = (num % 1000).toInt()
                if (part > 0) {
                    val partText = convertLessThanThousand(part)
                    parts.add(0, if (thousands[thousandIndex].isEmpty()) partText else "$partText ${thousands[thousandIndex]}")
                }
                num /= 1000
                thousandIndex++
            }
        }
        return parts.joinToString(" ").trim()
    }
}