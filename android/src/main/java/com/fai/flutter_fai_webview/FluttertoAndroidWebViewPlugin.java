package com.fai.flutter_fai_webview;

import com.fai.flutter_fai_webview.fac.WebViewViewFactory;

import io.flutter.plugin.common.PluginRegistry;

/**
 * flutter 调用 android 原生 WebView
 *
 */
public class FluttertoAndroidWebViewPlugin {
	public static void registerWith(PluginRegistry.Registrar registry) {
		//设置标识
		registry.platformViewRegistry().registerViewFactory("com.flutter_to_native_webview", new WebViewViewFactory(registry.messenger()));
	}
}