# ClipTransform.spoon

A spoon (plugin) for [hammerspoon](https://www.hammerspoon.org) for quickly transforming the clipboard contents using scripts stored in a directory.

## Setup

1. Clone this repository inside of `~/.hammerspoon/Spoons`
2. Add `hs.loadSpoon("ClipTransform")` to your `init.lua`
3. Add a call to `ClipTransform.chooseAndTransform` on an appropriate trigger. For example, the following config would cause CMD+CTRL+V to display a fuzzy finder that has you select from scripts in the `~/.clip-transform` directory:

```lua
function clipTransform()
  spoon.ClipTransform.chooseAndTransform('~/.clip-transform')
end
hs.hotkey.bind("cmd+ctrl", "V", clipTransform)
```

## Usage

The `chooseAndTransform` function looks for every file in the given directory which has the executable by owner permission.
All such files are displayed in a fuzzy finder.
When you choose one, it will try to run the file in a shell, passing the clipboard contents as stdin, then saving stdout back to the clipboard.

Here's a simple example, assuming you've followed the Setup directions above.
Copy the following script into `~/.clip-transform/lowercase.py`, then run `chmod +x ~/.clip-transform/lowercase.py`.

```python
#!/usr/bin/env python

import sys

if __name__ == "__main__":
    for line in sys.stdin:
        print(line.lower(), end='')
```

Then copy A STRING WITH UPPERCASE LETTERS onto the clipboard.
Now, when you run CMD+CTRL+V, a fuzzy finder will appear and you can select `lowercase.py`.
Afterward, the clipboard will now contain a lowercased version of the string.

## License

This is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
