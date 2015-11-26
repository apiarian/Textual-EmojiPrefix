# Textual-EmojiPrefix

![Screenshot](/apiarian/Textual-EmojiPrefix/raw/master/Textual-EmojiPrefix-Screenshot.png?raw=true "Screenshot")

A plugin for the Textual IRC client. https://www.codeux.com/textual/

Prifix nicknames with emoji. Or any other character you want. The default implementation does stick to emoji, though.

The nickname is first transformed to lowercase characters. Cruft is then removed from the nickname (leading and trailing backticks, dashes, and underscores; and anything after and including the last pipe '|'). The resulting text is md5 hashed. A number based on this hash is used to index into an array of prefixes. The array contains a whole bunch of emoji.

The emoji associated with a nickname is inserted before (or after, it's configurable) the message sender nickname, before any inline mentioned nicks, and before the nicknames in the user list.

The preferences pane can be used to override the default emoji for specific nicknames. Enter a nickname into the Playground Nickname field, tab into the emoji field and put in a new character. The emoji character entry view can be accessed by the OS X standard shortcut Command-Control-Space. The processed form of the nickname is stored in the override table, along with the override emoji.

The prefix does not have to be an emoji, or even a single character. Any text that OS X can display can be used as a prefix.

# Installation Instructions
* Make sure Textual is in /Applications/Textual.app
* Clone the project
* Open the project in Xcode
* Build the project
* The plugin bundle should have been copied to the current user's Textual Extensions directory by the Run Script Build Phase
* Relaunch Textual

# To Do
* Add all of the skin tone variations to emoji that support them.
