//
//  TPIEmojiPrefixPrincipalClass.m
//  Textual-EmojiPrefix
//
//  Created by Aleksandr Pasechnik on 11/22/15Su.
//  Copyright © 2015 Megamicron. All rights reserved.
//

#import "TPIEmojiPrefixPrincipalClass.h"

#import <objc/runtime.h>

#import "TPIEmojiGenerator.h"

@implementation TPIEmojiPrefixPrincipalClass

- (void) pluginLoadedIntoMemory {
}

@end

@implementation TVCLogLine (EmojiPrefixes)

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(formattedNickname:);
        SEL swizzledSelector = @selector(prefix_emoji_formattedNickname:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
            class_addMethod(class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (NSString *)prefix_emoji_formattedNickname:(IRCChannel *) owner {
    NSString *original = [self prefix_emoji_formattedNickname:owner];
    NSString *emoji = [[TPIEmojiGenerator sharedGenerator] getEmojiForNickname:self.nickname];
    return [NSString stringWithFormat:@"%@ %@", emoji, original];
}

@end

@implementation TVCLogRenderer (EmojiPrefixes)

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = object_getClass((id) self);
        
        SEL originalSelector = @selector(renderTemplate:attributes:);
        SEL swizzledSelector = @selector(prefix_emoji_renderTemplate:attributes:);
        
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (NSString *)prefix_emoji_renderTemplate:(NSString *)templateName attributes:(NSDictionary *)templateTokens
{
    if ([templateTokens objectForKey:@"inlineNicknameMatchFound"]) {
        NSLog(@"swizzling with messageFragment '%@'", [templateTokens objectForKey:@"messageFragment"]);
        NSMutableDictionary *modifiedTokens = [NSMutableDictionary dictionaryWithDictionary:templateTokens];
        NSString *nickname = [templateTokens objectForKey:@"messageFragment"];
        NSString *emoji = [[TPIEmojiGenerator sharedGenerator] getEmojiForNickname:nickname];
        [modifiedTokens setObject:[NSString stringWithFormat:@"%@ %@",emoji,nickname]
                           forKey:@"messageFragment"];
        return [TVCLogRenderer prefix_emoji_renderTemplate:templateName attributes:modifiedTokens];
    }
    return [TVCLogRenderer prefix_emoji_renderTemplate:templateName attributes:templateTokens];
}

@end