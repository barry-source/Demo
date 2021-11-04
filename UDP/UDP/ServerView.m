//
//  ServerView.m
//  UDP
//
//  Created by user on 2021/11/3.
//

#import "ServerView.h"
#import "Util.h"

@interface ServerView ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *ipLabel;
@property (nonatomic, strong) UITextField *ipTextfield;

@property (nonatomic, strong) UILabel *portLabel;
@property (nonatomic, strong) UITextField *portTextfield;

@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UITextView *sendTextview;


@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *iniButton;
@property (nonatomic, strong) UIButton *broadButton;


@property (nonatomic, strong) UILabel *recTitleLabel;
@property (nonatomic, strong) UILabel *recLabel;

@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *sendMSG;

@end

@implementation ServerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [self fetchLabel];
        self.titleLabel.text = [NSString stringWithFormat:@"本机ip: %@", [Util getIPAddress]];
        self.titleLabel.frame = CGRectMake(0, 64, UIScreen.mainScreen.bounds.size.width, 64);
        
        self.ipLabel = [self fetchLabel];
        self.ipLabel.textColor = UIColor.whiteColor;
        self.ipLabel.backgroundColor = UIColor.blueColor;
        self.ipLabel.text = @"IP";
        self.ipLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, 50 , 44);
        
        self.portLabel = [self fetchLabel];
        self.portLabel.textColor = UIColor.whiteColor;
        self.portLabel.backgroundColor = UIColor.blueColor;
        self.portLabel.text = @"port";
        self.portLabel.frame = CGRectMake(0, CGRectGetMaxY(self.ipLabel.frame) + 10, 50 , 44);
        
        self.ipTextfield = [self fetchTextField:@"输入ip"];
        self.ipTextfield.text = [Util getIPAddress];
        self.ipTextfield.backgroundColor = UIColor.orangeColor;
        self.ipTextfield.frame = CGRectMake(60, CGRectGetMaxY(self.titleLabel.frame) + 10, 150 , 44);
        [self.ipTextfield addTarget:self action:@selector(ipChanged) forControlEvents:UIControlEventEditingChanged];
        
        self.portTextfield = [self fetchTextField:@"输入端口"];
        self.portTextfield.backgroundColor = UIColor.orangeColor;
        self.portTextfield.frame = CGRectMake(60, CGRectGetMaxY(self.ipLabel.frame) + 10, 150 , 44);
        [self.portTextfield addTarget:self action:@selector(portChanged) forControlEvents:UIControlEventEditingChanged];
        self.portTextfield.text = @"9527";
        
        self.sendLabel = [self fetchLabel];
        self.sendLabel.textAlignment = NSTextAlignmentLeft;
        self.sendLabel.text = @"发送区域:";
        self.sendLabel.frame = CGRectMake(0, CGRectGetMaxY(self.portTextfield.frame) + 20, UIScreen.mainScreen.bounds.size.width, 20);
        
        self.sendTextview = [self fetchTextview:@"我是发送的数据"];
        self.sendTextview.backgroundColor = UIColor.orangeColor;
        self.sendTextview.frame = CGRectMake(0, CGRectGetMaxY(self.sendLabel.frame) + 10, UIScreen.mainScreen.bounds.size.width, 80);
        
        self.recTitleLabel = [self fetchLabel];
        self.recTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.recTitleLabel.text = @"接收区域:";
        self.recTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.sendTextview.frame) + 20, UIScreen.mainScreen.bounds.size.width, 20);
        
        self.recLabel = [self fetchLabel];
        self.recLabel.numberOfLines = 0;
        self.recLabel.backgroundColor = UIColor.orangeColor;
        self.recLabel.frame = CGRectMake(0, CGRectGetMaxY(self.recTitleLabel.frame) + 10, UIScreen.mainScreen.bounds.size.width, 100);
        
        CGFloat margin = (UIScreen.mainScreen.bounds.size.width - 300) / 4.0;
        
        self.iniButton = [self fetchButton: @"根据端口初始化"];
        self.iniButton.titleLabel.font = [UIFont systemFontOfSize: 14];
        self.iniButton.frame = CGRectMake(margin, CGRectGetMaxY(self.recLabel.frame) + 20, 100, 50);
        self.sendButton = [self fetchButton: @"发送信息"];
        self.sendButton.frame = CGRectMake(margin *2 + 100, CGRectGetMaxY(self.recLabel.frame) + 20, 100, 50);
        self.broadButton = [self fetchButton: @"广播"];
        self.broadButton.frame = CGRectMake(margin * 3 + 200, CGRectGetMaxY(self.recLabel.frame) + 20, 100, 50);
        [self addSubview:self.titleLabel];
        [self addSubview:self.ipLabel];
        [self addSubview:self.portLabel];
        [self addSubview:self.iniButton];
        [self addSubview:self.sendButton];
        [self addSubview:self.broadButton];
        [self addSubview:self.ipTextfield];
        [self addSubview:self.recTitleLabel];
        [self addSubview:self.recLabel];
        [self addSubview:self.portTextfield];
        [self addSubview:self.sendLabel];
        [self addSubview:self.sendTextview];
        
        self.port = self.portTextfield.text;
        self.ip = self.ipTextfield.text;
        self.sendMSG = self.sendTextview.text;
        
    }
    return self;
}


- (void)ipChanged {
    self.ip = self.ipTextfield.text;
}

- (void)portChanged {
    self.port = self.portTextfield.text;
    [self.port stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)buttonDidClick: (UIButton *)sender {
    if (sender == self.iniButton) {
        if (self.initCallback) {
            self.initCallback(self.port);
        }
    } else if (sender == self.sendButton) {
        if (self.sendCallback) {
            self.sendCallback(self.ip, self.port, self.sendMSG);
        }
    } else {
        if (self.broadCallback) {
            self.broadCallback(@"255.255.255.255", self.port, self.sendMSG);
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.sendMSG = textView.text;
}

- (UITextView *)fetchTextview: (NSString *)text {
    UITextView *view = [[UITextView alloc] init];
    view.font = [UIFont systemFontOfSize:20];
    view.textAlignment = NSTextAlignmentLeft;
    view.scrollEnabled = YES;
    view.textColor = UIColor.whiteColor;
    view.delegate = self;
    view.showsVerticalScrollIndicator = NO;
    view.text = text;
    return view;
}

- (UITextField *)fetchTextField: (NSString *)text {
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = UIColor.blackColor;
    textField.placeholder = text;
    textField.layer.borderWidth = .5;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    return textField;
}

- (UILabel *)fetchLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.blackColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIButton *)fetchButton: (NSString *)text {
    UIButton *manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    manageButton.layer.cornerRadius = 5;
    manageButton.layer.masksToBounds = YES;
    manageButton.backgroundColor = UIColor.blueColor;
    [manageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [manageButton setTitle:text forState:UIControlStateNormal];
    [manageButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return manageButton;

}

@end
