package com.fai.flutter_fai_webview.view;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.webkit.WebView;

public class CustomWebView extends WebView {
	public CustomWebView(Context context) {
		super(context);
	}
	
	public CustomWebView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}
	
	public CustomWebView(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
	}
	private boolean isScrollBottom = false;
	private OnCustomChangeListener mOnScrollChangeListener;
	@Override
	protected void onScrollChanged(int l, int t, int oldl, int oldt) {
		super.onScrollChanged(l, t, oldl, oldt);
		//当前webview 高度
		float webContent = getContentHeight() * getScale();
		//
		float webNow = getHeight()+getScrollY();
		if(Math.abs(webContent-webNow)<1){
			isScrollBottom = true ;
			//处于底部
			if (mOnScrollChangeListener != null) {
				mOnScrollChangeListener.onPageEnd(l,t,oldl,oldt);
			}
		}else if (getScrollY()==0){
			//处于顶端
			if (mOnScrollChangeListener != null) {
				mOnScrollChangeListener.onPageTop(l,t,oldl,oldt);
			}
		}else {
			//中间
			if (mOnScrollChangeListener != null) {
				mOnScrollChangeListener.onScrollChange(l,t,oldl,oldt);
			}
		}
	}
	
	@Override
	protected void onOverScrolled(int scrollX, int scrollY, boolean clampedX, boolean clampedY) {
		super.onOverScrolled(scrollX, scrollY, clampedX, clampedY);
		if (!isScrollBottom&&clampedY &&  scrollY !=0) {
			Log.d("fai_webview","onOverScrolled回调");
			//处于底部
			if (mOnScrollChangeListener != null) {
				mOnScrollChangeListener.onPageEnd(scrollX,scrollY,scrollX,scrollY);
			}
		}
	}
	
	public interface OnCustomChangeListener{
		void onPageTop(int l, int t, int oldl, int oldt);
		void onScrollChange(int l, int t, int oldl, int oldt);
		void onPageEnd(int l, int t, int oldl, int oldt);
	}
	
	public void setOnScrollChangeListener(OnCustomChangeListener onScrollChangeListener) {
		mOnScrollChangeListener = onScrollChangeListener;
	}
}
