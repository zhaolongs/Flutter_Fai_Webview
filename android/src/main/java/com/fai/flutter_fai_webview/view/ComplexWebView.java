package com.fai.flutter_fai_webview.view;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;


import com.fai.flutter_fai_webview.utils.WebviewSetingUtils;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class ComplexWebView implements PlatformView, MethodChannel.MethodCallHandler {
	private static String TAG = ComplexWebView.class.getSimpleName();
	
	private CustomWebView mWebView;
	private final WebviewSetingUtils mWebviewSetingUtils;
	private Context mContext;
	private boolean mIsLog;
	
	
	public ComplexWebView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
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
		//创建webview
		CustomWebView lWebView = new CustomWebView(context);
		ViewGroup.LayoutParams lLayoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		lWebView.setLayoutParams(lLayoutParams);
		this.mWebView = lWebView;
		

//
		//初始化设置
		mWebviewSetingUtils = new WebviewSetingUtils();
		//通用设置
		mWebviewSetingUtils.initSetting(context, this.mWebView, mIsLog);
		//注册消息监听
		MethodChannel methodChannel = new MethodChannel(messenger, "com.flutter_to_native_webview_" + id);
		methodChannel.setMethodCallHandler(this);
		//设置回调 实例
		mWebviewSetingUtils.setMethodChannel(methodChannel);
		
		
	}
	
	@Override
	public View getView() {
		return mWebView;
	}
	
	@Override
	public void dispose() {
		mWebView = null;
	}
	
	@Override
	public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
		
		//方法
		String lMethod = methodCall.method;
		
		/**
		 * 调用 load 方法来发起 WebView 的加载网页功能
		 * 需要传递的参数
		 * @param url 加载网页的链接
		 * @param data 加载 完整html 文件数据 如 <html><head> .... .. </head></html>
		 * @param datablock 加载 html 代码块 如<p> .... </p>
		 *
		 */
		if (lMethod.equals("load")) {
			Map<String, String> params = (Map<String, String>) methodCall.arguments;
			//加载页面
			//加载链接
			if (params != null && params.containsKey("url")) {
				//通过 url 来加载页面
				String url = (String) params.get("url");
				mWebView.loadUrl(url);
			} else if (params != null && params.containsKey("htmlData")) {
				//加载html文件数据
				String artContent = (String) params.get("htmlData");
				//加载html完整页面
				mWebView.loadDataWithBaseURL(null, artContent, "text/html", "utf-8", null);
			} else if (params != null && params.containsKey("htmlBlockData")) {
				//加载html文件数据
				String artContent = (String) params.get("htmlBlockData");
				//加载html 代码块
				//在这里构造一个完整的html
				String[] split = artContent.split("</head>");
				if (split.length == 2) {
					StringBuilder stringBuilder = new StringBuilder(split[0]);
					stringBuilder.append("<meta name=\"viewport\" content=\"width=divice-width,initial-scale=1.0\" >\n");
					stringBuilder.append("<link rel=\"stylesheet\" type=\"text/css\" href=\"file:///android_asset/sample-css.css\"/> \n");
					stringBuilder.append("<style>html{margin:0;padding:0;font-family: sans-serif;font-size:14px} body{margin:10px;padding:0} img{width:80%;height:auto;}</style>");
					stringBuilder.append("<script type=\"text/javascript\" src=\"file:///android_asset/client.js\"></script>");
					
					stringBuilder.append("</head>");
					stringBuilder.append(split[1]);
					
					artContent = stringBuilder.toString();
					
					mWebView.loadDataWithBaseURL(null, artContent, "text/html", "utf-8",
							null);
				} else {
					//ToastUtils.show("数据异常,请重新进入", mContext);
					StringBuilder stringBuilder = new StringBuilder();
					stringBuilder.append("<html><head>");
					stringBuilder.append("<meta name=\"viewport\" content=\"width=divice-width,initial-scale=1.0\" >\n");
					stringBuilder.append("<link rel=\"stylesheet\" type=\"text/css\" href=\"file:///android_asset/sample-css.css\"/> \n");
					stringBuilder.append("<style>html{margin:0;padding:0;font-family: sans-serif;font-size:14px} body{margin:10px;padding:0} img{width:80%;height:auto;}</style>");
					stringBuilder.append("<script type=\"text/javascript\" src=\"file:///android_asset/client.js\"></script>");
					
					stringBuilder.append("</head><body>");
					stringBuilder.append(artContent);
					stringBuilder.append("</body></html>");
					
					artContent = stringBuilder.toString();
				}
				mWebView.loadDataWithBaseURL(null, artContent, "text/html", "utf-8", null);
			} else {
				Toast.makeText(mContext, "数据异常,请重新进入", Toast.LENGTH_SHORT).show();
			}
		}
		
	}
	
}