Over 70 years history⁉️ What a long history! 🤔

> 🔖 Page 2 - QuickStart: Common Regex with long history

A common regex pattern is made up of a combination of characters and operators that define the search criteria. 🔍🧑‍💻 

let's look at the regex pattern in the TextField.

```regex
/(CREDIT|DEBIT)\s+(\d{1,2}\/\d{1,2}\/\d{4})/
```

## 1⃣️ Part

1. Regex is surrounded by two forward slashes `/.../`
2. `(CREDIT|DEBIT)` means either CREDIT or DEBIT, divided by `|`
3. `\s` means space
4. `\s+` means one or more spaces

So the first part of the regex pattern (CREDIT|DEBIT)\s+ is either CREDIT or DEBIT, followed by one or more spaces.

## 2⃣️ Part

The second part of the regex pattern \d{1,2}\/\d{1,2}\/\d{4} is a date in the format of MM/DD/YYYY

1. \d means digit
2. {1,2} means one or two digits
3. \/ means slash, slash is a special character in regex, so it needs to be escaped with a backslash
4. \d{4} means four digits

As you can see in the regex result area in the right bottom corner, the regex pattern is matched with the string "CREDIT 03/01/2022" and "DEBIT 03/05/2022".

## 3⃣️ Part

I know you're very tired 🥱 after reading the long materials, so let's do something magical. 

3⃣️-1⃣️Tap the text field in the top ⬆️, you will see two buttons above the screen keyboard. Let's try to extract full line of credit line by tapping the CREDIT💳 button.

Wow, you've extract the CREDIT lines successfully in long tedious text with magic regex! 🎉

3⃣️-2⃣️let's try to extract full line of debit line by tapping the DEBIT🏦 button.

Congratulations! You've extract the DEBIT lines successfully! 🎉

4⃣️ Part

You've probably noticed the magic word dot and asterisk in the regex pattern.

- `.` dot to match any character 
- `*` asterisk to match zero or more occurrences of the preceding character
- `?` question mark to match zero or one occurrence of the preceding character

❓ What's next

Common Regex is very hard to study and read, right? Tap the next page ⬅️➡️ button above ⬆️ or select the next page from the sidebar 📑. Let's dive into Swift DSL(Domain Specific Language) with RegexBuilder. 🚀 Press next and you will see a video to help you learn how to use RegexBuilder.
