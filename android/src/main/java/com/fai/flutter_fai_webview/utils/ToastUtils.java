package com.fai.flutter_fai_webview.utils;


import android.content.Context;
import android.widget.Toast;

/**
 * Created by androidlongs on 17/3/14.
 * 站在顶峰，看世界
 * 落在谷底，思人生
 */

public class ToastUtils {
    private static Toast currentToast;
    private static ToastUtils toastUtils;
    private static Context mContext;

    public ToastUtils() {
    }
    
    public static ToastUtils getInstance(){
        if (toastUtils==null) {
            toastUtils = new ToastUtils();
        }
        return  toastUtils;
    }
    
    public  ToastUtils init(Context context){
        mContext = context;
        currentToast =Toast.makeText(mContext,"",Toast.LENGTH_SHORT);
        return toastUtils;
    }
    public void showMessage(Object msg){
        if (currentToast==null) {
            return;
        }
       currentToast.setText(""+msg);
       currentToast.show();;
    }
    
}
