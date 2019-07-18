package com.fai.flutter_fai_webview.fac;

import android.content.Context;

import com.fai.flutter_fai_webview.view.ComplexWebView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * 用于创建 ComplexWebView
 */
public class WebViewViewFactory extends PlatformViewFactory {
	private final BinaryMessenger messenger;
	
	public WebViewViewFactory(BinaryMessenger messenger) {
		super(StandardMessageCodec.INSTANCE);
		this.messenger = messenger;
	}
	
	/**
	 * @param context
	 * @param id
	 * @param args    args是由Flutter传过来的自定义参数
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public PlatformView create(Context context, int id, Object args) {
		//flutter 传递过来的参数
		Map<String, Object> params = (Map<String, Object>) args;
		//创建 TestTextView
		return new ComplexWebView(context, messenger, id, params);
		
	}
}