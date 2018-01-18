package im.shimo.topmodal;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.support.annotation.Nullable;
import android.view.Gravity;
import android.view.View;
import android.widget.PopupWindow;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.views.view.ReactViewGroup;


/**
 * Created by bell on 2018/1/17.
 */

public class TopModal extends ReactViewGroup implements LifecycleEventListener {
    private @Nullable
    PopupWindow mPopupWindow;
    private @Nullable
    View mContentView;


    public TopModal(Context context) {
        super(context);
    }

    @Override
    public void addView(View child, int index) {
        if (mContentView != null) {
            removeView(mContentView);
        }
        mContentView = child;
        showPopupWindow();
    }

    @Override
    public void removeView(View child) {
        dismissPopupWindow();
        mContentView = null;
    }

    public void onDropInstance() {
        dismissPopupWindow();
    }

    @Override
    public void onHostResume() {

    }

    @Override
    public void onHostPause() {

    }

    @Override
    public void onHostDestroy() {
        onDropInstance();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        onDropInstance();
    }

    private void dismissPopupWindow() {
        if (mPopupWindow != null) {
            mPopupWindow.dismiss();
            mPopupWindow = null;
        }
    }

    private void showPopupWindow() {
        if (mPopupWindow == null) {
            View rootView = getRootView();

            mPopupWindow = new PopupWindow(mContentView, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, false);
            mPopupWindow.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            mPopupWindow.showAtLocation(rootView, Gravity.NO_GRAVITY, 0, 0);
        }
    }
}
