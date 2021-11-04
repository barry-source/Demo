//
//  ServerView.h
//  UDP
//
//  Created by user on 2021/11/3.
//

#import <UIKit/UIKit.h>

typedef void (^ServerCallback)(NSString *, NSString *, NSString *);

typedef void (^BroadcastCallback)(NSString *, NSString *, NSString *);

typedef void (^InitCallback)(NSString *);

NS_ASSUME_NONNULL_BEGIN

@interface ServerView : UIView

@property (readonly) UILabel *recLabel;

@property (nonatomic, copy) ServerCallback sendCallback;

@property (nonatomic, copy) InitCallback initCallback;

@property (nonatomic, copy) BroadcastCallback broadCallback;

@end

NS_ASSUME_NONNULL_END
