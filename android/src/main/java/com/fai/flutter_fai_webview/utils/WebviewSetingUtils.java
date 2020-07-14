package com.fai.flutter_fai_webview.utils;

import android.annotation.TargetApi;
import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.webkit.ConsoleMessage;
import android.webkit.JavascriptInterface;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebStorage;
import android.webkit.WebView;
import android.webkit.WebViewClient;


import com.fai.flutter_fai_webview.R;
import com.fai.flutter_fai_webview.view.CustomWebView;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

public class WebviewSetingUtils {
	private static String TAG = WebviewSetingUtils.class.getSimpleName();
	//webview 缓存路径
	private static final String APP_CACAHE_DIRNAME = "/flutter_x/webcache";
	private Context mContext;
	private WebView mWebView;
	private boolean mIsLog;
	private boolean mAllImgSrc=false;
	
	public void setAllImgSrc(boolean allImgSrc) {
		mAllImgSrc = allImgSrc;
	}
	
	public void initSetting(Context context, CustomWebView webView, boolean isLog,boolean picIsClick) {
		this.mContext = context;
		this.mWebView = webView;
		this.mIsLog = isLog;
		this.mAllImgSrc =picIsClick;
		
		//设置滑动监听
		webView.setOnScrollChangeListener(mOnScrollChangeListener);
		
		//声明WebSettings子类
		WebSettings webSettings = webView.getSettings();
		//如果访问的页面中要与Javascript交互，则webview必须设置支持Javascript
		webSettings.setJavaScriptEnabled(true);
		//支持插件
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO) {
			webSettings.setPluginState(WebSettings.PluginState.ON);
		}
		//设置自适应屏幕，两者合用
		//将图片调整到适合webview的大小
		webSettings.setUseWideViewPort(true);
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR_MR1) {
			// 缩放至屏幕的大小
			webSettings.setLoadWithOverviewMode(false);
		}
		//缩放操作
		webSettings.setSupportZoom(false); //支持缩放，默认为true。是下面那个的前提。
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
			webSettings.setBuiltInZoomControls(false); //设置内置的缩放控件。若为false，则该WebView不可缩放
		}
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			webSettings.setDisplayZoomControls(false); //隐藏原生的缩放控件
		}
		
		//设置缓冲大小，我设的是8M
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR_MR1) {
			webSettings.setAppCacheMaxSize(1024 * 1024 * 105);
			// 开启 DOM storage API 功能
			webSettings.setDomStorageEnabled(true);
			//开启 database storage API 功能
			webSettings.setDatabaseEnabled(true);
			//设置数据库缓存路径
			String cacheDirPath = context.getFilesDir().getAbsolutePath() + APP_CACAHE_DIRNAME;

//      String cacheDirPath = getCacheDir().getAbsolutePath()+Constant.APP_DB_DIRNAME;
			webSettings.setDatabasePath(cacheDirPath);
			
			//设置  Application Caches 缓存目录
			
			webSettings.setAppCachePath(cacheDirPath);
			//开启 Application Caches 功能
			webSettings.setAppCacheEnabled(true);
			webSettings.setAllowFileAccess(true);
			webSettings.setAppCacheEnabled(true);
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
				webSettings.setAllowFileAccessFromFileURLs(true);
				webSettings.setAllowUniversalAccessFromFileURLs(true);
			}
			webSettings.setCacheMode(WebSettings.LOAD_NO_CACHE);
			webSettings.setAllowFileAccess(true); //设置可以访问文件
		}
		
		webSettings.setRenderPriority(WebSettings.RenderPriority.HIGH);
		
		webSettings.setCacheMode(WebSettings.LOAD_DEFAULT);  //设置 缓存模式
		
		
		webSettings.setJavaScriptCanOpenWindowsAutomatically(true); //支持通过JS打开新窗口
		webSettings.setLoadsImagesAutomatically(true); //支持自动加载图片
		webSettings.setBlockNetworkImage(false);
		webSettings.setDefaultTextEncodingName("utf-8");//设置编码格式
		
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
		}
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
		}
		webView.addJavascriptInterface(new ReadFinishClass(), "controll");
		
		//获取网页对话框
		webView.setWebChromeClient(mWebChromeClient);
		
		webView.setWebViewClient(new CustomWebViewClient());
	}
	
	Handler mHandler = new Handler(Looper.myLooper());
	//用于回调flutter
	
	MethodChannel mMethodChannel;
	
	public void setMethodChannel(MethodChannel methodChannel) {
		this.mMethodChannel = methodChannel;
	}
	
	public void postError(int code, String message) {
		Map<String, Object> lMap = new HashMap<>();
		lMap.put("code", 1000);
		lMap.put("message", "" + message);
		lMap.put("content", "操作失败");
		
		post(lMap);
	}
	
	public void loadJsMethod(final String jsMethod) {
		mWebView.post(new Runnable() {
			@Override
			public void run() {
				// 注意调用的JS方法名要对应上
				// 调用javascript的callJS()方法
				mWebView.loadUrl("javascript:"+jsMethod);
			}
		});
	
	}
	
	public class ReadFinishClass {
		/**
		 * 页面加载成功
		 */
		@JavascriptInterface
		public void pageFinish(final float height) {
			Log.e("webview pageFinish", "web view loading finish mMeasuredHeight " + height);
			final Map<String, Object> lMap = new HashMap<>();
			lMap.put("code", 201);
			lMap.put("message", "测量成功V");
			lMap.put("content", height*1.0);
			
			post(lMap);
		}
		
		@JavascriptInterface
		public void otherJsMethodCall(String json) {
			if (mIsLog) {
				Log.e("webview pageFinish", "web js 方法调用" + json);
			}
			
			final Map<String, Object> lMap = new HashMap<>();
			lMap.put("code", 202);
			lMap.put("message", "js 方法回调");
			lMap.put("content", json);
			post(lMap);
			
		}
		@JavascriptInterface
		public void showImagePreview(String bigImageUrl) {
			if (mIsLog) {
				Log.e("webview showImagePreview", "web js 方法调用" + bigImageUrl);
			}
			
			if (bigImageUrl != null) {
				LogUtils.d("图片 点击 " + bigImageUrl);
				try {
					JSONObject lJSONObject = new JSONObject(bigImageUrl);
					String images = lJSONObject.getString("urls");
					int index = lJSONObject.getInt("index");
					String url = lJSONObject.getString("url");
					
					final Map<String, Object> lMap = new HashMap<>();
					lMap.put("code", 203);
					lMap.put("message", "图片点击 方法回调");
					lMap.put("content", bigImageUrl);
					lMap.put("url", url);
					lMap.put("index", index);
					String[] lSplit = images.split(",");
					lMap.put("images", Arrays.asList(lSplit));
					post(lMap);
				} catch (JSONException e) {
					e.printStackTrace();
				}
				
			}
			
			
		}
	}
	
	
	private WebChromeClient mWebChromeClient = new WebChromeClient() {
		
		@Override
		public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
			//构建一个来显示网页中的对话框
			Log.e(TAG,"alert "+url+" message:"+message);
			Map<String, Object> lMap = new HashMap<>();
			lMap.put("code", 501);
			lMap.put("message", ""+message);
			lMap.put("content", ""+url);
			post(lMap);
			return super.onJsAlert(view,url,message,result);
		}
		
		@Override
		public boolean onJsConfirm(WebView view, String url, String message, JsResult result) {
			return true;
		}
		
		@TargetApi(Build.VERSION_CODES.FROYO)
		@Override
		public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
			if (mIsLog) {
				Log.d("webview", "console message is " + consoleMessage.message() + "\n\t\t from line " + consoleMessage.lineNumber() + "\n\t\t of"
						+ consoleMessage.sourceId());
			}
			
			Map<String, Object> lMap = new HashMap<>();
			lMap.put("code", 403);
			lMap.put("message", "webview 日志输出");
			lMap.put("content", "console lineNumber:【" + consoleMessage.lineNumber() + "-->message:" + consoleMessage.message() + "】");
			post(lMap);
			
			return true;
		}
		
		//加载进度
		@Override
		public void onProgressChanged(WebView view, int newProgress) {
			super.onProgressChanged(view, newProgress);
		}
		
		//扩充缓存的容量
		//webview可以设置一个WebChromeClient对象，在其onReachedMaxAppCacheSize函数对扩充缓冲做出响应
		@Override
		public void onReachedMaxAppCacheSize(long spaceNeeded,
											 long totalUsedQuota, WebStorage.QuotaUpdater quotaUpdater) {
			
		}
		
		/**
		 * 当WebView加载之后，返回 HTML 页面的标题 Title
		 * @param view
		 * @param title
		 */
		@Override
		public void onReceivedTitle(WebView view, String title) {
		
		
		}
	};
	
	
	private class CustomWebViewClient extends WebViewClient {
		private View mErrorView;
		
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			mWebView.loadUrl(url);
			return true;
		}
		
		@Override
		public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
			if (mIsLog) {
				Log.e("webview ", " shouldInterceptRequest");
			}
			return super.shouldInterceptRequest(view, request);
		}
		
		@Override
		public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
			if (mIsLog) {
				Log.e("webview ", "webview  shouldInterceptRequest  url is " + url);
			}
			return super.shouldInterceptRequest(view, url);
		}
		
		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			super.onPageStarted(view, url, favicon);
			if (mIsLog) {
				Log.e("webview ", "web view loading start ");
			}
			
			Map<String, Object> lMap = new HashMap<>();
			lMap.put("code", 401);
			lMap.put("message", "webview 开始加载");
			lMap.put("content", "");
			post(lMap);
			
		}
		
		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
			if (mIsLog) {
				Log.e("webview ", "web view loading finish " + url);
			}
			
			Map<String, Object> lMap = new HashMap<>();
			lMap.put("code", 402);
			lMap.put("message", "webview 加载完成");
			lMap.put("content", "");
			post(lMap);
			
			mWebView.getSettings().setBlockNetworkImage(false);
			// mMainWebView.loadUrl("javascript:readBookDesPageFinish(" + mArticleModel.id + ")");
			//测量webview
			mWebView.loadUrl("javascript:controll.pageFinish(document.body.getBoundingClientRect().height)");
			if (mAllImgSrc) {
				mWebView.loadUrl("javascript:getAllImgSrc(document.body.innerHTML)");
			}
			
			
			
		}
		
		@Override
		public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
			super.onReceivedError(view, request, error);
			if (error != null) {
				Log.e("webview", "web view loading err  " + error.toString());
			}
			
			Map<String, Object> lMap = new HashMap<>();
			lMap.put("code", 404);
			lMap.put("message", "webview 加载出错");
			lMap.put("content", "" + error.toString());
			post(lMap);
			
		}
		
		
	}
	
	
	//webview 滑动监听
	private CustomWebView.OnCustomChangeListener mOnScrollChangeListener = new CustomWebView.OnCustomChangeListener() {
		
		int preLocation = 0;
		
		@Override
		public void onPageTop(int l, int t, int oldl, int oldt) {
			if (mIsLog) {
				Log.d(TAG, " webview scroll to top ");
			}
			
			Map<String, Object> lMap = new HashMap<>();
			lMap.put("code", 301);
			lMap.put("message", "webview 滑动到顶部");
			lMap.put("content", "");
			post(lMap);
		}
		
		@Override
		public void onScrollChange(int l, int t, int oldl, int oldt) {
			
			int flagTop = t - oldt;
			if (flagTop > 0) {
				if (mIsLog) {
					Log.d(TAG, " webview scroll onScrollChange  向下滑动 ");
				}
				if (preLocation <= 0) {
					preLocation = flagTop;
					Map<String, Object> lMap = new HashMap<>();
					lMap.put("code", 302);
					lMap.put("message", "webview 向下滑动");
					lMap.put("content", "");
					post(lMap);
				}
				
				
			} else {
				if (mIsLog) {
					Log.d(TAG, " webview scroll onScrollChange 向上滑动  ");
				}
				if (preLocation > 0) {
					preLocation = flagTop;
					Map<String, Object> lMap = new HashMap<>();
					lMap.put("code", 303);
					lMap.put("message", "webview 向上滑动");
					lMap.put("content", "");
					post(lMap);
				}
				
				
			}
		}
		
		@Override
		public void onPageEnd(int l, int t, int oldl, int oldt) {
			if (mIsLog) {
				Log.d(TAG, " webview scroll to bootom ");
			}
			Map<String, Object> lMap = new HashMap<>();
			lMap.put("code", 304);
			lMap.put("message", "webview 滑动到底部");
			lMap.put("content", "");
			post(lMap);
		}
	};
	
	/**
	 * code :203 图片点击回调
	 * // url 当前点击图片的链接 index 当前点击Html页面中所有图片中的角标 urls 所有图片的集合
	 * content: {"url":"http://pic.studyyoun.com/1543767087584","index":0,"urls":"http://pic.studyyoun.com/1543767087584,http://pic.studyyoun.com/1543767100547"}
	 *
	 */
	/**
	 * 向 Flutter 中发送消息
	 * code
	 * 201 测量webview 成功
	 * 202 JS调用
	 * 203 图片点击回调
	 * 301 滑动到顶部
	 * 302 向下滑动
	 * 303	向上滑动
	 * 304 滑动到底部
	 * 401 webview 开始加载
	 * 402 webview 加载完成
	 * 403 webview html中日志输出
	 * 404 webview 加载出错
	 * 501 webview 弹框回调
	 * <p>
	 * 1000 操作失败
	 *
	 * @param map
	 */
	private void post(final Map<String, Object> map) {
		mHandler.post(new Runnable() {
			@Override
			public void run() {
				if (mMethodChannel != null) {
					// 向Flutter 发送消息
					mMethodChannel.invokeMethod("android", map);
				}
			}
		});
	}
	
}
