package annaru.wl.com.repairproject;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Environment;
import androidx.annotation.Nullable;
import android.view.View;

//import com.cjt2325.cameralibrary.CheckPermissionsUtil;
//import com.cjt2325.cameralibrary.JCameraView;

import io.flutter.app.FlutterActivity;

public class CamaraActivity extends FlutterActivity {
/*
    private JCameraView mJCameraView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        View decorView = getWindow().getDecorView();
        decorView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN);
        CheckPermissionsUtil checkPermissionsUtil = new CheckPermissionsUtil(this);
        checkPermissionsUtil.requestAllPermission(this);
        mJCameraView = new com.cjt2325.cameralibrary.JCameraView(this);

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

                CamaraActivity.this.finish();
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

                FlutterPluginBasicTest basicMsgChannel= new FlutterPluginBasicTest();
                basicMsgChannel.sendMessage("complete");

                CamaraActivity.this.finish();
            }
        });
        setContentView(mJCameraView);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if(mJCameraView!=null){
            mJCameraView.onResume();
        }

    }
    @Override
    protected void onPause() {
        super.onPause();
        if(mJCameraView!=null){
            mJCameraView.onPause();
        }

    }*/
}
