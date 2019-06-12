package annaru.wl.com.repairproject;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Environment;
import android.util.Log;
import android.view.View;

//import com.cjt2325.cameralibrary.CheckPermissionsUtil;
//import com.cjt2325.cameralibrary.JCameraView;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.view.FlutterView;

public class CameraManager {
/*
    public static JCameraView mJCameraView;

    public void init(Activity context, View decorView, final FlutterActivity closeActivity, final FlutterView flutterView){
        decorView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN);
        CheckPermissionsUtil checkPermissionsUtil = new CheckPermissionsUtil(context);
        checkPermissionsUtil.requestAllPermission(context);
        mJCameraView = new com.cjt2325.cameralibrary.JCameraView(context);

        //(0.0.7+)设置视频保存路径（如果不设置默认为Environment.getExternalStorageDirectory().getPath()）
        mJCameraView.setSaveVideoPath(Environment.getExternalStorageDirectory().getPath());
        //(0.0.8+)设置手动/自动对焦，默认为自动对焦
        mJCameraView.setAutoFoucs(true);
        mJCameraView.setCameraViewListener(new JCameraView.CameraViewListener() {
            @Override
            public void quit() {
                //返回按钮的点击时间监听
                //Intent intent = new Intent(CamaraActivity.this, MainActivity.class);
                //startActivity(intent);

                closeActivity.finish();
            }

            @Override
            public void captureSuccess(Bitmap bitmap) {
                //获取到拍照成功后返回的Bitmap
            }

            @Override
            public void recordSuccess(String url) {
                //获取成功录像后的视频路径
                MainActivity._url = url;
                //Intent intent = new Intent(CamaraActivity.this, MainActivity.class);
                //startActivity(intent);

                BasicMessageChannel channel = new BasicMessageChannel(flutterView, "flutter_message_plugin", StringCodec.INSTANCE );
                channel.setMessageHandler(new BasicMessageChannel.MessageHandler() {
                    @java.lang.Override
                    public void onMessage(java.lang.Object object, BasicMessageChannel.Reply reply) {
                        Log.i("BasicMessageChannel", "接收到Flutter的消息:" + object);
                    }
                });

                channel.send("发送消息到Flutter");

                closeActivity.finish();
            }
        });
    }*/


}
