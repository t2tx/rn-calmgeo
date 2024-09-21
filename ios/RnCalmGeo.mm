#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(RnCalmGeo, NSObject)

// start
RCT_EXTERN_METHOD(start:(NSString * )config
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
// config
RCT_EXTERN_METHOD(config:(NSString * )config
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
// stop
RCT_EXTERN_METHOD(stop:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)                 
// getCount
RCT_EXTERN_METHOD(getCount:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
// getLocation
RCT_EXTERN_METHOD(getLocation:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
// clear
RCT_EXTERN_METHOD(clear:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
// sync
RCT_EXTERN_METHOD(sync:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)                 
// isRunning
RCT_EXTERN_METHOD(isRunning:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
                                  
+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
