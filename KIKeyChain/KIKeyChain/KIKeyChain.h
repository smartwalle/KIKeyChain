//
//  KIKeyChain.h
//  kitalker
//
//  Created by kitalker on 12/7/6.
//  Copyright (c) 2012年 杨 烽. All rights reserved.
//

//https://developer.apple.com/library/ios/samplecode/GenericKeychain/Introduction/Intro.html

#import <UIKit/UIKit.h>

/*
KIKeyChain *key1 = [[KIKeyChain alloc] initWithIdentifier:@"user1"];
[key1 setAccount:@"this is username"];
[key1 setValue:@"this is password" forKey:@"password"];
[key1 write];
NSLog(@"%@==%@", [key1 account], [key1 valueForKey:@"password"]);


KIKeyChain *key2 = [[KIKeyChain alloc] initWithIdentifier:@"user2"];
[key2 setValue:@"this is username" forKey:@"username"];
[key2 setValue:@"this is password" forKey:@"password"];
[key2 write];
NSLog(@"%@==%@", [key2 valueForKey:@"username"], [key2 valueForKey:@"password"]);
 */

@interface KIKeyChain : NSObject

//存、取值的快捷方法
+ (id)valueForIdentifier:(NSString *)identifier;

+ (BOOL)setValue:(id)value forIdentifier:(NSString *)identifier;


+ (KIKeyChain *)keyChainWithIdentifier:(NSString *)identifier;

+ (KIKeyChain *)keyChainWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup;

- (instancetype)initWithIdentifier:(NSString *)identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup;

//一般情况下，不要直接调用这两个方法存、取值，应该使用下面category中提供的方法进行操作
- (void)setObject:(id)inObject forKey:(id)key;

- (id)objectForKey:(id)key;


- (void)reset;

//如果修改了某个key的值，一定要手动调用此方法进行保存
- (BOOL)write;

@end

@interface KIKeyChain (KIKeyChain)

//kSecAttrAccount - CFStringRef
@property (nonatomic) NSString *account;

//kSecValueData - CFDataRef
//value 可以为任何可序列化的对象
@property (nonatomic) id value;

//kSecAttrLabel - CFStringRef
@property (nonatomic) NSString *label;

//kSecAttrDescription - CFStringRef
@property (nonatomic) NSString *description;

//kSecAttrComment - CFStringRef
@property (nonatomic) NSString *comment;

//kSecAttrService - CFStringRef
@property (nonatomic) NSString *service;

//kSecAttrType - CFNumberRef
@property (nonatomic) NSNumber *type;

//kSecAttrCreator - CFNumberRef
@property (nonatomic) NSNumber *creator;

//kSecAttrIsInvisible - CFBooleanRef
@property (nonatomic) BOOL isInvisible;

//kSecAttrIsNegative - CFBooleanRef
@property (nonatomic) BOOL isNegative;

//kSecAttrModificationDate - CFDateRef
@property (nonatomic, readonly) NSDate *modificationDate;

//kSecAttrCreationDate - CFDateRef
@property (nonatomic, readonly) NSDate *creationDate;

//kSecAttrAccessGroup - CFStringRef
@property (nonatomic, readonly) NSString *accessGroup;

//kSecAttrGeneric - CFStringRef
@property (nonatomic, readonly) NSString *generic; //即传入的 identifier

@end

//本Category的所有方法都是针对 kSecValueData 字段存储的对象，也就是[KIKeyChain value]返回的对象
@interface KIKeyChain (NSKeyValueCoding)

- (id)valueForKey:(NSString *)key;

- (id)valueForKeyPath:(NSString *)keyPath;

//如果 kSecValueData 字段的值为nil（也就是[KIKeyChain value]返回的值为nil）
//则会将其初始化为一个 NSMutableDictionary 对象
- (void)setValue:(id)value forKey:(NSString *)key;

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;

@end