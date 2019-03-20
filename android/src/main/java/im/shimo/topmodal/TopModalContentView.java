package im.shimo.topmodal;

import android.content.Context;
import android.view.MotionEvent;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.uimanager.JSTouchDispatcher;
import com.facebook.react.uimanager.RootView;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.events.EventDispatcher;
import com.facebook.react.views.view.ReactViewGroup;

class TopModalContentView extends ReactViewGroup implements RootView {

    private final JSTouchDispatcher mJSTouchDispatcher = new JSTouchDispatcher(this);

    public TopModalContentView(Context context) {
        super(context);
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent event) {
        return !onTouchEvent(event) || super.onInterceptTouchEvent(event);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        mJSTouchDispatcher.handleTouchEvent(event, getEventDispatcher());
        super.onTouchEvent(event);
        // In case when there is no children interested in handling touch event, we return true from
        // the root view in order to receive subsequent events related to that gesture
        return true;
    }

    @Override
    public void onChildStartedNativeGesture(MotionEvent androidEvent) {
        mJSTouchDispatcher.onChildStartedNativeGesture(androidEvent, getEventDispatcher());
    }

    public void handleException(Throwable t) {

    }

    @Override
    public void requestDisallowInterceptTouchEvent(boolean disallowIntercept) {
        // No-op - override in order to still receive events to onInterceptTouchEvent
        // even when some other view disallow that
    }

    private EventDispatcher getEventDispatcher() {
        ReactContext reactContext = (ReactContext) getContext();
        return reactContext.getNativeModule(UIManagerModule.class).getEventDispatcher();
    }

    @Override
    public void handleException(Throwable t) {

    }
}
