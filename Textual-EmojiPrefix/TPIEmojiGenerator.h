//
//  TPIEmojiGenerator.h
//  Textual-EmojiPrefix
//
//  Created by Aleksandr Pasechnik on 11/23/15Mo.
//  Copyright © 2015 Megamicron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPIEmojiGenerator : NSObject {
    
}

+ (TPIEmojiGenerator *) sharedGenerator;

- (NSString *) getEmojiForNickname:(NSString *)nickname;

@end
