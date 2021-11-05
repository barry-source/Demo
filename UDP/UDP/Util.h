//
//  Util.h
//  UDP
//
//  Created by user on 2021/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Util : NSObject

+ (NSString *)getIPAddress;

@end

NS_ASSUME_NONNULL_END

@interface NSString (Util)

- (NSString *)nilFilterd;

@end


