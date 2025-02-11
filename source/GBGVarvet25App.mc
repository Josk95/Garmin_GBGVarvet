import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Application;


class GBGVarvet25App extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new GBGVarvet25View() ];
    }

}

function getApp() as GBGVarvet25App {
    return Application.getApp() as GBGVarvet25App;
}
