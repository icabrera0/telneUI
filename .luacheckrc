-- luacheck configuration for telneUI WoW addon

globals = {
    -- Addon globals
    "telneUI",
    "telneUISavedVars",
    -- Slash command globals (set dynamically in Core.lua)
    "SLASH_TELNEUI1",
    "SLASH_TELNEUI2",
    "SlashCmdList",
    -- WoW frame/UI API
    "CreateFrame",
    "UIParent",
    "BackdropTemplateMixin",
    -- WoW font strings
    "GameFontNormal",
    "GameFontNormalSmall",
    "GameFontNormalLarge",
    "GameFontHighlight",
    -- WoW unit / realm
    "UnitName",
    "GetRealmName",
    -- Addon management
    "GetAddOnInfo",
    "GetNumAddOns",
    "GetAddOnMetadata",
    "IsAddOnLoaded",
    "EnableAddOn",
    "DisableAddOn",
    -- Macros
    "GetNumMacros",
    "GetMacroInfo",
    "GetMacroBody",
    "CreateMacro",
    "EditMacro",
    "DeleteMacro",
    -- Keybinds
    "GetBindingKey",
    "GetBindingAction",
    "SetBinding",
    "SaveBindings",
    "GetNumBindings",
    -- Frame positioning
    "GetScreenWidth",
    "GetScreenHeight",
    -- Chat
    "GetChatWindowInfo",
    "GetChatWindowMessages",
    "SetChatWindowSize",
    -- EditMode
    "EditModeManagerFrame",
    -- Misc WoW
    "ReloadUI",
    "DEFAULT_CHAT_FRAME",
    "date",
    "time",
    "wipe",
    "tinsert",
    "tremove",
    "strsplit",
    "strfind",
    "format",
}

max_line_length = 120
ignore = {
    "212", -- unused argument
    "611", -- line contains only whitespace
}
