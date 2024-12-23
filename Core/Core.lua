-- This will get a handle endpos the BetterBags addon.
---@class BetterBags: AceAddon
local addon = LibStub('AceAddon-3.0'):GetAddon("BetterBags")

-- This will get a handle endpos the Categories module, which exposes
-- the API for creating categories.
---@class Categories: AceModule
local categories = addon:GetModule('Categories')

---@class Config: AceModule
local config = addon:GetModule('Config')

---@class Events: AceModule
local events = addon:GetModule('Events')

---@class Context: AceModule
local context = addon:GetModule('Context')

---@class Localization: AceModule
local L = addon:GetModule('Localization')

---@class GearTracks: AceModule
local geartracks = addon:NewModule('GearTracks')

---@class Context: AceModule
local ctx = context:New('BetterBags_GearTracks Create Category')

local qTWWS1Exp =
"bonusid=10289 or bonusid=10288 or bonusid=10287 or bonusid=10286 or bonusid=10285 or bonusid=10284 or bonusid=10283 or bonusid=10282"
local qTWWS1Adv =
"bonusid=10297 or bonusid=10296 or bonusid=10295 or bonusid=10294 or bonusid=10293 or bonusid=10292 or bonusid=10291 or bonusid=10290"
local qTWWS1Vet =
"bonusid=10281 or bonusid=10280 or bonusid=10279 or bonusid=10278 or bonusid=10277 or bonusid=10276 or bonusid=10275 or bonusid=10274"
local qTWWS1Champ =
"bonusid=10273 or bonusid=10272 or bonusid=10271 or bonusid=10270 or bonusid=10269 or bonusid=10268 or bonusid=10267 or bonusid=10266"
local qTWWS1Hero = "bonusid=10265 or bonusid=10264 or bonusid=10263 or bonusid=10262 or bonusid=10261 or bonusid=10256"
local qTWWS1Myth = "bonusid=10260 or bonusid=10250 or bonusid=10258 or bonusid=10257 or bonusid=10298 or bonusid=10299"

local qTWWCrafted = "bonusid=9623 or bonusid=9624 or bonusid=9625 or bonusid=9626 or bonusid=9627"
local qTWWS1Crafted = "bonusid=10222"
-- All Upgradeable TWWS1 gear
local qTWWS1UpAll = qTWWS1Exp .. " or " .. qTWWS1Adv .. " or " .. qTWWS1Vet .. " or " .. qTWWS1Champ .. " or " .. qTWWS1Hero .. " or " .. qTWWS1Myth
local qTWWS1PvP639 = "bonusid=11086"
local qTWWS1PvP636 = "bonusid=11141"
local qTWWS1PvP626 = "bonusid=11140 or bonusid=11084"
local qTWWS1PvP613 = "bonusid=10840"
--- All TWWS1 PvP gear
local qTWWS1Low = qTWWS1Exp .. " or " .. qTWWS1Adv .. " or " .. qTWWS1Vet
local qTWWS1PvPAll = qTWWS1PvP639 .. " or " .. qTWWS1PvP636 .. " or " .. qTWWS1PvP626 .. " or " .. qTWWS1PvP613
local qTWWS1PvP = qTWWS1PvP613 .. " or " .. qTWWS1PvP626 .. " or " .. qTWWS1PvP639 
-- Reusable category creation wrapper
local function createCategoryWrapper(ctx, options)
  ---@class CreateCategoryOptions:CategoryOptions
  local defaultOptions = {
    itemList = {},
    name = L:G("Default Category"),
    note = L:G("No note provided"),
    priority = 1,
    save = false,
    searchCategory = nil,
  }

  for key, value in pairs(defaultOptions) do
    if options[key] == nil then
      options[key] = value
    end
  end

  categories:CreateCategory(ctx, {
    name = options.name,
    itemList = options.itemList,
    save = options.save,
    searchCategory = options.searchCategory,
    note = options.note,
    priority = options.priority,
  })
end
-- Wrapper function to create a callback dynamically
local function ConfigEntry(name, ParentContext, query, priority)
  return {
    type = "execute",
    name = name,
    func = function()
      -- Call the category creation wrapper
      local dynamicContext = ParentContext:New(name)
      createCategoryWrapper(dynamicContext, {
        name = L:G(name),
        save = true,
        searchCategory = {
          query = query,
        },
        note = L:G("Created by BetterBags_GearTracks"),
        priority = priority,
      })

      -- Send the refresh event
      events:SendMessage(dynamicContext, 'bags/FullRefreshAll')
    end,
  }
end




