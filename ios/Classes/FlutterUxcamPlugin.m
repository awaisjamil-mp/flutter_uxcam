
#import "FlutterUxcamPlugin.h"

@import UXCam;

@implementation FlutterUxcamPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_uxcam"
                                     binaryMessenger:[registrar messenger]];
	
    FlutterUxcamPlugin* instance = [[FlutterUxcamPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
	
	[UXCam pluginType:@"flutter" version:@"2.0.1"];
}

// The handler method - this is the entry point from the Dart code
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
	// Find which method is being called and invoke the appropriate method on this class if we can find, else report ans error
	
	NSString* selectorName = [call.method stringByAppendingString:@":result:"];
	SEL selector = NSSelectorFromString(selectorName);
	if ([self respondsToSelector:selector])
	{
		NSLog(@"Hitting the invoke path for %@", call.method);
		// From https://stackoverflow.com/a/15761474/701926
		NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
		[inv setSelector:selector];
		[inv setTarget:self];

		//arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
		[inv setArgument:&(call) atIndex:2];
		[inv setArgument:&(result) atIndex:3]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation

		[inv invoke];
	}
	else
	{
		NSLog(@"UXCam: %@ is not a valid method", call.method);
		result(FlutterMethodNotImplemented);
	}
}

// The methods that map onto the Native UXCam calls
- (void)getPlatformVersion:(FlutterMethodCall*)call result:(FlutterResult)result
{
	result([@"iOS " stringByAppendingString:UIDevice.currentDevice.systemVersion]);
}

- (void)startWithKey:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* apiKey = call.arguments[@"key"];
	[UXCam startWithKey:apiKey completionBlock:^(BOOL started) {
		result(@(started));
	}];
}

- (void)startNewSession:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam startNewSession];
	result(nil);
}

- (void)stopSessionAndUploadData:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam stopSessionAndUploadData];
	result(nil);
}

- (void)allowShortBreakForAnotherApp:(FlutterMethodCall*)call result:(FlutterResult)result
{
	BOOL continueSession = [call.arguments[@"key"] boolValue];
	[UXCam allowShortBreakForAnotherApp:continueSession];
	result(nil);
}

- (void)occludeSensitiveScreen:(FlutterMethodCall*)call result:(FlutterResult)result
{
	BOOL value = [call.arguments[@"key"] boolValue];
	[UXCam occludeSensitiveScreen:value];
	result(nil);
}

- (void)occludeSensitiveScreenWithoutGesture:(FlutterMethodCall*)call result:(FlutterResult)result
{
	BOOL value = [call.arguments[@"key"] boolValue];
	NSNumber *withoutGesture = call.arguments[@"withoutGesture"];
	[UXCam occludeSensitiveScreen:value hideGestures:[withoutGesture boolValue]];
	result(nil);
}

- (void)occludeAllTextFields:(FlutterMethodCall*)call result:(FlutterResult)result
{
	BOOL value = [call.arguments[@"key"] boolValue];
	[UXCam occludeAllTextFields:value];
	result(nil);
}

- (void)occludeAllTextView:(FlutterMethodCall*)call result:(FlutterResult)result
{
	// Deprecated duplicate where we changed the name
	[self occludeAllTextFields:call result:result];
}

- (void)tagScreenName:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* eventName = call.arguments[@"key"];
	[UXCam tagScreenName:eventName];
	result(nil);
}

- (void)setAutomaticScreenNameTagging:(FlutterMethodCall*)call result:(FlutterResult)result
{
	BOOL value = [call.arguments[@"key"] boolValue];
	[UXCam setAutomaticScreenNameTagging:value];
	result(nil);
}

- (void)setMultiSessionRecord:(FlutterMethodCall*)call result:(FlutterResult)result
{
	BOOL value = [call.arguments[@"key"] boolValue];
	[UXCam setMultiSessionRecord:value];
	result(nil);
}

- (void)getMultiSessionRecord:(FlutterMethodCall*)call result:(FlutterResult)result
{
	BOOL status =  [UXCam getMultiSessionRecord];
	result(@(status));
}

- (void)setUserIdentity:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* userIdentity = call.arguments[@"key"];
	[UXCam setUserIdentity:userIdentity];
	result(nil);
}

