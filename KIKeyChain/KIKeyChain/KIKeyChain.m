//
//  KIKeyChain.m
//  kitalker
//
//  Created by kitalker on 12/7/6.
//  Copyright (c) 2012年 杨 烽. All rights reserved.
//

#import "KIKeyChain.h"
#import <Security/Security.h>

/*

These are the default constants and their respective types,
available for the kSecClassGenericPassword Keychain Item class:

kSecAttrAccessGroup			-		CFStringRef
kSecAttrCreationDate		-		CFDateRef
kSecAttrModificationDate    -		CFDateRef
kSecAttrDescription			-		CFStringRef
kSecAttrComment				-		CFStringRef
kSecAttrCreator				-		CFNumberRef
kSecAttrType                -		CFNumberRef
kSecAttrLabel				-		CFStringRef
kSecAttrIsInvisible			-		CFBooleanRef
kSecAttrIsNegative			-		CFBooleanRef
kSecAttrAccount				-		CFStringRef
kSecAttrService				-		CFStringRef
kSecAttrGeneric				-		CFDataRef
 
See the header file Security/SecItem.h for more details.

*/

@interface KIKeyChain ()

@property (nonatomic, retain) NSMutableDictionary *itemData;
@property (nonatomic, retain) NSMutableDictionary *query;

- (BOOL)writeToKeychain;

@end

@implementation KIKeyChain

+ (id)valueForIdentifier:(NSString *)identifier {
    KIKeyChain *keyChain = [[KIKeyChain alloc] initWithIdentifier:identifier accessGroup:nil];
    return [keyChain value];
}

+ (BOOL)setValue:(id)value forIdentifier:(NSString *)identifier {
    KIKeyChain *keyChain = [[KIKeyChain alloc] initWithIdentifier:identifier accessGroup:nil];
    [keyChain setValue:value];
    return [keyChain write];
}

+ (KIKeyChain *)keyChainWithIdentifier:(NSString *)identifier {
    return [KIKeyChain keyChainWithIdentifier:identifier accessGroup:nil];
}

