#include "AppDelegate.h"
#import "JCVideoRecordView.h"
#import "FlutterBasicMessagePlugin.h"
#include "GeneratedPluginRegistrant.h"

@interface AppDelegate()
@property (nonatomic, strong) JCVideoRecordView *recordView;
@property NSString *url;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [FlutterBasicMessagePlugin registerWithRegistrar:[self registrarForPlugin:@"FlutterBasicMessagePlugin"]];
    
    // Override point for customization after application launch.
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel methodChannelWithName:@"annaru.flutter.io/repair"binaryMessenger:controller];
    
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        
        if ([@"getBatteryLevel" isEqualToString:call.method]) {
            int batteryLevel = [self getBatteryLevel];
            
            if (batteryLevel == -1) {
                result([FlutterError errorWithCode:@"UNAVAILABLE"
                                           message:@"Battery info unavailable"
                                           details:nil]);
            } else {
                result(@(batteryLevel));
            }
        }else if ([@"present" isEqualToString:call.method]){
            [self present];
        }
        else if ([@"getUrl" isEqualToString:call.method]){
            result([self getUrl]);
        }
        else {
            result(FlutterMethodNotImplemented);
        }
        
    }];
    
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)present{
    _recordView = [[JCVideoRecordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _recordView.cancelBlock = ^{
        
    };
    _recordView.completionBlock = ^(NSURL *fileUrl) {
        self->_url =[fileUrl absoluteString];
        NSString *uuu  =  [fileUrl absoluteString];
        
        FlutterBasicMessagePlugin *basicChannel = [[FlutterBasicMessagePlugin alloc] init];
        [basicChannel send:@"1"];
        
        NSLog(@"完整的url字符串:%@",uuu);
    };
    [_recordView present];
}

-(NSString*) getUrl
{
    return _url;
}

- (int)getBatteryLevel {
    UIDevice* device = UIDevice.currentDevice;
    device.batteryMonitoringEnabled = YES;
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return -1;
    } else {
        return (int)(device.batteryLevel * 100);
    }
}

@end