- (void)setUserProperty:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* userProperty = call.arguments[@"key"];
	NSString* value = call.arguments[@"value"];
	[UXCam setUserProperty:userProperty value:value];
	result(nil);
}

- (void)logEvent:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* eventName = call.arguments[@"key"];
	if (eventName.length>0)
	{
		[UXCam logEvent:eventName];
	}
	result(nil);
}

- (void)logEventWithProperties:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* tag = call.arguments[@"eventName"];
	NSDictionary* properties = call.arguments[@"properties"];
	if (tag.length>0 && [properties isKindOfClass:NSDictionary.class])
	{
		[UXCam logEvent:tag withProperties:properties];
	}
	result(nil);
}

- (void)isRecording:(FlutterMethodCall*)call result:(FlutterResult)result
{
	result( @(UXCam.isRecording) );
}

- (void)pauseScreenRecording:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam pauseScreenRecording];
	result(nil);
}

- (void)resumeScreenRecording:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam resumeScreenRecording];
	result(nil);
}

- (void)optInOverall:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam optInOverall];
	result(nil);
}

- (void)optOutOverall:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam optOutOverall];
	result(nil);
}

- (void)optInOverallStatus:(FlutterMethodCall*)call result:(FlutterResult)result
{
	result( @(UXCam.optInOverallStatus) );
}

- (void)optIntoVideoRecording:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam optIntoSchematicRecordings];
	result(nil);
}

- (void)optOutOfVideoRecording:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam optOutOfSchematicRecordings];
	result(nil);
}

- (void)optInVideoRecordingStatus:(FlutterMethodCall*)call result:(FlutterResult)result
{
	result( @(UXCam.optInSchematicRecordingStatus) );
}

- (void)optIntoSchematicRecordings:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam optIntoSchematicRecordings];
	result(nil);
}

- (void)optOutOfSchematicRecordings:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam optOutOfSchematicRecordings];
	result(nil);
}

- (void)optInSchematicRecordingStatus:(FlutterMethodCall*)call result:(FlutterResult)result
{
	result( @(UXCam.optInSchematicRecordingStatus) );
}

- (void)cancelCurrentSession:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam cancelCurrentSession];
	result(nil);
}

- (void)deletePendingUploads:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam deletePendingUploads];
	result(nil);
}

- (void)pendingUploads:(FlutterMethodCall*)call result:(FlutterResult)result
{
	result( @(UXCam.pendingUploads) );
}

- (void)uploadPendingSession:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam uploadingPendingSessions:nil];
	result(nil);
}

- (void)stopApplicationAndUploadData:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam stopSessionAndUploadData];
	result(nil);
}

- (void)urlForCurrentUser:(FlutterMethodCall*)call result:(FlutterResult)result
{
	result(UXCam.urlForCurrentUser);
}

- (void)urlForCurrentSession:(FlutterMethodCall*)call result:(FlutterResult)result
{
	result(UXCam.urlForCurrentSession);
}

- (void)addVerificationListener:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSLog(@"UXCam: addVerificationListener is not supported by UXCam on iOS.");
	result(nil);
}

- (void)addScreenNameToIgnore:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* eventName = call.arguments[@"key"];
	[UXCam addScreenNameToIgnore:eventName];
	result(nil);
}

- (void)removeScreenNameToIgnore:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* eventName = call.arguments[@"key"];
	[UXCam removeScreenNameToIgnore:eventName];
	result(nil);
}

- (void)removeAllScreenNamesToIgnore:(FlutterMethodCall*)call result:(FlutterResult)result
{
	[UXCam removeAllScreenNamesToIgnore];
	result(nil);
}

- (void)setPushNotificationToken:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* token = call.arguments[@"key"];
	[UXCam setPushNotificationToken:token];
	result(nil);
}

- (void)reportBugEvent:(FlutterMethodCall*)call result:(FlutterResult)result
{
	NSString* eventName = call.arguments[@"eventName"];
	NSDictionary* properties = call.arguments[@"properties"];
	if (eventName.length>0 && [properties isKindOfClass:NSDictionary.class])
	{
		[UXCam reportBugEvent:eventName properties:properties];
	}
	else
	{
		[UXCam reportBugEvent:eventName properties:nil];
	}
	result(nil);
}

@end
