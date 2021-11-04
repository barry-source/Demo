//
//  Server.h
//  UDP
//
//  Created by user on 2021/11/3.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP

typedef void (^ReceiveHandler)(NSString * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface Server : NSObject

@property (nonatomic, readonly) GCDAsyncUdpSocket *asyncUdpSocket;

@property (nonatomic, copy) ReceiveHandler rev;

- (void)bindPort: (NSString *)port;

- (void)close;

- (void)sendTokenWithIp: (NSString *)ip port: (NSString *)port msg: (NSString *)msg;

@end

NS_ASSUME_NONNULL_END
