//
//  NSDictionary+FYDictionary.m
//  Pods
//
//  Created by 薛焱 on 2017/8/23.
//
//

#import "NSDictionary+FYDictionary.h"

@implementation NSDictionary (FYDictionary)

- (NSString *)descriptionWithLocale:(nullable id)locale{
    
    NSString *logString;
    
    @try {
        
        logString=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        
    } @catch (NSException *exception) {
        
        NSString *reason = [NSString stringWithFormat:@"reason:%@",exception.reason];
        logString = [NSString stringWithFormat:@"转换失败:\n%@,\n转换终止,输出如下:\n%@",reason,self.description];
        
    } @finally {
        
    }
    return logString;
}

@end
