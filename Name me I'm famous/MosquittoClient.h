//
//  MosquittoClient.h
//
//  Copyright 2012 Nicholas Humfrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MosquittoMessage.h"

@protocol MosquittoClientDelegate

- (void) didConnect: (NSUInteger)code;
- (void) didDisconnect;
- (void) didPublish: (NSUInteger)messageId;
- (void) didReceiveMessage:(NSString*)payload forTopic:(NSString*)topic;
//- (void) didReceiveMessage: (MosquittoMessage*)mosq_msg;
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos;
- (void) didUnsubscribe: (NSUInteger)messageId;

@end


@interface MosquittoClient : NSObject {
    struct mosquitto *mosq;
    NSString *host;
    unsigned short port;
    NSString *username;
    NSString *password;
    unsigned short keepAlive;
    BOOL cleanSession;
    
    id<MosquittoClientDelegate> __weak delegate;
    NSTimer *timer;
}

@property (readwrite,strong) NSString *host;
@property (readwrite,assign) unsigned short port;
@property (readwrite,strong) NSString *username;
@property (readwrite,strong) NSString *password;
@property (readwrite,assign) unsigned short keepAlive;
@property (readwrite,assign) BOOL cleanSession;
@property (readwrite,weak) id<MosquittoClientDelegate> delegate;

+ (void) initialize;
+ (NSString*) version;


- (MosquittoClient*) initWithClientId: (NSString *)clientId andCleanSession:(BOOL)theCleanSessionFlag;
- (void) setMessageRetry: (NSUInteger)seconds;
- (void) connect;
- (void) connectToHost: (NSString*)host;
- (void) reconnect;
- (void) disconnect;

- (void)setWill: (NSString *)payload toTopic:(NSString *)willTopic withQos:(NSUInteger)willQos retain:(BOOL)retain;
- (void)clearWill;

- (void)publishString: (NSString *)payload toTopic:(NSString *)topic withMsgId:(int*)mId withQos:(NSUInteger)qos retain:(BOOL)retain;

- (void)subscribe: (NSString *)topic;
- (void)subscribe: (NSString *)topic withQos:(NSUInteger)qos;
- (void)unsubscribe: (NSString *)topic;


// This is called automatically when connected
- (void) loop: (NSTimer *)timer;

@end