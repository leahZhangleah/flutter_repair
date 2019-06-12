package annaru.wl.com.repairproject;

import android.util.Log;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;

public class FlutterPluginBasicTest implements BasicMessageChannel.MessageHandler{

    private static final String TAG = "FlutterPluginBasicTest";
    public static String CHANNEL = "com.mmd.flutterapp/plugin";

    static BasicMessageChannel messageChannel;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        messageChannel = new BasicMessageChannel(registrar.messenger(),CHANNEL,StandardMessageCodec.INSTANCE);
        FlutterPluginBasicTest flutterPluginBasicTest = new FlutterPluginBasicTest();
        messageChannel.setMessageHandler(flutterPluginBasicTest);
    }

    /**
     * java 发起通信
     * @param string
     */
    void sendMessage(String string) {
        messageChannel.send(string, new BasicMessageChannel.Reply() {
            @Override
            public void reply(Object o) {
                Log.d(TAG, "reply: "+0);
            }
        });
    }

    @Override
    public void onMessage(Object o, BasicMessageChannel.Reply reply) {
        Log.d(TAG, "onMessage: "+o);
        reply.reply("ok");
    }
}
