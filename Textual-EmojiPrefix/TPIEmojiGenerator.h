//
//  TPIEmojiGenerator.h
//  Textual-EmojiPrefix
//
//  Created by Aleksandr Pasechnik on 11/23/15
//  Copyright © 2015 Aleksandr Pasechnik. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    TPIEmojiMessageSenderPositionPrefix,
    TPIEmojiMessageSenderPositionSuffix,
} TPIEmojiMessageSenderPosition;

@interface TPIEmojiGenerator : NSObject {

}

@property (nonatomic, strong) NSMutableDictionary *overrideTable;
@property (nonatomic, assign) TPIEmojiMessageSenderPosition messageSenderEmojiPosition;

+ (TPIEmojiGenerator *) sharedGenerator;

- (void) removeNicknameFromCache:(NSString *)nickname;
- (NSString *) getEmojiForNickname:(NSString *)nickname;
- (NSString *) preprocessNicknameString:(NSString *)nickname;

@end
