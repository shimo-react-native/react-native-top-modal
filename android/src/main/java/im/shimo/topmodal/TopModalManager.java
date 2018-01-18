package im.shimo.topmodal;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;

/**
 * Created by bell on 2018/1/17.
 */

public class TopModalManager extends ViewGroupManager<TopModal> {
    private static final String REACT_CLASS = "TopModal";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public TopModal createViewInstance(ThemedReactContext context) {
        return new TopModal(context);
    }

    @Override
    public void onDropViewInstance(TopModal view) {
        super.onDropViewInstance(view);
        view.onDropInstance();
    }
}
