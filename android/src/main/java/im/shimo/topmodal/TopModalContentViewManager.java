package im.shimo.topmodal;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;

public class TopModalContentViewManager extends ViewGroupManager<TopModalContentView> {
    private static final String REACT_CLASS = "TopModalContentView";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public TopModalContentView createViewInstance(ThemedReactContext context) {
        return new TopModalContentView(context);
    }
}
