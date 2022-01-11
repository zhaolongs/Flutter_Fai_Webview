package com.fai.flutter_fai_webview.view;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.fai.flutter_fai_webview.utils.WebviewSetingUtils;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.view.FlutterView;

public class TestTextViewWebView implements PlatformView, MethodChannel.MethodCallHandler {
	private static String TAG = TestTextViewWebView.class.getSimpleName();
	
	private TextView mTextView;
	private Context mContext;
	private boolean mIsLog;
	private boolean mHtmlImageIsClick;
	
	
	public TestTextViewWebView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
		this.mContext = context;
		mIsLog = false;
		if (params != null && !params.isEmpty() && params.containsKey("isLog")) {
			//设置滑动监听标识  默认为false
			try {
				mIsLog = (boolean) params.get("isLog");
			} catch (Exception e) {
				e.printStackTrace();
				mIsLog = false;
			}
		}
		if (params != null && params.containsKey("htmlImageIsClick")) {
			//通过 url 来加载页面
			try {
				mHtmlImageIsClick = (boolean) params.get("htmlImageIsClick");
			} catch (Exception e) {
				e.printStackTrace();
				mHtmlImageIsClick = false;
			}
			
		}
		
		
		
		//创建webview
		TextView lTextView = new TextView(context);
		ViewGroup.LayoutParams lLayoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		lTextView.setLayoutParams(lLayoutParams);
		lTextView.setBackgroundColor(Color.WHITE);
		
		this.mTextView = lTextView;
//
		
	}
	
	@Override
	public View getView() {
		return mTextView;
	}
	
	@Override
	public void dispose() {
		mTextView = null;
	}
	
	@Override
	public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
	
		
	}
	
	
}