---@class AceConfig.OptionsTable
local gearTracksConfigOptions = {
  header = {
    type = "description",
    name = "BetterBags_GearTracks lets you instantly create categories to group gear by expansion, track, or Season.",
  },
  splash = {
    type = "header",
    name = "BetterBags_GearTracks",
  },
  wwseason1Entry=ConfigEntry("TWWS1 Upgrade", ctx, qTWWS1UpAll, 10),
  wwseason1expEntry=ConfigEntry("TWWS1 Exp", ctx, qTWWS1Exp, 10),
  wwseason1advEntry=ConfigEntry("TWWS1 Adv", ctx, qTWWS1Adv, 10),
  wwseason1vetEntry=ConfigEntry("TWWS1 Veteran", ctx, qTWWS1Vet, 10),
  wwseason1lowEntry=ConfigEntry("TWWS1 Low", ctx, qTWWS1Low, 10),
  wwseason1champEntry=ConfigEntry("TWWS1 Champ", ctx, qTWWS1Champ, 10),
  wwseason1heroEntry=ConfigEntry("TWWS1 Hero", ctx, qTWWS1Hero, 10),
  wwseason1mythEntry=ConfigEntry("TWWS1 Myth", ctx, qTWWS1Myth, 10),
  -- wwcraftedEntry=ConfigEntry("TWW Crafted", ctx, qTWWCrafted, 10),
  wwS1craftedEntry=ConfigEntry("TWWS1 Crafted", ctx, qTWWS1Crafted, 10),
  wwS1PvPEntry=ConfigEntry("TWWS1 PvP All", ctx, qTWWS1PvPAll, 9),
  wwS1PvP613Entry=ConfigEntry("TWWS1 PvP Green", ctx, qTWWS1PvP613, 9),
  wwS1PvP626Entry=ConfigEntry("TWWS1 PvP Blue", ctx, qTWWS1PvP626, 9),
  wwS1PvP639Entry=ConfigEntry("TWWS1 PvP Max", ctx, qTWWS1PvP639, 9),

  -- wwseason1 = {
  --   type = "execute",
  --   name = "TWWS1",
  --   func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1"), itemList={}, save = true,
  --     searchCategory = {
  --       query = qTWWS1Exp.." or "..qTWWS1Adv.." or "..qTWWS1Vet.." or "..qTWWS1Champ.." or "..qTWWS1Hero.." or "..qTWWS1Myth,
  --     },
  --     note = L:G("Created by BetterBags_GearTracks"),
  --     priority = 10,} )
  --     events:SendMessage(ctx, 'bags/FullRefreshAll')
  --   end,
  -- },
--   wwseason1exp = {
--     type = "execute",
--     name = "TWWS1 Exp",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 Exp"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1Exp,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwseason1adv = {
--     type = "execute",
--     name = "TWWS1 Adv",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 Adv"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1Adv,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwseason1vet = {
--     type = "execute",
--     name = "TWWS1 Veteran",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 Veteran"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1Vet,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwseason1champ = {
--     type = "execute",
--     name = "TWWS1 Champ",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 Champ"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1Champ,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwseason1hero = {
--     type = "execute",
--     name = "TWWS1 Hero",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 Hero"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1Hero,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwseason1myth = {
--     type = "execute",
--     name = "TWWS1 Myth",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 Myth"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1Myth,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwcrafted = {
--     type = "execute",
--     name = "TWW Crafted",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWW Crafted"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWCrafted,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwS1crafted = {
--     type = "execute",
--     name = "TWWS1 Crafted",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 Crafted"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1Crafted,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwS1PvP = {
--     type = "execute",
--     name = "TWWS1 PvP All",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 PvP All"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1PvPAll,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwS1PvP613 = {
--     type = "execute",
--     name = "TWWS1 PvP",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 PvP Green "), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1PvP613,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwS1PvP626 = {
--     type = "execute",
--     name = "TWWS1 PvP Blue",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 PvP Blue"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1PvP626.. "or"..qTWWS1PvP636,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
--   wwS1PvP639 = {
--     type = "execute",
--     name = "TWWS1 PvP Max",
--     func = function () categories:CreateCategory(ctx,  { name = L:G("TWWS1 PvP Max"), itemList={}, save = true,
--       searchCategory = {
--         query = qTWWS1PvP639,
--       },
--       note = L:G("Created by BetterBags_GearTracks"),
--       priority = 10,} )
--       events:SendMessage(ctx, 'bags/FullRefreshAll')
--     end,
--   },
}


if (config.AddPluginConfig) then
  config:AddPluginConfig("Gear Tracks", gearTracksConfigOptions)
else
  print("BetterBags_GearTracks NOT loaded. Betterbags Plugin API Incompatible.")
end
