//
//  TPIEmojiPrefixPrincipalClass.m
//  Textual-EmojiPrefix
//
//  Created by Aleksandr Pasechnik on 11/22/15Su.
//  Copyright © 2015 Megamicron. All rights reserved.
//

#import "TPIEmojiPrefixPrincipalClass.h"

#import <objc/runtime.h>

#import <CommonCrypto/CommonDigest.h>

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

NSString * const _emojiString = @"😀 😁 😂 😃 😄 😅 😆 😇 😈 👿 😉 😊 ☺️ 😋 😌 😍 😎 😏 😐 😑 😒 😓 😔 😕 😖 😗 😘 😙 😚 😛 😜 😝 😞 😟 😠 😡 😢 😣 😤 😥 😦 😧 😨 😩 😪 😫 😬 😭 😮 😯 😰 😱 😲 😳 😴 😵 😶 😷 😸 😹 😺 😻 😼 😽 😾 😿 🙀 👣 👤 👥 👶 👦 👧 👨 👩 👯 👰 👱 👲 👳 👴 👵 👮 👷 👸 💂 👼 🎅 👻 👹 👺 💩 💀 👽 👾 🙇 🙌 👏 👂 👀 👃 👄 💋 👅 👋 👍🏻 👎 ☝️ 👆 👇 👈 👉 👌 ✌️ 👊 ✊ ✋ 💪 👐 🙏 🌱 🌲 🌳 🌴 🌵 🌷 🌸 🌹 🌺 🌻 🌼 💐 🌾 🌿 🍀 🍁 🍂 🍃 🍄 🌰 🐀 🐁 🐭 🐹 🐂 🐃 🐄 🐮 🐅 🐆 🐯 🐇 🐰 🐈 🐱 🐎 🐴 🐏 🐑 🐐 🐓 🐔 🐤 🐣 🐥 🐦 🐧 🐘 🐪 🐫 🐗 🐖 🐷 🐽 🐕 🐩 🐶 🐺 🐻 🐨 🐼 🐵 🙈 🙉 🙊 🐒 🐉 🐲 🐊 🐍 🐢 🐸 🐋 🐳 🐬 🐙 🐟 🐠 🐡 🐚 🐌 🐛 🐜 🐝 🐞 🐾 ⚡️ 🔥 🌙 ☀️ ⛅️ ☁️ 💧 💦 ☔️ 💨 ❄️ 🌟 ⭐️ 🌠 🌄 🌅 🌈 🌊 🌋 🌌 🗻 🗾 🌐 🌍 🌎 🌏 🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘 🌚 🌝 🌛 🌜 🌞 🍅 🍆 🌽 🍠 🍇 🍈 🍉 🍊 🍋 🍌 🍍 🍎 🍏 🍐 🍑 🍒 🍓 🍔 🍕 🍖 🍗 🍘 🍙 🍚 🍛 🍜 🍝 🍞 🍟 🍡 🍢 🍣 🍤 🍥 🍦 🍧 🍨 🍩 🍪 🍫 🍬 🍭 🍮 🍯 🍰 🍱 🍲 🍳 🍴 🍵 ☕️ 🍶 🍷 🍸 🍹 🍺 🍻 🍼 🎀 🎁 🎂 🎃 🎄 🎋 🎍 🎑 🎆 🎇 🎉 🎊 🎈 💫 ✨ 💥 🎓 👑 🎎 🎏 🎐 🎌 🏮 💍 ❤️ 💔 💌 💕 💞 💓 💗 💖 💘 💝 💟 💜 💛 💚 💙 🏃 🚶 💃 🚣 🏊 🏄 🏂 🎿 ⛄️ 🚴 🚵 🏇 ⛺️ 🎣 ⚽️ 🏀 🏈 ⚾️ 🎾 🏉 ⛳️ 🏆 🎽 🏁 🎹 🎸 🎻 🎷 🎺 🎵 🎶 🎼 🎧 🎤 🎭 🎫 🎩 🎪 🎬 🎨 🎯 🎱 🎳 🎰 🎲 🎮 🎴 🃏 🀄️ 🎠 🎡 🎢 🚃 🚞 🚂 🚋 🚝 🚄 🚅 🚆 🚇 🚈 🚉 🚊 🚌 🚍 🚎 🚐 🚑 🚒 🚓 🚔 🚨 🚕 🚖 🚗 🚘 🚙 🚚 🚛 🚜 🚲 🚏 ⛽️ 🚧 🚦 🚥 🚀 🚁 ✈️ 💺 ⚓️ 🚢 🚤 ⛵️ 🚡 🚠 🚟 🛂 🛃 🛄 🛅 💴 💶 💷 💵 🗽 🗿 🌁 🗼 ⛲️ 🏰 🏯 🌇 🌆 🌃 🌉 🏠 🏡 🏢 🏬 🏭 🏣 🏤 🏥 🏦 🏨 🏩 💒 ⛪️ 🏪 🏫 🇦🇺 🇦🇹 🇧🇪 🇧🇷 🇨🇦 🇨🇱 🇨🇳 🇨🇴 🇩🇰 🇫🇮 🇫🇷 🇩🇪 🇭🇰 🇮🇳 🇮🇩 🇮🇪 🇮🇱 🇮🇹 🇯🇵 🇰🇷 🇲🇴 🇲🇾 🇲🇽 🇳🇱 🇳🇿 🇳🇴 🇵🇭 🇵🇱 🇵🇹 🇵🇷 🇷🇺 🇸🇦 🇸🇬 🇿🇦 🇪🇸 🇸🇪 🇨🇭 🇹🇷 🇬🇧 🇺🇸 🇦🇪 🇻🇳 ⌚️ 📱 📲 💻 ⏰ ⏳ ⌛️ 📷 📹 🎥 📺 📻 📟 📞 ☎️ 📠 💽 💾 💿 📀 📼 🔋 🔌 💡 🔦 📡 💳 💸 💰 💎 🌂 👝 👛 👜 💼 🎒 💄 👓 👒 👡 👠 👢 👞 👟 👙 👗 👘 👚 👕 👔 👖 🚪 🚿 🛁 🚽 💈 💉 💊 🔬 🔭 🔮 🔧 🔪 🔩 🔨 💣 🚬 🔫 🔖 📰 🔑 ✉️ 📩 📨 📧 📥 📤 📦 📯 📮 📪 📫 📬 📭 📄 📃 📑 📈 📉 📊 📅 📆 🔅 🔆 📜 📋 📖 📓 📔 📒 📕 📗 📘 📙 📚 📇 🔗 📎 📌 ✂️ 📐 📍 📏 🚩 📁 📂 ✒️ ✏️ 📝 🔏 🔒 🔓 📣 📢 🔈 🔉 🔊 🔇 💤 🔔 🔕 💭 💬 🚸 🔍 🔎 🚫 ⛔️ 📛 🚷 🚯 🚳 🚱 📵 🔞 ❇️ ✳️ ❎ ✅ ✴️ 📳 🆚 🅰 🅱 🆎 🆑 🅾 🆘 🆔 🅿️ 🚾 🆒 🆓 🆕 🆖 🆗 🆙 🏧 ♈️ ♉️ ♊️ ♋️ ♌️ ♍️ ♎️ ♏️ ♐️ ♑️ ♒️ ♓️ 🚻 🚹 🚺 🚼 ♿️ 🚰 🚭 🚮 ▶️ ◀️ 🔼 🔽 ⏩ ⏪ ⏫ ⏬ ➡️ ⬅️ ⬆️ ⬇️ ↗️ ↘️ ↙️ ↖️ ↕️ ↔️ 🔄 ↪️ ↩️ ⤴️ ⤵️ 🔀 🔁 🔂 #️⃣ 0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟 🔢 🔤 🔡 🔠 ℹ️ 📶 🎦 🔣 ➿ 〽️ ❗️ ❓ ‼️ ⁉️ ❌ ⭕️ 💯 🌀 Ⓜ️ ⛎ 🔯 🔰 🔱 ⚠️ ♨️ ♻️ 💢 💠 ♥️ ♦️ ☑️ ⚪️ ⚫️ 🔘 🔴 🔵 🔺 🔻 🔸 🔹 🔶 🔷";

