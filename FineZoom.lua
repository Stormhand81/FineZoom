-- =====================================================
-- FineZoom
-- Minimal fine camera zoom control for Vanilla / Turtle
-- =====================================================

-- Defaults
FineZoomStep   = FineZoomStep   or 0.2
FineZoomSilent = FineZoomSilent ~= false  -- default = true

local MIN_STEP = 0.05
local MAX_STEP = 5.0

local function Clamp(v)
  if v < MIN_STEP then return MIN_STEP end
  if v > MAX_STEP then return MAX_STEP end
  return v
end

local function Print(msg)
  if not FineZoomSilent then
    DEFAULT_CHAT_FRAME:AddMessage(msg)
  end
end

-- Normalize decimal separator (0,3 -> 0.3)
local function ParseNumber(msg)
  if not msg or msg == "" then return nil end
  msg = string.gsub(msg, ",", ".")
  return tonumber(msg)
end

-- /finezoom <value>
SLASH_FINEZOOM1 = "/finezoom"
SlashCmdList.FINEZOOM = function(msg)
  local v = ParseNumber(msg)
  if v then
    FineZoomStep = Clamp(v)
    DEFAULT_CHAT_FRAME:AddMessage(
      string.format("FineZoom: passo ajustado para %.2f", FineZoomStep)
    )
  else
    DEFAULT_CHAT_FRAME:AddMessage(
      "Uso: /finezoom <passo>  (ex.: /finezoom 0.5)"
    )
  end
end

-- Optional bind helper
SLASH_FINEZOOMBIND1 = "/fzbind"
SlashCmdList.FINEZOOMBIND = function()
  SetBinding("MOUSEWHEELUP",   "FINEZOOMIN")
  SetBinding("MOUSEWHEELDOWN", "FINEZOOMOUT")
  SaveBindings(GetCurrentBindingSet())
  DEFAULT_CHAT_FRAME:AddMessage("FineZoom: mouse wheel bindado.")
end

-- Login feedback (silent by default)
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
  Print(string.format("FineZoom carregado (passo %.2f)", FineZoomStep))
end)
