package com.fai.flutter_fai_webview.view;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;

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
	private boolean mHtmlImageIsClick;
	private String webViewCacheMode = "LOAD_DEFAULT";
	
	
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
		if (params != null && params.containsKey("htmlImageIsClick")) {
			//通过 url 来加载页面
			try {
				mHtmlImageIsClick = (boolean) params.get("htmlImageIsClick");
			} catch (Exception e) {
				e.printStackTrace();
				mHtmlImageIsClick = false;
			}
			
		}


		if (params != null && params.containsKey("webViewCacheMode")) {
			//通过 url 来加载页面
			try {
				webViewCacheMode = (String) params.get("webViewCacheMode");
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		
		
		//创建webview
		CustomWebView lWebView = new CustomWebView(context);
		ViewGroup.LayoutParams lLayoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		lWebView.setLayoutParams(lLayoutParams);
		lWebView.setBackgroundColor(Color.WHITE);
		
		lWebView.setVisibility(View.VISIBLE);
		
//		final FlutterView.FirstFrameListener[] listeners = new FlutterView.FirstFrameListener[1];
//		listeners[0] = new FlutterView.FirstFrameListener() {
//			@Override
//			public void onFirstFrame() {
//				mWebView.setVisibility(View.VISIBLE);
//			}
//		};
		this.mWebView = lWebView;
//
		//初始化设置
		mWebviewSetingUtils = new WebviewSetingUtils();
		//通用设置
		mWebviewSetingUtils.initSetting(context, this.mWebView, mIsLog, mHtmlImageIsClick,webViewCacheMode);
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
			initLoadHtml(methodCall);
		} else if (lMethod.equals("goBack")) {
			if (mWebView.canGoBack()) {
				mWebView.goBack();
			}
		} else if (lMethod.equals("goForward")) {
			if (mWebView.canGoForward()) {
				mWebView.goForward();
			}
		} else if (lMethod.equals("canGoForward")) {
			result.success(mWebView.canGoForward());
		} else if (lMethod.equals("canGoBack")) {
			result.success(mWebView.canGoBack());
		} else if (lMethod.equals("reload")) {
			//刷新webview
			if (mWebView != null) {
				mWebView.reload();
			}
		} else if (lMethod.equals("jsload")) {
			Map<String, String> params = (Map<String, String>) methodCall.arguments;
			//加载页面
			
			String jsMethod = null;
			
			if (params != null) {
				if (params.containsKey("string")) {
					//通过 url 来加载页面
					jsMethod = (String) params.get("string");
					if (jsMethod != null) {
						//加载 JS方法
						mWebviewSetingUtils.loadJsMethod(jsMethod);
					}
					
				}
				
			}
			
		}
		
	}
	
	/**
	 * Html 页面中 通过 JS 调用Android原生方法
	 * Android 原生方法 再调用 Html 页面中的 JS 方法
	 *
	 * @param methodCall
	 */
	private void initLoadHtml(MethodCall methodCall) {
		Map<String, String> params = (Map<String, String>) methodCall.arguments;
		//加载页面
		
		String htmlUrl = null;
		String htmlData = null;
		String htmlDataBlock = null;
		
		if (params != null) {
			if (params.containsKey("url")) {
				//通过 url 来加载页面
				htmlUrl = (String) params.get("url");
			}
			
			if (params.containsKey("htmlData")) {
				htmlData = (String) params.get("htmlData");
			}
			if (params.containsKey("htmlBlockData")) {
				htmlDataBlock = (String) params.get("htmlBlockData");
			}
			
			
			//加载链接
			if (htmlUrl != null && !htmlUrl.trim().equals("")) {
				//通过 url 来加载页面
				mWebView.loadUrl(htmlUrl);
			} else if (htmlData != null && !htmlData.trim().equals("")) {
				//加载html文件数据
				//加载html完整页面
				mWebView.loadDataWithBaseURL(null, htmlData, "text/html", "utf-8", null);
			} else if (htmlDataBlock != null && !htmlDataBlock.trim().equals("")) {
				//加载html文件数据
				String artContent = htmlDataBlock;
				//加载html 代码块
				//在这里构造一个完整的html
				String[] split = artContent.split("</head>");
				if (split.length == 2) {
					StringBuilder stringBuilder = new StringBuilder(split[0]);
					stringBuilder.append("<meta name=\"viewport\" content=\"width=divice-width,initial-scale=1.0\" >\n");
					stringBuilder.append("<link rel=\"stylesheet\" type=\"text/css\" href=\"file:///android_asset/sample-css.css\"/> \n");
					stringBuilder.append("<style>html{margin:0;padding:0;font-family: sans-serif;font-size:14px} body{margin:10px;padding:0} img{width:99%;height:auto;}</style>");
					stringBuilder.append("<script type=\"text/javascript\" src=\"file:///android_asset/client.js\"></script>");
					
					stringBuilder.append("</head>");
					stringBuilder.append(split[1]);
					
					artContent = stringBuilder.toString();
					
					mWebView.loadDataWithBaseURL(null, artContent, "text/html", "utf-8",
							null);
				} else {
					//ToastUtils.show("数据异常,请重新进入", mContext);
					StringBuilder stringBuilder = new StringBuilder();
					stringBuilder.append("<html lang=\"en\"><head>");
					stringBuilder.append("<meta charset=\"UTF-8\">");
					stringBuilder.append("<meta name=\"viewport\" content=\"width=divice-width,initial-scale=1.0\" >\n");
					stringBuilder.append("<link rel=\"stylesheet\" type=\"text/css\" href=\"file:///android_asset/sample-css.css\"/> \n");
					stringBuilder.append("<style>html{margin:0;padding:0;font-family: sans-serif;font-size:14px} body{margin:10px;padding:0} img{width:99%;height:auto;}</style>");
					stringBuilder.append("<script type=\"text/javascript\" src=\"file:///android_asset/client.js\"></script>");
					
					stringBuilder.append("</head><body>");
					stringBuilder.append(artContent);
					stringBuilder.append("<script>");
					stringBuilder.append("var ch=window.screen.height;var cw=window.screen.width;if(cw===undefined){cw=375;}");
					stringBuilder.append(" var iframes = document.getElementsByTagName('iframe');");
					stringBuilder.append("if(iframes!==undefined){");

					stringBuilder.append(" for (var i = 0; i < iframes.length; i++) {");
					stringBuilder.append("var item = iframes[i];var preHeight =cw*9/16;item.height=preHeight;");
					stringBuilder.append("var src =item.src;console.log(\"src is  \"+src)");

					stringBuilder.append("}");

					stringBuilder.append("}");

					stringBuilder.append("</script>");
					stringBuilder.append("</body></html>");
					
					artContent = stringBuilder.toString();
				}
				if (mHtmlImageIsClick) {
					artContent = setHtmlCotentSupportImagePreview(artContent);
				}

				mWebView.loadDataWithBaseURL(null, artContent, "text/html", "utf-8", null);
			} else {
				mWebviewSetingUtils.postError(-1, "数据异常,请重新进入");
			}
		} else {
			mWebviewSetingUtils.postError(-1, "数据异常,请重新进入");
		}
		
	}
	
	public String setHtmlCotentSupportImagePreview(String body) {
		
		
		// 过滤掉 img标签的width,height属性
		body = body.replaceAll("(<img[^>]*?)\\s+width\\s*=\\s*\\S+", "$1");
		body = body.replaceAll("(<img[^>]*?)\\s+height\\s*=\\s*\\S+", "$1");
		// 添加点击图片放大支持
		// 添加点击图片放大支持
		body = body.replaceAll("(<img[^>]+src=\")(\\S+)\"",
				"$1$2\" onClick=\"showImagePreview('$2')\"");
		
		// 过滤table的内部属性
		body = body.replaceAll("(<table[^>]*?)\\s+border\\s*=\\s*\\S+", "$1");
		body = body.replaceAll("(<table[^>]*?)\\s+cellspacing\\s*=\\s*\\S+", "$1");
		body = body.replaceAll("(<table[^>]*?)\\s+cellpadding\\s*=\\s*\\S+", "$1");
		
		return body;
	}
	
	
}