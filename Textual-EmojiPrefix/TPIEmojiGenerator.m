//
//  TPIEmojiGenerator.m
//  Textual-EmojiPrefix
//
//  Created by Aleksandr Pasechnik on 11/23/15
//  Copyright © 2015 Aleksandr Pasechnik. All rights reserved.
//

#import "TPIEmojiGenerator.h"

#import "TextualApplication.h"

#import <CommonCrypto/CommonDigest.h>

@implementation TPIEmojiGenerator

static TPIEmojiGenerator *_sharedGenerator;

static NSString * const _emojiString = @"😀 😁 😂 😃 😄 😅 😆 😇 😈 👿 😉 😊 ☺️ 😋 😌 😍 😎 😏 😐 😑 😒 😓 😔 😕 😖 😗 😘 😙 😚 😛 😜 😝 😞 😟 😠 😡 😢 😣 😤 😥 😦 😧 😨 😩 😪 😫 😬 😭 😮 😯 😰 😱 😲 😳 😴 😵 😶 😷 😸 😹 😺 😻 😼 😽 😾 😿 🙀 👣 👤 👥 👶 👦 👧 👨 👩 👯 👰 👱 👲 👳 👴 👵 👮 👷 👸 💂 👼 🎅 👻 👹 👺 💩 💀 👽 👾 🙇 🙌 👏 👂 👀 👃 👄 💋 👅 👋 👍🏻 👎 ☝️ 👆 👇 👈 👉 👌 ✌️ 👊 ✊ ✋ 💪 👐 🙏 🌱 🌲 🌳 🌴 🌵 🌷 🌸 🌹 🌺 🌻 🌼 💐 🌾 🌿 🍀 🍁 🍂 🍃 🍄 🌰 🐀 🐁 🐭 🐹 🐂 🐃 🐄 🐮 🐅 🐆 🐯 🐇 🐰 🐈 🐱 🐎 🐴 🐏 🐑 🐐 🐓 🐔 🐤 🐣 🐥 🐦 🐧 🐘 🐪 🐫 🐗 🐖 🐷 🐽 🐕 🐩 🐶 🐺 🐻 🐨 🐼 🐵 🙈 🙉 🙊 🐒 🐉 🐲 🐊 🐍 🐢 🐸 🐋 🐳 🐬 🐙 🐟 🐠 🐡 🐚 🐌 🐛 🐜 🐝 🐞 🐾 ⚡️ 🔥 🌙 ☀️ ⛅️ ☁️ 💧 💦 ☔️ 💨 ❄️ 🌟 ⭐️ 🌠 🌄 🌅 🌈 🌊 🌋 🌌 🗻 🗾 🌐 🌍 🌎 🌏 🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘 🌚 🌝 🌛 🌜 🌞 🍅 🍆 🌽 🍠 🍇 🍈 🍉 🍊 🍋 🍌 🍍 🍎 🍏 🍐 🍑 🍒 🍓 🍔 🍕 🍖 🍗 🍘 🍙 🍚 🍛 🍜 🍝 🍞 🍟 🍡 🍢 🍣 🍤 🍥 🍦 🍧 🍨 🍩 🍪 🍫 🍬 🍭 🍮 🍯 🍰 🍱 🍲 🍳 🍴 🍵 ☕️ 🍶 🍷 🍸 🍹 🍺 🍻 🍼 🎀 🎁 🎂 🎃 🎄 🎋 🎍 🎑 🎆 🎇 🎉 🎊 🎈 💫 ✨ 💥 🎓 👑 🎎 🎏 🎐 🎌 🏮 💍 ❤️ 💔 💌 💕 💞 💓 💗 💖 💘 💝 💟 💜 💛 💚 💙 🏃 🚶 💃 🚣 🏊 🏄 🏂 🎿 ⛄️ 🚴 🚵 🏇 ⛺️ 🎣 ⚽️ 🏀 🏈 ⚾️ 🎾 🏉 ⛳️ 🏆 🎽 🏁 🎹 🎸 🎻 🎷 🎺 🎵 🎶 🎼 🎧 🎤 🎭 🎫 🎩 🎪 🎬 🎨 🎯 🎱 🎳 🎰 🎲 🎮 🎴 🃏 🀄️ 🎠 🎡 🎢 🚃 🚞 🚂 🚋 🚝 🚄 🚅 🚆 🚇 🚈 🚉 🚊 🚌 🚍 🚎 🚐 🚑 🚒 🚓 🚔 🚨 🚕 🚖 🚗 🚘 🚙 🚚 🚛 🚜 🚲 🚏 ⛽️ 🚧 🚦 🚥 🚀 🚁 ✈️ 💺 ⚓️ 🚢 🚤 ⛵️ 🚡 🚠 🚟 🛂 🛃 🛄 🛅 💴 💶 💷 💵 🗽 🗿 🌁 🗼 ⛲️ 🏰 🏯 🌇 🌆 🌃 🌉 🏠 🏡 🏢 🏬 🏭 🏣 🏤 🏥 🏦 🏨 🏩 💒 ⛪️ 🏪 🏫 🇦🇺 🇦🇹 🇧🇪 🇧🇷 🇨🇦 🇨🇱 🇨🇳 🇨🇴 🇩🇰 🇫🇮 🇫🇷 🇩🇪 🇭🇰 🇮🇳 🇮🇩 🇮🇪 🇮🇱 🇮🇹 🇯🇵 🇰🇷 🇲🇴 🇲🇾 🇲🇽 🇳🇱 🇳🇿 🇳🇴 🇵🇭 🇵🇱 🇵🇹 🇵🇷 🇷🇺 🇸🇦 🇸🇬 🇿🇦 🇪🇸 🇸🇪 🇨🇭 🇹🇷 🇬🇧 🇺🇸 🇦🇪 🇻🇳 ⌚️ 📱 📲 💻 ⏰ ⏳ ⌛️ 📷 📹 🎥 📺 📻 📟 📞 ☎️ 📠 💽 💾 💿 📀 📼 🔋 🔌 💡 🔦 📡 💳 💸 💰 💎 🌂 👝 👛 👜 💼 🎒 💄 👓 👒 👡 👠 👢 👞 👟 👙 👗 👘 👚 👕 👔 👖 🚪 🚿 🛁 🚽 💈 💉 💊 🔬 🔭 🔮 🔧 🔪 🔩 🔨 💣 🚬 🔫 🔖 📰 🔑 ✉️ 📩 📨 📧 📥 📤 📦 📯 📮 📪 📫 📬 📭 📄 📃 📑 📈 📉 📊 📅 📆 🔅 🔆 📜 📋 📖 📓 📔 📒 📕 📗 📘 📙 📚 📇 🔗 📎 📌 ✂️ 📐 📍 📏 🚩 📁 📂 ✒️ ✏️ 📝 🔏 🔒 🔓 📣 📢 🔈 🔉 🔊 🔇 💤 🔔 🔕 💭 💬 🚸 🔍 🔎 🚫 ⛔️ 📛 🚷 🚯 🚳 🚱 📵 🔞 ❇️ ✳️ ❎ ✅ ✴️ 📳 🆚 🅰 🅱 🆎 🆑 🅾 🆘 🆔 🅿️ 🚾 🆒 🆓 🆕 🆖 🆗 🆙 🏧 ♈️ ♉️ ♊️ ♋️ ♌️ ♍️ ♎️ ♏️ ♐️ ♑️ ♒️ ♓️ 🚻 🚹 🚺 🚼 ♿️ 🚰 🚭 🚮 ▶️ ◀️ 🔼 🔽 ⏩ ⏪ ⏫ ⏬ ➡️ ⬅️ ⬆️ ⬇️ ↗️ ↘️ ↙️ ↖️ ↕️ ↔️ 🔄 ↪️ ↩️ ⤴️ ⤵️ 🔀 🔁 🔂 #️⃣ 0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟 🔢 🔤 🔡 🔠 ℹ️ 📶 🎦 🔣 ➿ 〽️ ❗️ ❓ ‼️ ⁉️ ❌ ⭕️ 💯 🌀 Ⓜ️ ⛎ 🔯 🔰 🔱 ⚠️ ♨️ ♻️ 💢 💠 ♥️ ♦️ ☑️ ⚪️ ⚫️ 🔘 🔴 🔵 🔺 🔻 🔸 🔹 🔶 🔷";

