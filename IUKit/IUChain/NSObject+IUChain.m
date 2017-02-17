//
//  NSObject+IUChain.m
//  IUKitDemo
//
//  Created by admin on 2017/2/13.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSObject+IUChain.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import "IUMethodSwizzling.h"

#define IU_MESSAGE_SEND(type) ^(type obj) { [self setValue:@(obj) forKey:key]; return self; };


@implementation NSObject (IUChain)

id iuChainDynamicMethodIMP(id self, SEL _cmd) {
    NSString *string = NSStringFromSelector(_cmd);
    if ([string length] > 3) {
        NSString *key = [[string substringWithRange:NSMakeRange(3, 1)] lowercaseString];
        key = [string stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:key];
        string = [string stringByAppendingString:@":"];
        SEL selector = NSSelectorFromString(string);
        if ([self respondsToSelector:selector]) {
            NSMethodSignature *signature = [self methodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:selector];
            
            char *type = (char *)[signature getArgumentTypeAtIndex:2];
            while (*type == 'r' || // const
                   *type == 'n' || // in
                   *type == 'N' || // inout
                   *type == 'o' || // out
                   *type == 'O' || // bycopy
                   *type == 'R' || // byref
                   *type == 'V') { // oneway
                type++; // cutoff useless prefix
            }
            
#define block_with_type(_type_) \
^(_type_ arg) { \
    [invocation setArgument:&arg atIndex:2]; \
    [invocation invoke]; \
    return self; \
}
            switch (*type) {
                case 'v': // 1: void
                case 'B': // 1: bool
                case 'c': // 1: char / BOOL
                case 'C': // 1: unsigned char
                case 's': // 2: short
                case 'S': // 2: unsigned short
                case 'i': // 4: int / NSInteger(32bit)
                case 'I': // 4: unsigned int / NSUInteger(32bit)
                case 'l': // 4: long(32bit)
                case 'L': // 4: unsigned long(32bit)
                    return block_with_type(int);
                    
                case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
                case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
                    return block_with_type(long long);
                    
                case 'f': // 4: float / CGFloat(32bit)
                case 'd': // 8: double / CGFloat(64bit)
                    return block_with_type(double);
                    
                case 'D': // 16: long double
                    return block_with_type(long double);
                    
                case '*': // char *
                case '^': // pointer
                    return block_with_type(void *);
                    
                case ':': // SEL
                    return block_with_type(SEL);
                    
                case '#': // Class
                    return block_with_type(Class);
                    
                case '@': // id
                    return block_with_type(id);
                    
                default:
                    break;
            }
            
            if (strcmp(type, @encode(CGPoint)) == 0) {
                return block_with_type(CGPoint);
            } else if (strcmp(type, @encode(CGSize)) == 0) {
                return block_with_type(CGSize);
            } else if (strcmp(type, @encode(CGRect)) == 0) {
                return block_with_type(CGRect);
            } else if (strcmp(type, @encode(CGVector)) == 0) {
                return block_with_type(CGVector);
            } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                return block_with_type(CGAffineTransform);
            } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                return block_with_type(CATransform3D);
            } else if (strcmp(type, @encode(NSRange)) == 0) {
                return block_with_type(NSRange);
            } else if (strcmp(type, @encode(UIOffset)) == 0) {
                return block_with_type(UIOffset);
            } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                return block_with_type(UIEdgeInsets);
            }
            
            // Try with some dummy type...
            NSUInteger size = 0;
            NSGetSizeAndAlignment(type, &size, NULL);
#define case_size(_size_) \
else if (size <= 4 * _size_ ) { \
struct dummy { char tmp[4 * _size_]; }; \
return block_with_type(struct dummy); \
}
            if (size > 4 * 64) { }
            case_size( 1) case_size( 2) case_size( 3) case_size( 4)
            case_size( 5) case_size( 6) case_size( 7) case_size( 8)
            case_size( 9) case_size(10) case_size(11) case_size(12)
            case_size(13) case_size(14) case_size(15) case_size(16)
            case_size(17) case_size(18) case_size(19) case_size(20)
            case_size(21) case_size(22) case_size(23) case_size(24)
            case_size(25) case_size(26) case_size(27) case_size(28)
            case_size(29) case_size(30) case_size(31) case_size(32)
            case_size(33) case_size(34) case_size(35) case_size(36)
            case_size(37) case_size(38) case_size(39) case_size(40)
            case_size(41) case_size(42) case_size(43) case_size(44)
            case_size(45) case_size(46) case_size(47) case_size(48)
            case_size(49) case_size(50) case_size(51) case_size(52)
            case_size(53) case_size(54) case_size(55) case_size(56)
            case_size(57) case_size(58) case_size(59) case_size(60)
            case_size(61) case_size(62) case_size(63) case_size(64)
#undef case_size
#undef block_with_type
        }
    }
    return ^{ return self; };
}

+ (void)load {
    [self swizzleClassSelector:@selector(resolveInstanceMethod:) toSelector:@selector(iuChain_NSObject_resolveInstanceMethod:)];
}

+ (BOOL)iuChain_NSObject_resolveInstanceMethod:(SEL)sel {
    BOOL resolved = [self iuChain_NSObject_resolveInstanceMethod:sel];
    if (!resolved) {
        NSString *selString = NSStringFromSelector(sel);
        // "set"开头 && 非":"结尾 && 第4个字符为大写
        if ([selString hasPrefix:@"set"] &&
            ![selString hasSuffix:@":"] &&
            [selString length] > 3 && [[[selString substringWithRange:NSMakeRange(3, 1)] uppercaseString] isEqualToString:[selString substringWithRange:NSMakeRange(3, 1)]]) {
            class_addMethod([self class],sel,(IMP)iuChainDynamicMethodIMP,"@@:");
            resolved = YES;
        }
    }
    return resolved;
}

- (NSObject *(^)(__strong id *))assign {
    return ^(__strong id *obj) {
        *obj = self;
        return self;
    };
}

- (NSObject *)configure:(void (^)(NSObject *))configure {
    configure(self);
    return self;
}

@end