+ (KIKeyChain *)keyChainWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup {
    return [[KIKeyChain alloc] initWithIdentifier:identifier accessGroup:accessGroup];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    return [self initWithIdentifier:identifier accessGroup:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup {
    if (self = [super init]) {
        if (identifier == nil || [[identifier stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            return nil;
        }
        
        self.query = [[NSMutableDictionary alloc] init];
		[self.query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [self.query setObject:identifier forKey:(__bridge id)kSecAttrGeneric];
    
		if (accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
#else			
			[self.query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
		}
		
        [self.query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
        [self.query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
        
        NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:self.query];
        
        CFDataRef resultDataRef;
        if (SecItemCopyMatching((__bridge CFDictionaryRef)tempQuery, (CFTypeRef *)&resultDataRef) == noErr) {
            NSMutableDictionary *result = (__bridge_transfer NSMutableDictionary *)resultDataRef;
            self.itemData = [self secItemFormatToDictionary:result];
		} else {
            [self reset];
            
            [self.itemData setObject:identifier forKey:(__bridge id)kSecAttrGeneric];
            if (accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
#else			
                [self.itemData setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
            }
        }
    }
	return self;
}

- (void)setObject:(id)inObject forKey:(id)key  {
    if (inObject == nil) {
        return;
    }
//    id currentObject = [self.itemData objectForKey:key];
//    if (![currentObject isEqual:inObject]) {
        [self.itemData setObject:inObject forKey:key];
//        [self writeToKeychain];
//    }
}

- (id)objectForKey:(id)key {
    return [self.itemData objectForKey:key];
}

- (void)reset {
	OSStatus junk = noErr;
    if (!self.itemData)  {
        self.itemData = [[NSMutableDictionary alloc] init];
    } else if (self.itemData) {
        NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:self.itemData];
		junk = SecItemDelete((__bridge CFDictionaryRef)tempDictionary);
        NSAssert( junk == noErr || junk == errSecItemNotFound, @"Problem deleting current dictionary." );
    }
    
    [self.itemData setObject:@"" forKey:(__bridge id)kSecAttrAccount];
    [self.itemData setObject:@"" forKey:(__bridge id)kSecAttrLabel];
    [self.itemData setObject:@"" forKey:(__bridge id)kSecAttrDescription];
//    [self.itemData setObject:nil forKey:(__bridge id)kSecValueData];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *service = [NSString stringWithFormat:@"%f.%@", [[NSDate date] timeIntervalSince1970], bundle.bundleIdentifier];
    [self.itemData setObject:service forKey:(__bridge id)kSecAttrService];
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    [result setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    id data = [dictionaryToConvert objectForKey:(__bridge id)kSecValueData];
    data = [NSKeyedArchiver archivedDataWithRootObject:data];
    
//    NSString *valueString = [dictionaryToConvert objectForKey:(__bridge id)kSecValueData];
    [result setObject:data forKey:(__bridge id)kSecValueData];
    
    return result;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    [result setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [result setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    CFDataRef resultDataRef;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)result, (CFTypeRef *)&resultDataRef) == noErr) {
        
        NSData *valueData = (__bridge_transfer NSData *)resultDataRef;
        
        [result removeObjectForKey:(__bridge id)kSecReturnData];
        
        id value = nil;
        @try {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:valueData];
        }
        @catch (NSException *exception) {
            value = [[NSString alloc] initWithBytes:[valueData bytes]
                                             length:[valueData length]
                                           encoding:NSUTF8StringEncoding];
        }
        @finally {
        }
        
        if (value) {
            [result setObject:value forKey:(__bridge id)kSecValueData];
        }
    } else {
#ifdef DEBUG
        NSAssert(NO, @"Serious error, no matching item found in the keychain.\n");
#endif
    }
   
	return result;
}

- (BOOL)write {
    return [self writeToKeychain];
}

- (BOOL)writeToKeychain {
    if (self.query == nil) {
        return NO;
    }
    NSDictionary *attributes = NULL;
    NSMutableDictionary *updateItem = NULL;
	OSStatus result;
    
    CFDataRef resultDataRef;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)self.query, (CFTypeRef *)&resultDataRef) == noErr) {
        
        attributes = (__bridge_transfer NSDictionary *)resultDataRef;
        
        updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        [updateItem setObject:[self.query objectForKey:(__bridge id)kSecClass] forKey:(__bridge id)kSecClass];
        
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:self.itemData];
        [tempCheck removeObjectForKey:(__bridge id)kSecClass];
		
#if TARGET_IPHONE_SIMULATOR
		[tempCheck removeObjectForKey:(__bridge id)kSecAttrAccessGroup];
#endif
        result = SecItemUpdate((__bridge CFDictionaryRef)updateItem, (__bridge CFDictionaryRef)tempCheck);
#ifdef DEBUG
		NSAssert( result == noErr, @"Couldn't update the Keychain Item." );
#endif
    } else {
        if ([self.itemData objectForKey:(__bridge id)kSecAttrCreationDate] == nil) {
            CFDateRef date = (__bridge CFDateRef)[NSDate date];
            [self.itemData setObject:(__bridge id)date forKey:(__bridge id)kSecAttrCreationDate];
        }
        
        if ([self.itemData objectForKey:(__bridge id)kSecAttrModificationDate] == nil) {
            CFDateRef date = (__bridge CFDateRef)[NSDate date];
            [self.itemData setObject:(__bridge id)date forKey:(__bridge id)kSecAttrModificationDate];
        }
        
        NSMutableDictionary *newItem = [self dictionaryToSecItemFormat:self.itemData];
        result = SecItemAdd((__bridge CFDictionaryRef)newItem, NULL);
#ifdef DEBUG
		NSAssert( result == noErr, @"Couldn't add the Keychain Item." );
#endif
    }
    
    return (result == noErr);
}

@end

@implementation KIKeyChain (KIKeyChain)

- (void)setAccount:(NSString *)account {
    [self setObject:account forKey:(__bridge id)kSecAttrAccount];
}

- (NSString *)account {
    return (NSString *)[self objectForKey:(__bridge id)kSecAttrAccount];
}

- (void)setValue:(id)value {
    [self setObject:value forKey:(__bridge id)kSecValueData];
}

- (id)value {
    return [self objectForKey:(__bridge id)kSecValueData];
}

- (void)setLabel:(NSString *)label {
    [self setObject:label forKey:(__bridge id)kSecAttrLabel];
}

- (NSString *)label {
    return (NSString *)[self objectForKey:(__bridge id)kSecAttrLabel];
}

- (void)setDescription:(NSString *)description {
    [self setObject:description forKey:(__bridge id)kSecAttrDescription];
}

- (NSString *)description {
    return (NSString *)[self objectForKey:(__bridge id)kSecAttrDescription];
}

- (void)setComment:(NSString *)comment {
    [self setObject:comment forKey:(__bridge id)kSecAttrComment];
}

- (NSString *)comment {
    return (NSString *)[self objectForKey:(__bridge id)kSecAttrComment];
}

- (void)setService:(NSString *)service {
    [self setObject:service forKey:(__bridge id)kSecAttrService];
}

- (NSString *)service {
    return (NSString *)[self objectForKey:(__bridge id)kSecAttrService];
}

- (void)setType:(NSNumber *)type {
    CFNumberRef number = (__bridge CFNumberRef)type;
    [self setObject:(__bridge id)(number) forKey:(__bridge id)kSecAttrType];
}

- (NSNumber *)type {
    CFNumberRef number = (__bridge CFNumberRef)([self objectForKey:(__bridge id)kSecAttrType]);
    return (__bridge NSNumber *)number;
}

- (void)setCreator:(NSNumber *)creator {
    CFNumberRef number = (__bridge CFNumberRef)creator;
    [self setObject:(__bridge id)number forKey:(__bridge id)kSecAttrCreator];
}

- (NSNumber *)creator {
    CFNumberRef number = (__bridge CFNumberRef)[self objectForKey:(__bridge id)kSecAttrCreator];
    return (__bridge NSNumber *)number;
}

- (void)setIsInvisible:(BOOL)isInvisible {
    CFBooleanRef b = (__bridge CFBooleanRef)[NSNumber numberWithBool:isInvisible];
    [self setObject:(__bridge id)(b) forKey:(__bridge id)kSecAttrIsInvisible];
}

- (BOOL)isInvisible {
    id v = [self objectForKey:(__bridge id)kSecAttrIsInvisible];
    if (v == nil) {
        return false;
    }
    return (BOOL)CFBooleanGetValue((CFBooleanRef)v);
}

- (void)setIsNegative:(BOOL)isNegative {
    CFBooleanRef b = (__bridge CFBooleanRef)[NSNumber numberWithBool:isNegative];
    [self setObject:(__bridge id)b forKey:(__bridge id)kSecAttrIsNegative];
}

- (BOOL)isNegative {
    id v = [self objectForKey:(__bridge id)kSecAttrIsNegative];
    if (v == nil) {
        return false;
    }
    return (BOOL)CFBooleanGetValue((CFBooleanRef)v);
}

//- (void)setModificationDate:(NSDate *)modificationDate {
//    CFDateRef date = (__bridge CFDateRef)modificationDate;
//    [self setObject:(__bridge id)(date) forKey:(__bridge id)kSecAttrModificationDate];
//}

- (NSDate *)modificationDate {
    CFDateRef date = (__bridge CFDateRef)[self objectForKey:(__bridge id)kSecAttrModificationDate];
    return (__bridge NSDate *)date;
}

- (NSDate *)creationDate {
    CFDateRef date = (__bridge CFDateRef)[self objectForKey:(__bridge id)kSecAttrCreationDate];
    return (__bridge NSDate *)date;
}

- (NSString *)accessGroup {
    return (NSString *)[self objectForKey:(__bridge id)kSecAttrAccessGroup];
}

- (NSString *)generic {
    return (NSString *)[self objectForKey:(__bridge id)kSecAttrGeneric];
}

@end

@implementation KIKeyChain (NSKeyValueCoding)

- (id)valueForKey:(NSString *)key {
    id object = [self value];
    if ([object respondsToSelector:@selector(valueForKey:)]) {
        return [object valueForKey:key];
    }
    return nil;
}

- (id)valueForKeyPath:(NSString *)keyPath {
    id object = [self value];
    if ([object respondsToSelector:@selector(valueForKeyPath:)]) {
        return [object valueForKeyPath:keyPath];
    }
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    id object = [self value];
    @synchronized(self){
        if ([object respondsToSelector:@selector(setValue:forKey:)]) {
            [object setValue:value forKey:key];
        }
        
        if (object == nil) {
            object = [[NSMutableDictionary alloc] init];
            [object setValue:value forKey:key];
            [self setValue:object];
        }
    }
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath {
    id object = [self value];
    if ([object respondsToSelector:@selector(setValue:forKeyPath:)]) {
        [object setValue:value forKeyPath:keyPath];
    }
}

@end
