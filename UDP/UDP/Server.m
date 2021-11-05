//
//  Server.m
//  UDP
//
//  Created by user on 2021/11/3.
//

#import "Server.h"
#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP
#import "Util.h"

@interface Server() <GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *asyncUdpSocket;

@property (nonatomic, strong) NSString *port;
@end

@implementation Server

- (void)dealloc {
    
}

- (void)bindPort: (NSString *)port {
    self.port = port;
    if (self.port == nil || self.port.length == 0) {
        self.port = @"9527";
    }
    if (_asyncUdpSocket != nil) {
        [self close];
        self.asyncUdpSocket = nil;
    }
    [self asyncUdpSocket];
}

- (void)close {
    self.asyncUdpSocket.delegate = nil;
    [self.asyncUdpSocket close];
}

- (void)sendTokenWithIp: (NSString *)ip port: (NSString *)port msg: (NSString *)msg {
    NSData *sendData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [self.asyncUdpSocket sendData:sendData toHost:ip port:port.integerValue withTimeout:-1 tag:0];
}

- (GCDAsyncUdpSocket *)asyncUdpSocket {
    if (!_asyncUdpSocket) {
        //初始化udp
        GCDAsyncUdpSocket *asyncUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        //绑定port
        NSError *err = nil;
        [asyncUdpSocket enableBroadcast:YES error:&err];
        [asyncUdpSocket enableReusePort:YES error:&err];
        bool result = [asyncUdpSocket bindToPort:self.port.integerValue error:&err];
        //启动接收线程
        [asyncUdpSocket beginReceiving:nil];
        _asyncUdpSocket = asyncUdpSocket;
    }
    return _asyncUdpSocket;
}

// MARK: -- GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection fails.
 * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
**/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error {
    
}

/**
 * Called when the datagram with the given tag has been sent.
**/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
**/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error {
    
}

/**
 * Called when the socket has received the requested datagram.
**/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.rev(msg);
    NSDictionary *para = @{
        @"isIPv4Enabled": @(self.asyncUdpSocket.isIPv4Enabled),
        @"isIPv6Enabled": @(self.asyncUdpSocket.isIPv6Enabled),
        @"isIPv4Preferred": @(self.asyncUdpSocket.isIPv4Preferred),
        @"isIPv6Preferred": @(self.asyncUdpSocket.isIPv6Preferred),
        @"maxSendBufferSize": @(self.asyncUdpSocket.maxSendBufferSize),
        @"maxReceiveIPv4BufferSize": @(self.asyncUdpSocket.maxReceiveIPv4BufferSize),
        @"maxReceiveIPv6BufferSize": @(self.asyncUdpSocket.maxReceiveIPv6BufferSize),
        @"userData": self.asyncUdpSocket.userData == nil ? @"" : self.asyncUdpSocket.userData,
        @"localAddress": [GCDAsyncUdpSocket hostFromAddress:self.asyncUdpSocket.localAddress],
        @"localHost": [self.asyncUdpSocket.localHost nilFilterd],
        @"localPort": @(self.asyncUdpSocket.localPort),
        @"localHost_IPv4": [self.asyncUdpSocket.localHost_IPv4 nilFilterd],
        @"localPort_IPv4": @(self.asyncUdpSocket.localPort_IPv4),
        @"localHost_IPv6": [self.asyncUdpSocket.localHost_IPv6 nilFilterd],
        @"localPort_IPv6": @(self.asyncUdpSocket.localPort_IPv6),
        @"connectedAddress": self.asyncUdpSocket.connectedAddress != nil ? [GCDAsyncUdpSocket hostFromAddress:self.asyncUdpSocket.connectedAddress] : @"",
        @"connectedHost": self.asyncUdpSocket.connectedHost == nil ? @"" : self.asyncUdpSocket.connectedHost,
        @"connectedPort": @(self.asyncUdpSocket.connectedPort),
        @"isConnected": @(self.asyncUdpSocket.isConnected),
    };
    NSLog(@"接收地址：\n%@", [GCDAsyncUdpSocket hostFromAddress:address]);
    NSLog(@"当前socket信息：\n%@", para);
}

/**
 * Called when the socket is closed.
**/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error {
    
}

@end

