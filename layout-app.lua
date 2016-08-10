local book = SILE.require("classes/book");
book:defineMaster({ id = "right", firstContentFrame = "content", frames = {
  content = {left = "2mm", right = "100%pw-2mm", top = "12mm", bottom = "100%ph-2mm" },
  runningHead = {left = "left(content)", right = "right(content)", top = "top(content)-10mm", bottom = "top(content)-2mm" },
  footnotes = {left = "left(content)", right = "right(content)", top = "0", height = "0" },
}})
book:defineMaster({ id = "left", firstContentFrame = "content", frames = {}})
book:loadPackage("twoside", { oddPageMaster = "right", evenPageMaster = "left" });
book:mirrorMaster("right", "left")
SILE.call("switch-master-one-page", {id="right"})

SILE.registerCommand("publicationpage:font", function(options, content)
  SILE.call("font", { family="Libertinus Serif", size="6.5pt", language="und" }, content)
end)

SILE.registerCommand("meta:distribution", function(options, content)
  SILE.call("font", { weight=600, style="Bold" }, {"Yayın: "})
  SILE.typesetter:typeset("Bu PDF biçimi, akıl telefon cihazlar için uygun biçimlemiştir ve Fetiye Halk Kilise’nin hazırladığı Kilise Uygulaması içinde ve Via Christus’un internet sitesinde izinle üçretsiz yayılmaktadır.")
end)

-- Mobile device PDF readers don't need blank even numbered pages ;)
SILE.registerCommand("open-double-page", function()
  SILE.typesetter:leaveHmode();
  SILE.Commands["supereject"]();
  SILE.typesetter:leaveHmode();
end)

-- Forgo bottom of page layouts for mobile devices
SILE.registerCommand("topfill", function(options, content)
end)

-- Kindle sepia background: #e9d8ba
-- Kindle sepia text color: #5a4129
local inkColor = SILE.colorparser("#5a4129")
SILE.outputter:pushColor(inkColor)

local outputBackground = function()
  local page = SILE.getFrame("page")
  local backgroundColor = SILE.colorparser("#e9d8ba")
  SILE.outputter:pushColor(backgroundColor)
  SILE.outputter.rule(page:left(), page:top(), page:right(), page:bottom())
  SILE.outputter:popColor()
end

-- By this point, the first page is already initialized so give it some color
outputBackground()

-- Replace the new page function with one that draws a background first thing
local oldNewPage = book.newPage
book.newPage = function(self)
  local page = oldNewPage(self)
  outputBackground()
  return page
end