NSArray *_emojiArray;

NSMutableDictionary *_emojiCache;

+ (void)initialize {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        _sharedGenerator = [[TPIEmojiGenerator alloc] init];
    }
}

+ (TPIEmojiGenerator *)sharedGenerator {
    return _sharedGenerator;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _emojiArray = [NSArray arrayWithArray:[_emojiString componentsSeparatedByString:@" "]];
        _emojiCache = [[NSMutableDictionary alloc] init];
        self.overrideTable = [[NSMutableDictionary alloc] init];
        self.messageSenderEmojiPosition = TPIEmojiMessageSenderPositionPrefix;
    }
    return self;
}

- (void)removeNicknameFromCache:(NSString *)nickname {
    NSArray *keys = [_emojiCache sortedDictionaryKeys];
    NSString *preprocessedNickname = [self preprocessNicknameString:nickname];
    for (NSString* key in keys) {
        if ([[self preprocessNicknameString:key] isEqualToString:preprocessedNickname]) {
            [_emojiCache removeObjectForKey:key];
        }
    }
}

- (NSString *)preprocessNicknameString:(NSString *)nickname {
    // adapted from IRC/IRCUser.m hashForString:colorStyle
    // also adapted from Styles/Equinox/scripts.js
    // backticks, underscores, and dashes at the beginning and end, and everything after a pipe, replaced by empty strings
    return [[nickname lowercaseString] stringByReplacingOccurrencesOfString:@"(^[`_-]+)|([`_-]+$)|(\\|.*$)"
                                                                 withString:@""
                                                                    options:NSRegularExpressionSearch
                                                                      range:NSMakeRange(0, [nickname length])];
}

- (NSString *)getEmojiForNickname:(NSString *)nickname {
    NSString *cachedEmoji = [_emojiCache objectForKey:nickname];
    if (cachedEmoji != nil) {
        return cachedEmoji;
    }
    
    NSString *stringToHash = [self preprocessNicknameString:nickname];
    
    NSString *emoji = [self.overrideTable objectForKey:stringToHash];
    
    if (emoji == nil) {
        NSData *stringToHashData = [stringToHash dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *hashedData = [NSMutableData dataWithLength:CC_MD5_DIGEST_LENGTH];
        CC_MD5([stringToHashData bytes], (CC_LONG)[stringToHashData length], [hashedData mutableBytes]);
        unsigned int hashedValue;
        [hashedData getBytes:&hashedValue length:sizeof(unsigned int)];
        emoji = [_emojiArray objectAtIndex:(hashedValue % [_emojiArray count])];
    }
    
    [_emojiCache setObject:emoji forKey:nickname];
    
    return emoji;
}

@end