- (NSString *)prefix_emoji_formattedNickname:(IRCChannel *) owner {
    NSString *original = [self prefix_emoji_formattedNickname:owner];
    
    // adapted from IRC/IRCUser.m hashForString:colorStyle
    // also adapted from Styles/Equinox/scripts.js
    NSString *lowerNick = [self.nickname lowercaseString];
    NSString *noTrailingJunk = [lowerNick stringByReplacingOccurrencesOfString:@"[`_-]+$"
                                                                    withString:@""
                                                                       options:NSRegularExpressionSearch
                                                                         range:NSMakeRange(0, [lowerNick length])];
    NSString *noLeadingJunk = [noTrailingJunk stringByReplacingOccurrencesOfString:@"^[`_-]+"
                                                                        withString:@""
                                                                           options:NSRegularExpressionSearch
                                                                             range:NSMakeRange(0, [noTrailingJunk length])];
    NSString *stringToHash = [noLeadingJunk stringByReplacingOccurrencesOfString:@"|.*$"
                                                                       withString:@""
                                                                          options:NSRegularExpressionSearch
                                                                            range:NSMakeRange(0, [noLeadingJunk length])];
    
    NSData *stringToHashData = [stringToHash dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *hashedData = [NSMutableData dataWithLength:CC_MD5_DIGEST_LENGTH];
    CC_MD5([stringToHashData bytes], (CC_LONG)[stringToHashData length], [hashedData mutableBytes]);
    unsigned int hashedValue;
    [hashedData getBytes:&hashedValue length:sizeof(unsigned int)];
    NSArray *emoji = [_emojiString componentsSeparatedByString:@" "];
    NSUInteger i = hashedValue % [emoji count];
    
    return [NSString stringWithFormat:@"%@ %@", [emoji objectAtIndex:i], original];
}

@end