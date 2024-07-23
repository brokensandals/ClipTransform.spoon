local obj = {}
obj.__index = obj

-- Metadata
obj.name = "ClipTransform"
obj.version = "0.0.1"
obj.author = "Jacob Williams <jacobaw@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"
obj.homepage = "https://github.com/brokensandals/ClipTransform.spoon"

--- ClipTransform.logger
--- Variable
--- An instance of hs.logger
obj.logger = hs.logger.new('ClipTransform', 'info')

--- ClipTransform.listExecutables(dir)
--- Function
--- Returns a list of filenames (not full paths) of executable files in the given directory.
function obj.listExecutables(dir)
  result = {}
  for file in hs.fs.dir(dir) do
    local path = dir .. "/" .. file
    local attrs = hs.fs.attributes(path)
    if attrs.mode == "file" and attrs.permissions:sub(3, 3) == "x" then
      result[#result + 1] = file
    end
  end
  return result
end

--- ClipTransform.transformVia(path)
--- Function
--- Passes the clipboard contents to the given executable and copies the output to the clipboard.
--- path is the path to the executable; name will be displayed in success/failure notifications.
function obj.transformVia(path, name)
  function taskCallback(exitCode, stdOut, stdErr)
    if exitCode == 0 then
      hs.pasteboard.setContents(stdOut)
      hs.notify.show(name, 'Done', stdOut)
    else
      hs.notify.show(name, 'Failed', stdErr)
    end
  end
  local task = hs.task.new("/bin/zsh", taskCallback, { "-lic", path })
  local input = hs.pasteboard.getContents()
  task:setInput(input)
  task:start()
end

--- ClipTransform.chooseAndTransform(dir)
--- Function
--- Shows a fuzzy finder for the user to select an executable from dir, then runs transformVia on it.
function obj.chooseAndTransform(dir)
  local choices = {}
  for index, name in ipairs(obj.listExecutables(dir)) do
    choices[index] = {
      text = name,
      index = index
    }
  end
  local chooser = hs.chooser.new(function(selected)
    local name = selected.text
    local path = dir .. "/" .. name
    obj.transformVia(path, name)
  end)
  chooser:choices(choices)
  chooser:placeholderText("transformer")
  chooser:show()
end

return obj
