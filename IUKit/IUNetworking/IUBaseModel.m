//
//  IUBaseModel.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUBaseModel.h"
#import "MJExtension.h"

NSString *randomString() {
    NSInteger length = arc4random() % 50 + 1;
    NSString *pool = @"ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678";
    NSMutableString *randomString = [@"randomString_" mutableCopy];
    for (int i = 0; i < length; i++) {
        [randomString appendString:[pool substringWithRange:NSMakeRange(arc4random()%[pool length], 1)]];
    }
    return randomString;
}

NSInteger randomNumber() {
    return arc4random() % 10000;
}

BOOL randomBOOL() {
    return arc4random() % 2 == 0;
}

@implementation IUBaseModel

/* 获取对象的所有属性 */
+ (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *propertiesAttrArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        const char* propertyAttributes =property_getAttributes(properties[i]);
        
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
        [propertiesAttrArray addObject: [NSString stringWithUTF8String: propertyName]];
        
        NSLog(@"attributes:%s",propertyAttributes);
        
        //        NSLog(@"\r\n%@\r\n",propertiesAttrArray[i]);
    }
    free(properties);
    
    return propertiesArray;
}

/* 获取字典 key:属性-value:属性 */
+ (NSDictionary*)getDicPropertiesToSameValue{
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    NSArray *allProperties = [self getAllProperties];
    for (int i = 0; i < allProperties.count ; i++)
    {
        [returnDic setObject:allProperties[i] forKey:allProperties[i]];
    }
    return returnDic;
}

/*替换属性*/
//改成遍历
+ (NSDictionary *)UpdateRuleDic:(NSDictionary *)updateDic{
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] initWithDictionary:[self getDicPropertiesToSameValue]];
    if (updateDic==nil) {
        [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{};
        }];
        return returnDic;
    }
    else {
        [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return updateDic;
        }];
    }
    //    for (NSString* key in updateDic.allKeys) {
    //        [returnDic setObject:[updateDic objectForKey:key] forKey:key];
    //    }
    return returnDic;
}

+ (void)clearRule {
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{};
    }];
}

+ (instancetype)randomData {
    id model = [[self alloc] init];
    [self mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        @try {
            id value = nil;
            
            MJPropertyType *type = property.type;
            Class propertyClass = type.typeClass;
            Class objectClass = [property objectClassInArrayForClass:[self class]];
            
            if (!type.isFromFoundation && propertyClass) { // 模型属性
                if ([propertyClass isSubclassOfClass:[IUBaseModel class]]) {
                    value = [NSClassFromString(NSStringFromClass(propertyClass)) randomData];
                }
            } else if ([propertyClass isSubclassOfClass:[NSArray class]]) {
                if ([objectClass isSubclassOfClass:[IUBaseModel class]]) {
                    NSMutableArray *temp = [@[] mutableCopy];
                    for (int i = 0; i < 10; i++) {
                        [temp addObject:[NSClassFromString(NSStringFromClass(objectClass)) randomData]];
                    }
                    value = [temp copy];
                } else if (objectClass == [NSString class] || objectClass == nil) {
                    NSMutableArray *temp = [@[] mutableCopy];
                    for (int i = 0; i < 10; i++) {
                        [temp addObject:randomString()];
                    }
                    value = [temp copy];
                }
            } else if ([propertyClass isSubclassOfClass:[NSString class]]) {
                value = randomString();
            } else if ([propertyClass isSubclassOfClass:[NSNumber class]]) {
                value = type.isBoolType ? @(randomBOOL()) : @(randomNumber());
            } else if (type.numberType) {
                value = @(randomNumber());
            } else if (type.boolType) {
                value = @(randomBOOL());
            }
            
            if (value != nil) [property setValue:value forObject:model];;
            
        } @catch (NSException *exception) {
        }
    }];
    return model;
}

- (NSString *)description {
    NSMutableString *string = [@"{" mutableCopy];
    NSSet *ignoredKeys = [NSSet setWithObjects:@"description", @"debugDescription", @"hash", @"class", @"superclass", nil];
    [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        @try {
            if (![ignoredKeys containsObject:property.name]) {
                [string appendString:property.name];
                [string appendString:@" : "];
                [string appendString:[NSString stringWithFormat:@"%@", [self valueForKey:property.name]]];
                [string appendString:@", "];
            }
        } @catch (NSException *exception) {
            NSLog(@"error");
        }
    }];
    
    if (string.length > 3) [string deleteCharactersInRange:NSMakeRange(string.length - 2, 2)];
    [string appendString:@"}"];
    return [string copy];
}

@end
