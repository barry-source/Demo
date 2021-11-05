//
//  ViewController.m
//  UDP
//
//  Created by user on 2021/11/3.
//

#import "ViewController.h"
#import "ServerView.h"
#import "Server.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>


// mark: 出现无法传输数据的情况，删除app，重新安装
/*
 UDP广播机制的应用场景：
 若干个client。在局域网内(不知道IP的情况下) 须要在非常多设备里需找特有的设备，比方server，抑或是某个打印机，传真机等。
 如果我如今准备将server装在永不断电的iPad上。
 若干个clientiPhone 一激活。就要来向全部设备广播，谁是server。是server的话，请把IP地址告诉我。

 */
@interface ViewController ()

@property (nonatomic, strong) Server *server;
@property (nonatomic, strong) ServerView *sView;
@property (nonatomic, copy) NSString *port;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.sView];
    self.sView.frame = UIScreen.mainScreen.bounds;
}

- (Server *)server {
    if (!_server) {
        _server = Server.new;
        __weak typeof(self) weakSelf = self;
        _server.rev = ^(NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.sView.recLabel.text = msg;
                weakSelf.sView.recLabel.textColor = [weakSelf randomColor];
            });
        };
    }
    return _server;
}


- (ServerView *)sView {
    if (!_sView) {
        _sView = [[ServerView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        _sView.sendCallback = ^(NSString *ip, NSString *port, NSString *msg) {
            [weakSelf.server sendTokenWithIp:ip port:port msg: msg];
        };
        _sView.broadCallback = ^(NSString *ip, NSString *port, NSString *msg) {
            [weakSelf.server sendTokenWithIp:ip port:port msg: msg];
        };
        _sView.initCallback = ^(NSString *port){
            weakSelf.port = port;
            [weakSelf.server bindPort:port];
        };
    }
    return  _sView;
}


- (UIColor*)randomColor {

    NSInteger aRedValue =arc4random() %255;
    
    NSInteger aGreenValue =arc4random() %255;

    NSInteger aBlueValue =arc4random() %255;

    UIColor* randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];

    return randColor;
}


@end
