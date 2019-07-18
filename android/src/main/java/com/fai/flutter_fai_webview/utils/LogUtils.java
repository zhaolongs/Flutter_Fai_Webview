package com.fai.flutter_fai_webview.utils;

import android.util.Log;

/**
 * Created by androidlongs on 16/12/18.
 * 站在顶峰，看世界
 * 落在谷底，思人生
 */

public class LogUtils {
    static String className;//类名
    static String methodName;//方法名
    static int lineNumber;//行数

    static boolean mIsDubug = true;

    private LogUtils() {
        /* Protect from instantiations */
    }

    public static boolean isDebuggable() {
        return mIsDubug;
    }

    private static String createLog(String log, boolean flag) {
        if (flag) {
            StringBuffer buffer = new StringBuffer("\n --------------------------------------start--------------------------------------\n");
            buffer.append(" | \n");
            buffer.append(" | ");
            buffer.append(methodName);
            buffer.append("\n | ");
            buffer.append("(").append(className).append(":").append(lineNumber).append(")");
            buffer.append("\n | ");
            buffer.append("\n | ");
            buffer.append(log);
            buffer.append("\n | ");
            buffer.append("\n --------------------------------------end---------------------------------------\n ");
            return buffer.toString();
        } else {
            return createLog(log);
        }

    }

    private static String createLog() {
        StringBuffer buffer = new StringBuffer();
        buffer.append(methodName);
        buffer.append("(").append(className).append(":").append(lineNumber).append(")");
        return buffer.toString();
    }

    private static String createLog(String log) {
        StringBuffer buffer = new StringBuffer();
        buffer.append(methodName);
        buffer.append("(").append(className).append(":").append(lineNumber).append(")");
        buffer.append(log);
        return buffer.toString();
    }

    private static void getMethodNames(StackTraceElement[] sElements) {
        className = sElements[1].getFileName();
        methodName = sElements[1].getMethodName();
        lineNumber = sElements[1].getLineNumber();
    }


    public static void e(String message) {
        if (!isDebuggable())
            return;

        // Throwable instance must be created before any methods
        getMethodNames(new Throwable().getStackTrace());
        Log.e(className, createLog(message));
    }

    public static void e(String message, boolean flag) {
        if (!isDebuggable())
            return;

        // Throwable instance must be created before any methods
        getMethodNames(new Throwable().getStackTrace());
        Log.e(className, createLog());
        Log.e(className, createLog(message, true));
    }


    public static void i(String message) {
        if (!isDebuggable())
            return;

        getMethodNames(new Throwable().getStackTrace());
        Log.i(className, createLog(message));
    }

    public static void d(String message) {
        if (!isDebuggable())
            return;

        getMethodNames(new Throwable().getStackTrace());
        Log.d(className, createLog(message));
    }

    public static void v(String message) {
        if (!isDebuggable())
            return;

        getMethodNames(new Throwable().getStackTrace());
        Log.v(className, createLog(message));
    }

    public static void w(String message) {
        if (!isDebuggable())
            return;

        getMethodNames(new Throwable().getStackTrace());
        Log.w(className, createLog(message));
    }

    public static void wtf(String message) {
        if (!isDebuggable())
            return;

        getMethodNames(new Throwable().getStackTrace());
        Log.wtf(className, createLog(message));
    }
}
