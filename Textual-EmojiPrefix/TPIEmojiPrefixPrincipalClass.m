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

#import <CocoaExtensions/XRGlobalModels.h>

@interface TPIEmojiPrefixPrincipalClass () <NSTableViewDelegate>

@property (nonatomic, strong) IBOutlet NSView *preferencesPane;
@property (nonatomic, strong) IBOutlet NSTableView *overrideTableView;
@property (nonatomic, strong) IBOutlet NSTextField *playgroundNicknameField;
@property (nonatomic, strong) IBOutlet NSTextField *playgroundEmojiField;

- (IBAction)addOverrideButtonClicked:(id)sender;
- (IBAction)removeOverrideButtonClicked:(id)sender;

@end


@implementation NSMutableDictionary (NSTableViewDataSource)

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [self count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    id key = [[self sortedDictionaryKeys] objectAtIndex:rowIndex];
    if ([[aTableColumn identifier] isEqualToString:@"nickname"]) {
        return key;
    } else {
        return [self objectForKey:key];
    }
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    id key = [[self sortedDictionaryKeys] objectAtIndex:rowIndex];
    id newKey = nil;
    if ([[aTableColumn identifier] isEqualToString:@"nickname"]) {
        newKey = [[TPIEmojiGenerator sharedGenerator] preprocessNicknameString:anObject];
        id oldValue = [self objectForKey:key];
        [self removeObjectForKey:key];
        [self setObject:oldValue forKey:newKey];
    } else {
        [self setValue:anObject forKey:key];
    }
    [[TPIEmojiGenerator sharedGenerator] removeNicknameFromCache:key];
    if (newKey != nil) {
        [[TPIEmojiGenerator sharedGenerator] removeNicknameFromCache:newKey];
    }
}

@end

@implementation TPIEmojiPrefixPrincipalClass

- (void) pluginLoadedIntoMemory {
    [self performBlockOnMainThread:^{
        [TPIBundleFromClass() loadNibNamed:@"TPIEmojiPrefixPane"
                                     owner:self
                           topLevelObjects:nil];  
    }];
    [self.overrideTableView setDataSource:[[TPIEmojiGenerator sharedGenerator] overrideTable]];
}

- (IBAction)addOverrideButtonClicked:(id)sender {
    NSString *nickname = [[TPIEmojiGenerator sharedGenerator] preprocessNicknameString:[self.playgroundNicknameField stringValue]];
    if ([nickname length] > 0) {
        NSString *emoji = [self.playgroundEmojiField stringValue];
        [[[TPIEmojiGenerator sharedGenerator] overrideTable] setObject:emoji forKey:nickname];
        [[TPIEmojiGenerator sharedGenerator] removeNicknameFromCache:nickname];
        [self.overrideTableView reloadData];
        [self.playgroundNicknameField setStringValue:@""];
        [self.playgroundEmojiField setStringValue:@""];
    }
}

- (IBAction)removeOverrideButtonClicked:(id)sender {
    NSIndexSet *selectedRows = [self.overrideTableView selectedRowIndexes];
    if ([selectedRows count] > 0) {
        NSArray *rowKeys = [[[TPIEmojiGenerator sharedGenerator] overrideTable] sortedDictionaryKeys];
        [selectedRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
            NSString *key = [rowKeys objectAtIndex:idx];
            [[[TPIEmojiGenerator sharedGenerator] overrideTable] removeObjectForKey:key];
            [[TPIEmojiGenerator sharedGenerator] removeNicknameFromCache:key];
        }];
        [self.overrideTableView reloadData];
    }
}

- (NSView *)pluginPreferencesPaneView {
    return self.preferencesPane;
}

- (NSString *)pluginPreferencesPaneMenuItemName {
    return @"Emoji Prefixes";
}

- (void)controlTextDidChange:(NSNotification *)obj {
    NSMutableString *nickname = [[self.playgroundNicknameField stringValue] mutableCopy];
    [nickname replaceOccurrencesOfString:@"[ ]+"
                              withString:@""
                                 options:NSRegularExpressionSearch
                                   range:NSMakeRange(0, [nickname length])];
    if ([nickname length] > 0) {
        NSString *emoji = [[TPIEmojiGenerator sharedGenerator] getEmojiForNickname:nickname];
        [self.playgroundEmojiField setStringValue:emoji];
    } else {
        [self.playgroundEmojiField setStringValue:@""];
    }
    [self.playgroundNicknameField setStringValue:nickname];
}

@end

@implementation TVCLogLine (EmojiPrefixes)

+ (void) load {
    XRExchangeImplementation(@"TVCLogLine", @"formattedNickname:", @"prefix_emoji_formattedNickname:");
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

@implementation TVCMemberListCell (EmojiPrefixes)

+ (void) load {
    XRExchangeImplementation(@"TVCMemberListCell", @"updateDrawing:", @"prefix_emoji_updateDrawing:");
}

- (void)prefix_emoji_updateDrawing:(id)interfaceObject {
    [self prefix_emoji_updateDrawing:interfaceObject];

    NSString *nickname = [[self memberPointer] nickname];
    NSString *emoji = [[TPIEmojiGenerator sharedGenerator] getEmojiForNickname:nickname];
    
    NSTextField *textField = [self cellTextField];
    NSMutableAttributedString *label = [[textField attributedStringValue] mutableCopy];
    NSMutableString *labelString = [label mutableString];
    [labelString replaceOccurrencesOfString:nickname
                                 withString:[NSString stringWithFormat:@"%@ %@", emoji, nickname]
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [labelString length])];
    [textField setAttributedStringValue:label];
}

@end

