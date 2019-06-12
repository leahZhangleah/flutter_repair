package annaru.wl.com.repairproject;


import android.content.Intent;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static String CHANNEL = "annaru.flutter.io/repair";

    public static String _url;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if (methodCall.method.equals("present")) {
                            Intent intent = new Intent(MainActivity.this, CamaraActivity.class);
                            startActivity(intent);
                        } else if (methodCall.method.equals("getUrl")) {
                            result.success(_url);
                        }
                    }
                }
        );
        FlutterPluginBasicTest.registerWith(this.registrarFor(FlutterPluginBasicTest.CHANNEL));

    }
}
