//
//  Server.m
//  UDP
//
//  Created by user on 2021/11/3.
//

#import "Server.h"
#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP

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
}

/**
 * Called when the socket is closed.
**/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error {
    
}


////已接收到消息
//- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
//    if(data是找server的){
//        　　　　　　//依据client给的IP，利用TCP或UDP 相互连接上就能够開始通讯了
//    }　　return YES;
//}
////没有接受到消息
//-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
//}
////没有发送出消息
//-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
//}
////已发送出消息
//-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
//}
////断开连接
//-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
//}

@end
