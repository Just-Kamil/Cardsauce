--- STEAMODDED HEADER
--- MOD_NAME: Cardsauce
--- MOD_ID: Cardsauce
--- MOD_AUTHOR: [BarrierTrio/Gote & Keku]
--- MOD_DESCRIPTION: A Vinesauce-themed expansion for Balatro, made in collaboration with the Balatro Discord and Vinesauce communities!
--- BADGE_COLOUR: 32A852
--- DISPLAY_NAME: Cardsauce
--- PREFIX: csau
--- VERSION: 1.2
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-1225a]

local mod_path = SMODS.current_mod.path
local usable_path = mod_path:match("Mods/[^/]+")
csau_config = SMODS.current_mod.config
csau_enabled = copy_table(csau_config)

local hook_list = {
	"card",
	"UI_definitions",
}

function recursiveEnumerate(folder)
	local fileTree = ""
	for _, file in ipairs(love.filesystem.getDirectoryItems(folder)) do
		local path = folder .. "/" .. file
		local info = love.filesystem.getInfo(path)
		fileTree = fileTree .. "\n" .. path .. (info.type == "directory" and " (DIR)" or "")
		if info.type == "directory" then
			fileTree = fileTree .. recursiveEnumerate(path)
		end
	end
	return fileTree
end

local skin_files = {}
for s in recursiveEnumerate(usable_path .. "/assets/1x/skins/"):gmatch("[^\r\n]+") do
	skin_files[#skin_files + 1] = s:gsub(usable_path .. "/assets/1x/skins/", "")
end

local deck_skins = {}
for _, file in ipairs(skin_files) do
	deck_skins[#deck_skins + 1] = file:sub(2, -5)
end

local collab_files = {}
for s in recursiveEnumerate(usable_path .. "/assets/1x/collabs/"):gmatch("[^\r\n]+") do
	if s:match("%.png$") then
		collab_files[#collab_files + 1] = s:gsub(usable_path .. "/assets/1x/collabs/", "")
	end
end

local collab_skins = {}
for _, file in ipairs(collab_files) do
	collab_skins[#collab_skins + 1] = file:sub(2, -5)
end

local tarot_files = {}
for s in recursiveEnumerate(usable_path .. "/assets/1x/tarot/"):gmatch("[^\r\n]+") do
	tarot_files[#tarot_files + 1] = s:gsub(usable_path .. "/assets/1x/tarot/", "")
end

local tarot_textures = {}
for _, file in ipairs(tarot_files) do
	tarot_textures[#tarot_textures + 1] = file:sub(2, -5)
end

for _, hook in ipairs(hook_list) do
	local init, error = NFS.load(SMODS.current_mod.path .. "hooks/" .. hook ..".lua")
	if error then sendErrorMessage("[Cardsauce] Failed to load "..hook.." with error "..error) else
		local data = init()
		sendDebugMessage("[Cardsauce] Loaded hook: " .. hook)
	end
end

local conf_cardsauce = {
	jokersToLoad = {
		-- Common
		'twoface',
		'newjoker',
		'depressedbrother',
		'pivot',
		'fisheye',
		'diaper',
		'speen',
		'pacman',
		'besomeone',
		'disguy',
		'roche',
		'reyn',
		'emmanuel',
		'gnorts',
		'chad',


		'purple',
		'garbagehand',
		-- Uncommon
		'meat',
		'greyjoker',
		'veryexpensivejoker',
		'roger',
		'cousinsclub',
		'anotherlight',
		'sohappy',
		'code',
		'werewolves',
		'maskedjoker',
		'dontmind',
		'kerosene',
		'businesstrading',

		'red',
		'fate',
		'miracle',
		'chromedup',
		-- Rare
		'thisiscrack',
		'deathcard',
		'hell',
		'odio',
		-- Common (Locked)
		'speedjoker',
		'disturbedjoker',

		-- Uncommon (Locked)
		'shrimp',
		'muppet',
		-- Rare (Locked)
		'charity',
		'supper',
		'pepsecret',

		'greenneedle',
		'wingsoftime',
		'kings',
		-- Legendary
		'vincenzo',
		'quarterdumb',

		-- Update 1.2
		'fantabulous',
		'grand',
		'ten',
		'beginners',
		'joeycastle',
		'voice',
		'rotten',
		'rapture',
		'villains',
		'killjester',

		-- Update 1.3
		'meteor',
		'dud',
		'koffing',
		'frich',
		'bunji',
		'myhouse',
	},
	consumablesToLoad = {
		'quixotic',
	},
	decksToLoad = {
		'vine',
	},
	challengesToLoad = {
		'tucker',
	},
	blindsToLoad = {
		'hog',
		'tray',
		'vod',
		--'outlaw',
		'finger',
		--'mochamike',
	},
	trophiesToLoad = {
	}
}

G.foodjokers = {
	'j_gros_michel',
	'j_ice_cream',
	'j_cavendish',
	'j_turtle_bean',
	'j_popcorn',
	'j_ramen',
	'j_selzer',
	'j_diet_cola',
	'j_csau_meat',
	'j_csau_fantabulous'
}

function G.FUNCS.is_food(key)
	for i, k in ipairs(G.foodjokers) do
		if k == key then
			return true
		end
	end
	return false
end


G.loadTrophies = true
if csau_enabled['enableTrophies'] then
	for s in recursiveEnumerate(usable_path .. "/achievements/"):gmatch("[^\r\n]+") do
		conf_cardsauce.trophiesToLoad[#conf_cardsauce.trophiesToLoad + 1] = s:gsub(usable_path .. "/achievements/", "")
	end
else
	G.loadTrophies = false
end

-- sendDebugMessage("AchievementsEnabler Activated!")
-- G.F_NO_ACHIEVEMENTS = false

-- unused
function getCardPosition(card)
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then
			return i
		end
	end
	return nil
end

function containsKey(table, key)
	return table[key] ~= nil
end

function starts_with(str, start)
	return string.sub(str, 1, #start) == start
end

function ends_with(str, ending)
	return string.sub(str, -#ending) == ending
end

function send(message, level)
	level = level or 'debug'
	if level == 'debug' then
		if type(message) == 'table' then
			sendDebugMessage(tprint(message))
		else
			sendDebugMessage(message)
		end
	elseif level == 'info' then
		if type(message) == 'table' then
			sendInfoMessage(tprint(message))
		else
			sendInfoMessage(message)
		end
	elseif level == 'error' then
		if type(message) == 'table' then
			sendErrorMessage(tprint(message))
		else
			sendErrorMessage(message)
		end
	end
end

function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(self, e)
	draw_from_deck_to_handref(self, e)
	if G.GAME.csau_dj_drawextra then
		draw_card(G.deck, G.hand, 100, 'up', true)
		G.GAME.csau_dj_drawextra = false
	end
	if G.GAME.csau_sj_drawextra then
		draw_card(G.deck, G.hand, 100, 'up', true)
		G.GAME.csau_sj_drawextra = false
	end
end

function SMODS.current_mod.reset_game_globals(run_start)
	G.GAME.current_round.choicevoice = { suit = 'Clubs' }
	local valid_choicevoice_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then
			valid_choicevoice_cards[#valid_choicevoice_cards+1] = v
		end
	end
	if valid_choicevoice_cards[1] then
		local randCard = pseudorandom_element(valid_choicevoice_cards, pseudoseed('marrriooOOO'..G.GAME.round_resets.ante))
		G.GAME.current_round.choicevoice.suit = randCard.base.suit
		G.GAME.current_round.choicevoice.rank = randCard.base.value
		G.GAME.current_round.choicevoice.id = randCard.base.id
	end
	G.GAME.current_round.joeycastle = { suit = 'Clubs' }
	local valid_joeycastle_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then
			valid_joeycastle_cards[#valid_joeycastle_cards+1] = v
		end
	end
	if valid_joeycastle_cards[1] then
		local randCard = pseudorandom_element(valid_joeycastle_cards, pseudoseed('fent'..G.GAME.round_resets.ante))
		G.GAME.current_round.joeycastle.suit = randCard.base.suit
	end
end

local get_straight_ref = get_straight
function get_straight(hand)
	local base = get_straight_ref(hand)
	local results = {}
	local vals = {}
	local verified = {}
	local can_loop = next(find_joker('Rekoj Gnorts'))
	local target = next(find_joker('Four Fingers')) and 4 or 5
	local skip_var = next(find_joker('Shortcut'))
	local skipped = false
	if not(can_loop) or #hand < target then
		G.GAME.gnortstraight = false
		return base
	else
		local hand_ref = {}
		for k, v in pairs(hand) do
			table.insert(hand_ref, v)
		end
		table.sort(hand_ref, function(a,b) return a:get_id() < b:get_id() end)
		local ranks = {}
		local _next = nil
		local val = 0
		for k, v in pairs(G.P_CARDS) do
			if (ranks[v.pos.x+1] == nil) then
				ranks[v.pos.x+1] = v.value
			end
		end
		while val < #hand_ref*2 do
			local i = val%#hand_ref + 1
			local id = hand_ref[i]:get_id()-1
			val = val + 1
			if _next == nil then
				table.insert(results,hand_ref[i])
				_next = ranks[id%#ranks+1]
				skipped = false
			else
				if (ranks[id] == _next) then

					table.insert(results,hand_ref[i])
					_next = ranks[id%#ranks+1]
					skipped = false
				elseif skip_var and not skipped then
					_next = ranks[id%#ranks+1]
					skipped = true
				else
					_next = nil
					val = val-1
					results = {}
					skipped = false
				end
			end
			if (#results == target) then
				table.sort(hand, function(a,b) return a.T.x < b.T.x end)
				table.sort(results, function(a,b) return a.T.x < b.T.x end)
				return {results}
			elseif _next ~= nil then

			end
		end
	end

	return {}
end

-- Load Jokers
for i, v in ipairs(conf_cardsauce.jokersToLoad) do
	local jokerInfo = assert(SMODS.load_file("jokers/" .. v .. ".lua"))()
	local enabled = false
	if jokerInfo.streamer then
		if ((jokerInfo.streamer == 'vinny' or 'othervinny') and csau_enabled['enableVinkers'])
				or (jokerInfo.streamer == 'joel' and csau_enabled['enableJoelkers'])
				or ((jokerInfo.streamer == 'other' or 'othervinny') and csau_enabled['enableOtherJokers']) then
			enabled = true
		end
	end
	if enabled then
		jokerInfo.key = v
		jokerInfo.atlas = v
		local atlasKey = v
		if jokerInfo.texture then
			atlasKey = jokerInfo.texture
			jokerInfo.atlas = jokerInfo.texture
		end
		jokerInfo.pos = { x = 0, y = 0 }
		if jokerInfo.hasSoul then
			jokerInfo.pos = { x = 1, y = 0 }
			jokerInfo.soul_pos = { x = 2, y = 0 }
		end

		local joker = SMODS.Joker(jokerInfo)
		for k_, v_ in pairs(joker) do
			if type(v_) == 'function' then
				joker[k_] = jokerInfo[k_]
			end
		end

		SMODS.Atlas({ key = atlasKey, path ="jokers/" .. atlasKey .. ".png", px = jokerInfo.width or 71, py = jokerInfo.height or  95 })
	end
end
-- Load Consumables
for i, v in ipairs(conf_cardsauce.consumablesToLoad) do
	local consumInfo = assert(SMODS.load_file("consumables/" .. v .. ".lua"))()

	if consumInfo.set == "Spectral" and csau_enabled['enableSpectrals'] then
		consumInfo.key = v
		consumInfo.atlas = v
		consumInfo.pos = { x = 0, y = 0 }
		if consumInfo.hasSoul then
			consumInfo.pos = { x = 1, y = 0 }
			consumInfo.soul_pos = { x = 2, y = 0 }
		end

		local consum = SMODS.Consumable(consumInfo)
		for k_, v_ in pairs(consum) do
			if type(v_) == 'function' then
				consum[k_] = consumInfo[k_]
			end
		end

		SMODS.Atlas({ key = v, path ="consumables/" .. v .. ".png", px = consum.width or 71, py = consum.height or  95 })
	end
end
if csau_enabled['enableDecks'] then
	for i, v in ipairs(conf_cardsauce.decksToLoad) do
		local deckInfo = assert(SMODS.load_file("decks/" .. v .. ".lua"))()

		deckInfo.key = v
		deckInfo.atlas = v
		deckInfo.pos = { x = 0, y = 0 }
		if deckInfo.hasSoul then
			deckInfo.pos = { x = 1, y = 0 }
			deckInfo.soul_pos = { x = 2, y = 0 }
		end

		local deck = SMODS.Back(deckInfo)
		for k_, v_ in pairs(deck) do
			if type(v_) == 'function' then
				deck[k_] = deckInfo[k_]
			end
		end

		SMODS.Atlas({ key = v, path ="decks/" .. v .. ".png", px = deck.width or 71, py = deck.height or  95 })
	end
end
if csau_enabled['enableChallenges'] then
	for i, v in ipairs(conf_cardsauce.challengesToLoad) do
		local chalInfo = assert(SMODS.load_file("challenges/" .. v .. ".lua"))()

		chalInfo.key = v

		local chal = SMODS.Challenge(chalInfo)
		for k_, v_ in pairs(chal) do
			if type(v_) == 'function' then
				chal[k_] = chalInfo[k_]
			end
		end
	end
end
if csau_enabled['enableBosses'] then
	for i, v in ipairs(conf_cardsauce.blindsToLoad) do
		local blindInfo = assert(SMODS.load_file("blinds/" .. v .. ".lua"))()

		blindInfo.key = v
		blindInfo.atlas = v
		if blindInfo.color then
			blindInfo.boss_colour = blindInfo.color
			blindInfo.color = nil
		end

		local blind = SMODS.Blind(blindInfo)
		for k_, v_ in pairs(blind) do
			if type(v_) == 'function' then
				blind[k_] = blindInfo[k_]
			end
		end

		SMODS.Atlas({ key = v, atlas_table = "ANIMATION_ATLAS", path = "blinds/" .. v .. ".png", px = 34, py = 34, frames = 21, })
	end
end
for i, v in ipairs(conf_cardsauce.trophiesToLoad) do
	local trophyInfo = assert(SMODS.load_file("achievements/" .. v))()

	trophyInfo.key = v:sub(2, -5)
	trophyInfo.atlas = 'csau_achievements'
	if trophyInfo.rarity then
		if trophyInfo.rarity == 1 then
			trophyInfo.pos = { x = 1, y = 0 }
		elseif trophyInfo.rarity == 2 then
			trophyInfo.pos = { x = 2, y = 0 }
		elseif trophyInfo.rarity == 3 then
			trophyInfo.pos = { x = 3, y = 0 }
		elseif trophyInfo.rarity == 4 then
			trophyInfo.pos = { x = 4, y = 0 }
		end
	end

	SMODS.Achievement(trophyInfo)
end

SMODS.Atlas({ key = 'csau_achievements', path = "csau_achievements.png", px = 66, py = 66})

local card_drawRef = Card.draw
function Card.draw(self, layer)
	local obj = self.config.center
	if obj.draw and type(obj.draw) == 'function' then
		obj:draw(self, layer)
	end
	card_drawRef(self, layer)
end

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

math.randomseed(os.time())
function externalPsuedorandom(chance, total)
	if total <= 0 then return false end
	local randomNumber = math.random(1, total)
	return randomNumber <= chance
end

ach_checklists = {
	band = {
		4,
		'the_band',
		{
			'Be Someone Forever',
			'Garbage Hand',
			'Another Light',
			'Kerosene',
			'Vincenzo',
			'Quarterdumb'
		},
	},
	high = {
		2,
		'high_one',
		{
			'Be Someone Forever',
			'Pivyot',
			'Meat',
			"Don't Mind If I Do",
		},
	},
}

function ach_jokercheck(card, table)
	local counter = 0
	for i, name in ipairs(table[3]) do
		if next(find_joker(name)) or card.name == name then
			counter = counter + 1
		end
	end
	if counter >= table[1] then
		check_for_unlock({ type = table[2] })
	end
end

function G.FUNCS.ach_pepsecretunlock(text)
	for k, v in pairs(SMODS.PokerHands) do
		if k == text then
			if v.visible == false then
				check_for_unlock({ type = "unlock_pep" })
			end
		end
	end
end

function G.FUNCS.ach_characters_check()
	if G.SETTINGS.CUSTOM_DECK.Collabs.Spades == "collab_CYP" and
	   G.SETTINGS.CUSTOM_DECK.Collabs.Hearts == "collab_TBoI" and
	   G.SETTINGS.CUSTOM_DECK.Collabs.Diamonds == "collab_SV" and
	   G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_STS" then
		check_for_unlock({ type = "skin_characters" })
	end
end

function G.FUNCS.ach_vineshroom_check()
	if ends_with(G.SETTINGS.CUSTOM_DECK.Collabs.Clubs, 'vineshroom') or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_PC" or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_WF" then
		check_for_unlock({ type = "skin_vineshroom" })
	end
end

if csau_enabled['enableSkins'] then
	for suit, color in pairs(G.C.SUITS) do
		local c
		if suit == "Hearts" then c = HEX("e14e62")
		elseif suit == "Diamonds" then c = HEX("3c56a4")
		elseif suit == "Clubs" then c = HEX("4dac84")
		elseif suit == "Spades" then c = HEX("8d619a")
		end
		SMODS.Suits[suit].keep_base_colours = false
		SMODS.Suits[suit].lc_colour = c
		SMODS.Suits[suit].hc_colour = c
		if G.VANILLA_COLLABS then
			G.VANILLA_COLLABS.lc_colours[suit] = c
			G.VANILLA_COLLABS.hc_colours[suit] = c
		end
		G.C.SO_1[suit] = c
		G.C.SO_2[suit] = c
	end
end

if csau_enabled['enableEasterEggs'] then
	G.chadnova = externalPsuedorandom(1, 1000)
end

if G.chadnova then
	G.TITLE_SCREEN_CARD = 'j_csau_chad'
else
	G.TITLE_SCREEN_CARD = G.P_CARDS.C_A
end

function G.FUNCS.title_screen_card(self, SC_scale)
	if G.chadnova then
		if type(G.TITLE_SCREEN_CARD) == "table" then
			return Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.TITLE_SCREEN_CARD, G.P_CENTERS.c_base)
		elseif type(G.TITLE_SCREEN_CARD) == "string" then
			return  Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.empty, G.P_CENTERS[G.TITLE_SCREEN_CARD])
		else
			return Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.C_A, G.P_CENTERS.c_base)
		end
	elseif csau_enabled['enableLogo'] then
		return Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.C_A, G.P_CENTERS.c_base)
	else
		return Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.S_A, G.P_CENTERS.c_base)
	end
end

function G.FUNCS.center_splash_screen_card(SC_scale)
	if G.chadnova then
		return Card(G.ROOM.T.w/2 - SC_scale*G.CARD_W/2, 10. + G.ROOM.T.h/2 - SC_scale*G.CARD_H/2, SC_scale*G.CARD_W, SC_scale*G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[G.TITLE_SCREEN_CARD])
	else
		return Card(G.ROOM.T.w/2 - SC_scale*G.CARD_W/2, 10. + G.ROOM.T.h/2 - SC_scale*G.CARD_H/2, SC_scale*G.CARD_W, SC_scale*G.CARD_H, G.P_CARDS.empty, G.P_CENTERS['j_joker'])
	end
end

function G.FUNCS.splash_screen_card(card_pos, card_size)
	if G.chadnova then
		return Card(  card_pos.x + G.ROOM.T.w/2 - G.CARD_W*card_size/2,
				card_pos.y + G.ROOM.T.h/2 - G.CARD_H*card_size/2,
				card_size*G.CARD_W, card_size*G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[G.TITLE_SCREEN_CARD])
	else
		return Card(  card_pos.x + G.ROOM.T.w/2 - G.CARD_W*card_size/2,
				card_pos.y + G.ROOM.T.h/2 - G.CARD_H*card_size/2,
				card_size*G.CARD_W, card_size*G.CARD_H, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base)
	end
end

mgt = {"m", "e", "t", "a", "l", "g", "e", "a", "r", "t", "a", "c", "o"}
mgt_num = 1

local color_presets = {
	{
		"GREEN",
		"PURPLE",
		{'50846e', "BAL_DEF_SMALLBIGGREEN"},
		{"4f6367", "BAL_DEF_ENDLESSBLUEGREY"},
		'default_csau'
	},
	{
		"RED",
		"BLUE",
		{'50846e', "BAL_DEF_SMALLBIGGREEN"},
		{"4f6367", "BAL_DEF_ENDLESSBLUEGREY"},
		'default_bal'
	},
	{
		{'2c997f', "DS_GREENCYAN"},
		{'09271d', "DS_DARKGREEN"},
		{'3a6658', "DS_BGGREEN"},
		'darkshroom',
	},
	{
		{'60b283', "VS_GREEN"},
		{'a3c86f', "VS_YELLOWGREEN"},
		{'3a664c', "VS_BGGREEN"},
		'vineshroom',
	},
	{
		{"547bb8", "FS_BLUE"},
		{"67b874", "FS_PALEGREEN"},
		{"3a4b66", "FS_BGBLUE"},
		'fullsauce',
	},
	{
		{'e26565', "ES_PALERED"},
		{'a53b38', "ES_DARKRED"},
		{'704b4b', "ES_BGRED"},
		'extrasauce',
	},
	{
		{'9967a7', "TWITCH_PALEPURPLE"},
		{'483062', "TWITCH_DARKPURPLE"},
		{'655478', "TWITCH_BGPURPLE"},
		'twitch',
	},
	{
		{"b5e61d", "FREN_NEONGREEN"},
		{"04a1e5", "FREN_LIGHTBLUE"},
		{"446138", "FREN_BGGREEN"},
		'fren',
	},
	{
		"PURPLE",
		"YELLOW",
		{"655478", "JM_BGPURPLE"},
		'jabroni',
	},
	{
		"JOKER_GREY",
		"BLACK",
		{'404040', "UZU_BGGRAY"},
		'uzumaki',
	},
	{
		"customhex"
	}
}

local color_presets_nums = {}
local color_presets_strings = {}
for i, v in ipairs(color_presets) do
	local k = v[#v]
	table.insert(color_presets_strings, k)
	color_presets_nums[k] = i
	if k ~= "customhex" then
		for i = 1, #v - 1 do
			local func_name, color_name
			if type(v[i]) == "string" then
				func_name = "cs_"..v[i].."c"
				color_name = v[i]
			elseif type(v[i]) == "table" then
				G.C[v[i][2]] = HEX(v[i][1])
				func_name = "cs_"..v[i][2].."c"
				color_name = v[i][2]
			end
		end
	end
end

if csau_enabled['enableColors'] then
	if not G.SETTINGS.CS_COLOR1 then
		G.SETTINGS.CS_COLOR1 = G.C.GREEN
	end
	if not G.SETTINGS.CS_COLOR2 then
		G.SETTINGS.CS_COLOR2 = G.C.PURPLE
	end
	G.C.COLOUR1 = G.SETTINGS.CS_COLOR1 or G.C.RED
	G.C.COLOUR2 = G.SETTINGS.CS_COLOR2 or G.C.BLUE
	G.C.BLIND.Small = G.SETTINGS.CS_COLOR3 or HEX('50846e')
	G.C.BLIND.Big = G.SETTINGS.CS_COLOR3 or HEX('50846e')
	G.C.BLIND.won = G.SETTINGS.CS_COLOR3 or HEX('50846e')
	G.CUSTOMHEX1 = ""
	G.CUSTOMHEX2 = ""
	G.CUSTOMHEX3 = ""
	G.CUSTOMHEX4 = ""

	local function get_matching_color(name)
		for i, v in ipairs(color_presets) do
			if type(v[1]) == "string" then
				if name == v[1] then
					return G.C[name]
				end
			elseif type(v[1]) == "table" then
				if name == v[1][2] then
					return HEX(v[1][1])
				end
			end
			if type(v[2]) == "string" then
				if name == v[2] then
					return G.C[name]
				end
			elseif type(v[2]) == "table" then
				if name == v[2][2] then
					return HEX(v[2][1])
				end
			end
		end
	end

	function csau_save_color(colour, val)
		local color = get_matching_color(val)
		local set = 'CS_COLOR'..colour
		G.SETTINGS[set] = color
		G:save_settings()
	end

	local colors = {}
	for _, preset in ipairs(color_presets) do
		if preset[#preset] ~= "customhex" then
			for i = 1, #preset - 1 do
				if type(preset[i]) == "string" then
					colors[preset[i]] = true
				elseif type(preset[i]) == "table" then
					colors[preset[i][2]] = true
				end
			end
		end
	end

	local function isRed(color)
		if type(color) ~= "table" or #color < 3 then
			return false, "Invalid color table"
		end
		local r, g, b = color[1], color[2], color[3]
		return r > g and r > b and r > 0.5
	end

	local function isBlack(color)
		if type(color) ~= "table" or #color < 3 then
			return false, "Invalid color table"
		end
		local r, g, b = color[1], color[2], color[3]
		local tolerance = 0.2
		local darkness_threshold = 0.3
		local is_grayish = math.abs(r - g) <= tolerance and math.abs(g - b) <= tolerance and math.abs(r - b) <= tolerance
		local is_dark = r <= darkness_threshold and g <= darkness_threshold and b <= darkness_threshold
		return is_grayish and is_dark
	end

	local function renoColors(color1, color2)
		local red = false
		local black = false
		if isRed(G.C.COLOUR1) and not isBlack(G.C.COLOUR1) then
			red = true
		elseif isBlack(G.C.COLOUR1) and not isRed(G.C.COLOUR1) then
			black = true
		end
		if isRed(G.C.COLOUR2) and not isBlack(G.C.COLOUR2) then
			if red == true then
				return false
			end
			red = true
		elseif isBlack(G.C.COLOUR2) and not isRed(G.C.COLOUR2) then
			if black == true then
				return false
			end
			black = true
		end
		return red and black
	end

	local function ach_reno_check()
		if renoColors(G.C.COLOUR1, G.C.COLOUR2) then
			check_for_unlock({ type = "reno_colors" })
		end
	end

	for color, _ in pairs(colors) do
		G.FUNCS["change_color_1_" .. color] = function()
			G.C.COLOUR1 = G.C[color]
			csau_save_color(1, color)
			ach_reno_check()
		end

		G.FUNCS["change_color_2_" .. color] = function()
			G.C.COLOUR2 = G.C[color]
			csau_save_color(2, color)
			ach_reno_check()
		end

		G.FUNCS["change_color_3_" .. color] = function()
			G.C.BLIND.Small = G.C[color]
			G.C.BLIND.Big = G.C[color]
			if G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante < 9 then
				ease_background_colour{new_colour = G.C[color], contrast = 1}
			end
			csau_save_color(3, color)
		end

		G.FUNCS["change_color_4_" .. color] = function()
			G.C.BLIND.won = G.C[color]
			if G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante >= 9 then
				ease_background_colour{new_colour = G.C[color], contrast = 1}
			end
			csau_save_color(3, color)
		end
	end

	for i=1, 4 do
		G.FUNCS["paste_hex_"..i] = function(e)
			G.CONTROLLER.text_input_hook = e.UIBox:get_UIE_by_ID('hex_set_'..i).children[1].children[1]
			G.CONTROLLER.text_input_id = 'hex_set_'..i
			for i = 1, 6 do
				G.FUNCS.text_input_key({key = 'right'})
			end
			for i = 1, 6 do
				G.FUNCS.text_input_key({key = 'backspace'})
			end
			local clipboard = (G.F_LOCAL_CLIPBOARD and G.CLIPBOARD or love.system.getClipboardText()) or ''
			for i = 1, #clipboard do
				local c = clipboard:sub(i,i)
				if c ~= "#" then
					G.FUNCS.text_input_key({key = c})
				end
			end
			G.FUNCS.text_input_key({key = 'return'})
		end
	end

	local function validHEX(str)
		local hex = str:match("^#?(%x%x%x%x%x%x)$") or str:match("^#?(%x%x%x)$")
		return hex ~= nil
	end

	local function replaceReplacedChars(str)
		return str:gsub("[Oo]", "0")
	end

	G.FUNCS.apply_colors = function()
		for i=1, 4 do
			if G["CUSTOMHEX"..i] then
				local hex = replaceReplacedChars(G["CUSTOMHEX"..i])
				if validHEX(hex) then
					if i== 4 then
						G.C.BLIND.won = HEX(hex)
						if G.GAME and G.GAME..round_resets.ante >= 9 then
							ease_background_colour{new_colour = HEX(hex), contrast = 1}
						end
						G:save_settings()
					end
					if i==3 then
						G.C.BLIND.Small = HEX(hex)
						G.C.BLIND.Big = HEX(hex)
						if G.GAME and G.GAME..round_resets.ante < 9 then
							ease_background_colour{new_colour = HEX(hex), contrast = 1}
						end
						G.SETTINGS["CS_COLOR"..i] = HEX(hex)
						G:save_settings()
					elseif i == 1 or i == 2 then
						G.C["COLOUR"..i] = HEX(hex)
						G.SETTINGS["CS_COLOR"..i] = HEX(hex)
						G:save_settings()
					end
				end
			end
		end
		ach_reno_check()
	end

	if not G.SETTINGS.csau_color_selection then
		G.SETTINGS.csau_color_selection = "default_csau"
	end

	if not G.SETTINGS.music_selection then
		G.SETTINGS.music_selection = "cardsauce"
	end
end

local main_menuRef = Game.main_menu
function Game:main_menu(change_context)
	main_menuRef(self, change_context)

	if csau_enabled['enableChallenges'] then
		csau_tucker_addBanned()
	end

	if csau_enabled['enableColors'] then
		local splash_args = {mid_flash = change_context == 'splash' and 1.6 or 0.}
		ease_value(splash_args, 'mid_flash', -(change_context == 'splash' and 1.6 or 0), nil, nil, nil, 4)

		G.SPLASH_BACK:define_draw_steps({{
			 shader = 'splash',
			 send = {
				 {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL'},
				 {name = 'vort_speed', val = 0.4},
				 {name = 'colour_1', ref_table = G.C, ref_value = 'COLOUR1'},
				 {name = 'colour_2', ref_table = G.C, ref_value = 'COLOUR2'},
				 {name = 'mid_flash', ref_table = splash_args, ref_value = 'mid_flash'},
				 {name = 'vort_offset', val = 0},
			 }}})
	end
end

if csau_enabled['enableColors'] then
	G.FUNCS.change_color_buttons = function()
		if G.OVERLAY_MENU then
			local swap_node = G.OVERLAY_MENU:get_UIE_by_ID('color_buttons')
			local focused_color_preset = G.SETTINGS.QUEUED_CHANGE.color_change
			local color = {}
			local key
			for _, v in ipairs(color_presets) do
				if v[#v] == focused_color_preset then
					key = v[#v]
					if v[#v] ~= "customhex" then
						for i=1, #v - 1 do
							color[i] = v[i][2] or v[i]
						end
					end
				end
			end
			if swap_node then
				for i=1, #swap_node.children do
					swap_node.children[i]:remove()
					swap_node.children[i] = nil
				end

				local new_color_buttons = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
				new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n=G.UIT.T, config={text = localize('b_color_selector_outer'), scale = 0.35, colour = G.C.WHITE, shadow = true}}
				if key == "customhex" then
					new_color_buttons.nodes[#new_color_buttons.nodes + 1] = create_text_input({id = 'hex_set_1', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX1', max_length = 6, prompt_text = localize('b_color_selector_hex'), extended_corpus = true, config = { align = "cm" }})
					new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
						UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_1", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
					}}
				else
					for i, color in ipairs(color) do
						new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
							UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_1_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
						}}
					end
				end
				new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n=G.UIT.T, config={text = "|", scale = 0.35, colour = G.C.WHITE, shadow = true}}
				if key == "customhex" then
					new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
						UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_2", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
					}}
					new_color_buttons.nodes[#new_color_buttons.nodes + 1] = create_text_input({id = 'hex_set_2', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX2', max_length = 6, prompt_text = localize('b_color_selector_hex'), config = { align = "cm" }})
				else
					for i, color in ipairs(color) do
						new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
							UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_2_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
						}}
					end
				end
				new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n=G.UIT.T, config={text = localize('b_color_selector_inner'), scale = 0.35, colour = G.C.WHITE, shadow = true}}
				local new_sub_caption = { n=G.UIT.R, config={ align = "cm", padding = 0}, nodes={ { n=G.UIT.T, config={ text = localize('b_color_selector_game'), scale = 0.35, colour = G.C.WHITE, shadow = true}}}}
				local new_sub_buttons = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
				if key == "customhex" then
					new_sub_buttons.nodes[#new_sub_buttons.nodes + 1] = create_text_input({id = 'hex_set_3', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX3', max_length = 6, prompt_text = localize('b_color_selector_hex'), config = { align = "cm" }})
					new_sub_buttons.nodes[#new_sub_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2, align = "cm", }, nodes = {
						UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_3", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
					}}
				else
					for i, color in ipairs(color) do
						new_sub_buttons.nodes[#new_sub_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
							UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_3_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
						}}
					end
				end
				local new_sub_caption_2 = { n=G.UIT.R, config={ align = "cm", padding = 0}, nodes={ { n=G.UIT.T, config={ text = localize('b_color_selector_game_2'), scale = 0.35, colour = G.C.WHITE, shadow = true}}}}
				local new_sub_buttons_2 = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
				if key == "customhex" then
					new_sub_buttons_2.nodes[#new_sub_buttons_2.nodes + 1] = create_text_input({id = 'hex_set_4', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX4', max_length = 6, prompt_text = localize('b_color_selector_hex'), config = { align = "cm" }})
					new_sub_buttons_2.nodes[#new_sub_buttons_2.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2, align = "cm", }, nodes = {
						UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_4", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
					}}
				else
					for i, color in ipairs(color) do
						new_sub_buttons_2.nodes[#new_sub_buttons_2.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
							UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_4_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
						}}
					end
				end
				local apply_button = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
				if key == "customhex" then
					apply_button.nodes[#apply_button.nodes + 1] = {n = G.UIT.C, config = {padding = 0.05,align = "cm", }, nodes = {
						UIBox_button({minw = 2, minh = 0.5, button = "apply_colors", colour = G.C.RED, label = localize('b_color_selector_hex_set'), scale = 0.35})
					}}
				end
				swap_node.UIBox:add_child(new_color_buttons, swap_node)
				swap_node.UIBox:add_child(new_sub_caption, swap_node)
				swap_node.UIBox:add_child(new_sub_buttons, swap_node)
				swap_node.UIBox:add_child(new_sub_caption_2, swap_node)
				swap_node.UIBox:add_child(new_sub_buttons_2, swap_node)
				swap_node.UIBox:add_child(apply_button, swap_node)
			end
		end
	end

	G.FUNCS.change_color_preset = function(args)
		G.ARGS.color_vals = G.ARGS.color_vals or color_presets_strings
		G.SETTINGS.QUEUED_CHANGE.color_change = G.ARGS.color_vals[args.to_key]
		G.SETTINGS.csau_color_selection = G.ARGS.color_vals[args.to_key]
		G.FUNCS.change_color_buttons()
	end
end

local music_nums = {
	cardsauce = 1,
	balatro = 2
}

local music_strings = {
	"cardsauce",
	"balatro"
}

G.FUNCS.change_music = function(args)
	G.ARGS.music_vals = G.ARGS.music_vals or music_strings
	G.SETTINGS.QUEUED_CHANGE.music_change = G.ARGS.music_vals[args.to_key]
	G.SETTINGS.music_selection = G.ARGS.music_vals[args.to_key]
end


setting_tabRef = G.UIDEF.settings_tab
function G.UIDEF.settings_tab(tab)
	local setting_tab = setting_tabRef(tab)
	if tab == 'Audio' and csau_enabled['enableMusic'] then
		local musicSelector = {n=G.UIT.R, config = {align = 'cm', r = 0}, nodes= {
			create_option_cycle({ w = 6, scale = 0.8, label = localize('b_music_selector'), options = localize('ml_music_selector_opt'), opt_callback = 'change_music', current_option = ((music_nums)[G.SETTINGS.music_selection] or 1) })
		}}
		setting_tab.nodes[#setting_tab.nodes + 1] = musicSelector
	end
	if tab == 'Colors' and csau_enabled['enableColors'] then
		local color = {}
		local key
		for _, v in ipairs(color_presets) do
			if v[#v] == G.SETTINGS.csau_color_selection then
				key = v[#v]
				if v[#v] ~= "customhex" then
					for i=1, #v - 1 do
						color[i] = v[i][2] or v[i]
					end
				end
			end
		end
		local nodes = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
		nodes.nodes[#nodes.nodes + 1] = {n=G.UIT.T, config={text = localize('b_color_selector_outer'), scale = 0.35, colour = G.C.WHITE, shadow = true}}
		if key == "customhex" then
			nodes.nodes[#nodes.nodes + 1] = create_text_input({id = 'hex_set_1', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX1', max_length = 6, prompt_text = localize('b_color_selector_hex'), extended_corpus = true, config = { align = "cm" }})
			nodes.nodes[#nodes.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
				UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_1", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
			}}
		else
			for i, color in ipairs(color) do
				nodes.nodes[#nodes.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
					UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_1_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
				}}
			end
		end
		nodes.nodes[#nodes.nodes + 1] = {n=G.UIT.T, config={text = "|", scale = 0.35, colour = G.C.WHITE, shadow = true}}
		if key == "customhex" then
			nodes.nodes[#nodes.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
				UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_2", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
			}}
			nodes.nodes[#nodes.nodes + 1] = create_text_input({id = 'hex_set_2', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX2', max_length = 6, prompt_text = localize('b_color_selector_hex'), extended_corpus = true, config = { align = "cm" }})
		else
			for i, color in ipairs(color) do
				nodes.nodes[#nodes.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
					UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_2_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
				}}
			end
		end
		nodes.nodes[#nodes.nodes + 1] = {n=G.UIT.T, config={text = localize('b_color_selector_inner'), scale = 0.35, colour = G.C.WHITE, shadow = true}}
		local sub_caption = { n=G.UIT.R, config={ align = "cm", padding = 0}, nodes={ { n=G.UIT.T, config={ text = localize('b_color_selector_game'), scale = 0.35, colour = G.C.WHITE, shadow = true}}}}
		local sub_buttons = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
		if key == "customhex" then
			sub_buttons.nodes[#sub_buttons.nodes + 1] = create_text_input({id = 'hex_set_3', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX3', max_length = 6, prompt_text = localize('b_color_selector_hex'), extended_corpus = true, config = { align = "cm" }})
			sub_buttons.nodes[#sub_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
				UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_3", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
			}}
		else
			for i, color in ipairs(color) do
				sub_buttons.nodes[#sub_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
					UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_3_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
				}}
			end
		end
		local sub_caption_2 = { n=G.UIT.R, config={ align = "cm", padding = 0}, nodes={ { n=G.UIT.T, config={ text = localize('b_color_selector_game_2'), scale = 0.35, colour = G.C.WHITE, shadow = true}}}}
		local sub_buttons_2 = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
		if key == "customhex" then
			sub_buttons_2.nodes[#sub_buttons_2.nodes + 1] = create_text_input({id = 'hex_set_4', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX4', max_length = 6, prompt_text = localize('b_color_selector_hex'), extended_corpus = true, config = { align = "cm" }})
			sub_buttons_2.nodes[#sub_buttons_2.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
				UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_4", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
			}}
		else
			for i, color in ipairs(color) do
				sub_buttons_2.nodes[#sub_buttons_2.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
					UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_4_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
				}}
			end
		end
		local apply_button = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
		if key == "customhex" then
			apply_button.nodes[#apply_button.nodes + 1] = {n = G.UIT.C, config = {padding = 0.05,align = "cm", }, nodes = {
				UIBox_button({minw = 2, minh = 0.5, button = "apply_colors", colour = G.C.RED, label = localize('b_color_selector_hex_set'), scale = 0.35})
			}}
		end
		local colorSelector = {n=G.UIT.R, config = {align = 'cm', r = 0}, nodes={
			create_option_cycle({w = 5,scale = 0.8, label = localize('b_color_selector'), options = localize('ml_color_selector_opt'), opt_callback = 'change_color_preset', current_option = ((color_presets_nums)[G.SETTINGS.csau_color_selection] or 1)}),
			{n=G.UIT.R, config={align = "cm", id = 'color_buttons'}, nodes={nodes, sub_caption, sub_buttons, sub_caption_2, sub_buttons_2, apply_button}},
		}}
		setting_tab.nodes[#setting_tab.nodes + 5] = colorSelector
	end
	return setting_tab
end

-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "csau_icon.png",
	px = 32,
	py = 32
}):register()

if csau_enabled['enableLogo'] then
	-- Title Screen Logo Texture
	local logo = "Logo.png"
	if G.chadnova and csau_enabled['enableEasterEggs'] then
		logo = "Logo-C.png"
	end
	SMODS.Atlas {
		key = "balatro",
		path = logo,
		px = 333,
		py = 216,
		prefix_config = { key = false }
	}
end

if csau_enabled['enableTarotSkins'] then
	-- Tarot Atlases
	for _, tarot in ipairs(tarot_textures) do
		SMODS.Atlas{
			key = tarot,
			path = "tarot/"..tarot..".png",
			px = 71,
			py = 95,
			atlas_table = "ASSET_ATLAS"
		}
	end

	SMODS.Consumable:take_ownership('moon', {
		pos = {x = 0, y = 0},
		atlas = 'csau_moon'
	}, true)
	SMODS.Consumable:take_ownership('hermit', {
		pos = {x = 0, y = 0},
		atlas = 'csau_kermit'
	}, true)
end

if csau_enabled['enableSkins'] then
	-- Base Deck Textures
	for i = 1, 2 do
		SMODS.Atlas {
			key = "cards_"..i,
			path = "BaseDeck.png",
			px = 71,
			py = 95,
			prefix_config = { key = false }
		}
		SMODS.Atlas {
			key = "ui_"..i,
			path = "ui_assets.png",
			px = 18,
			py = 18,
			prefix_config = { key = false }
		}
		SMODS.Atlas {
			key = "ui_",
			path = "ui_assets.png",
			px = 18,
			py = 18,
			prefix_config = { key = false }
		}
	end
	SMODS.Atlas{
		key = 'alt_color_jokers',
		path = "colorjokers.png",
		px = 71,
		py = 95,
		atlas_table = "ASSET_ATLAS",
	}

	SMODS.Joker:take_ownership('greedy_joker', {
		pos = {x = 0, y = 0},
		atlas = 'csau_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('lusty_joker', {
		pos = {x = 1, y = 0},
		atlas = 'csau_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('wrathful_joker', {
		pos = {x = 2, y = 0},
		atlas = 'csau_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('gluttenous_joker', {
		pos = {x = 3, y = 0},
		atlas = 'csau_alt_color_jokers'
	}, true)

	SMODS.Joker:take_ownership('onyx_agate', {
		pos = {x = 5, y = 0},
		atlas = 'csau_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('rough_gem', {
		pos = {x = 4, y = 0},
		atlas = 'csau_alt_color_jokers'
	}, true)

	-- Skin Atlases
	for _, skin in ipairs(deck_skins) do
		SMODS.Atlas{
			key = skin,
			path = "skins/"..skin..".png",
			px = 71,
			py = 95,
			atlas_table = "ASSET_ATLAS"
		}
	end

	-- Collab Atlases
	for _, skin in ipairs(collab_skins) do
		SMODS.Atlas{
			key = skin,
			path = "collabs/"..skin..".png",
			px = 71,
			py = 95,
			atlas_table = "ASSET_ATLAS",
		}
	end

	-- Characters Replacements
	SMODS.DeckSkin:take_ownership('collab_AU',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "csau_h_characters",
		hc_atlas = "csau_h_characters"
	})
	SMODS.DeckSkin:take_ownership('collab_TW',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "csau_s_characters",
		hc_atlas = "csau_s_characters"
	})
	SMODS.DeckSkin:take_ownership('collab_VS',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "csau_c_characters",
		hc_atlas = "csau_c_characters"
	})
	SMODS.DeckSkin:take_ownership('collab_DTD',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "csau_d_characters",
		hc_atlas = "csau_d_characters"
	})

	-- The Mascots, Classics, Wildcards, and Confidants
	SMODS.DeckSkin:take_ownership('collab_TBoI',{
		loc_txt = {
			["en-us"] = "The Wildcards"
		},
		lc_atlas = "csau_h_wildcards",
		hc_atlas = "csau_h_wildcards"
	})
	SMODS.DeckSkin:take_ownership('collab_CYP',{
		loc_txt = {
			["en-us"] = "The Confidants"
		},
		lc_atlas = "csau_s_confidants",
		hc_atlas = "csau_s_confidants"
	})
	SMODS.DeckSkin:take_ownership('collab_STS',{
		loc_txt = {
			["en-us"] = "The Mascots"
		},
		lc_atlas = "csau_c_mascots",
		hc_atlas = "csau_c_mascots"
	})
	SMODS.DeckSkin:take_ownership('collab_SV',{
		loc_txt = {
			["en-us"] = "The Classics"
		},
		lc_atlas = "csau_d_classics",
		hc_atlas = "csau_d_classics"
	})

	-- Vineshroom
	SMODS.DeckSkin:take_ownership('collab_PC',{
		ranks =  {"Ace"},
		loc_txt = {
			["en-us"] = "Vineshroom"
		},
		lc_atlas = "c_vineshroom",
		hc_atlas = "c_vineshroom"
	})

	-- Deck Skins: Clubs
	SMODS.DeckSkin:take_ownership('collab_WF',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_characters_VS",
		hc_atlas = "c_characters_VS",
		loc_txt = {
			["en-us"] = "Characters [VS]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_mascots_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_mascots_VS",
		hc_atlas = "c_mascots_VS",
		loc_txt = {
			["en-us"] = "The Mascots [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_VS_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_VS_DS",
		hc_atlas = "c_collab_VS_DS",
		loc_txt = {
			["en-us"] = "Vampire Survivors [DS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_STS_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_STS_DS",
		loc_txt = {
			["en-us"] = "Slay The Spire [DS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_PC_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "c_collab_PC_DS",
		loc_txt = {
			["en-us"] = "Potion Craft [DS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_WF_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "c_collab_WF_DS",
		loc_txt = {
			["en-us"] = "Warframe [DS]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_c_collab_VS_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_VS_VS",
		loc_txt = {
			["en-us"] = "Vampire Survivors [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_STS_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_STS_VS",
		loc_txt = {
			["en-us"] = "Slay The Spire [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_PC_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_PC_VS",
		loc_txt = {
			["en-us"] = "Potion Craft [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_WF_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_WF_VS",
		loc_txt = {
			["en-us"] = "Warframe [VS]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_c_collab_VS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_VS",
		loc_txt = {
			["en-us"] = "Vampire Survivors"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_STS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_STS",
		loc_txt = {
			["en-us"] = "Slay The Spire"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_PC",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_PC",
		loc_txt = {
			["en-us"] = "Potion Craft"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_WF",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_WF",
		loc_txt = {
			["en-us"] = "Warframe"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_shroomless",
		suit = "Clubs",
		ranks =  {"Ace"},
		lc_atlas = "c_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}

	-- Deck Skins: Hearts
	SMODS.DeckSkin:take_ownership('collab_CL',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_AU_ES",
		hc_atlas = "h_collab_AU_ES",
		loc_txt = {
			["en-us"] = "Among Us [ES]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin:take_ownership('collab_D2',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_TBoI_ES",
		hc_atlas = "h_collab_TBoI_ES",
		loc_txt = {
			["en-us"] = "The Binding of Isaac [ES]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_h_collab_CL_ES",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_collab_CL_ES",
		loc_txt = {
			["en-us"] = "Cult of the Lamb [ES]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_D2_ES",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_collab_D2_ES",
		loc_txt = {
			["en-us"] = "Divinity Original Sin 2 [ES]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_h_collab_AU",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_AU",
		loc_txt = {
			["en-us"] = "Among Us"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_TBoI",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_TBoI",
		loc_txt = {
			["en-us"] = "The Binding of Isaac"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_CL",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_CL",
		loc_txt = {
			["en-us"] = "Cult of the Lamb"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_D2",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_D2",
		loc_txt = {
			["en-us"] = "Divinity Original Sin 2"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_h_shroomless",
		suit = "Hearts",
		ranks =  {"Ace"},
		lc_atlas = "h_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}

	-- Deck Skins: Spades
	SMODS.DeckSkin:take_ownership('collab_SK',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_TW_TC",
		hc_atlas = "s_collab_TW_TC",
		loc_txt = {
			["en-us"] = "The Witcher [TC]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin:take_ownership('collab_DS',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_CYP_TC",
		hc_atlas = "s_collab_CYP_TC",
		loc_txt = {
			["en-us"] = "Cyberpunk 2077 [TC]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_s_collab_SK_TC",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "s_collab_SK_TC",
		loc_txt = {
			["en-us"] = "Shovel Knight [TC]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_DS_TC",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "s_collab_DS_TC",
		loc_txt = {
			["en-us"] = "Don't Starve [TC]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_s_collab_TW",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_TW",
		loc_txt = {
			["en-us"] = "The Witcher"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_CYP",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_CYP",
		loc_txt = {
			["en-us"] = "Cyberpunk 2077"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_SK",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_SK",
		loc_txt = {
			["en-us"] = "Shovel Knight"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_DS",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_DS",
		loc_txt = {
			["en-us"] = "Don't Starve"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_s_shroomless",
		suit = "Spades",
		ranks =  {"Ace"},
		lc_atlas = "s_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}

	-- Deck Skins: Diamonds
	SMODS.DeckSkin:take_ownership('collab_EG',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_DTD_FS",
		hc_atlas = "d_collab_DTD_FS",
		loc_txt = {
			["en-us"] = "Dave The Diver [FS]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin:take_ownership('collab_XR',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_SV_FS",
		hc_atlas = "d_collab_SV_FS",
		loc_txt = {
			["en-us"] = "Stardew Valley [FS]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_d_collab_EG_FS",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "d_collab_EG_FS",
		loc_txt = {
			["en-us"] = "Enter the Gungeon [FS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_XR_FS",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "d_collab_XR_FS",
		loc_txt = {
			["en-us"] = "1000xRESIST [FS]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_d_collab_DTD",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_DTD",
		loc_txt = {
			["en-us"] = "Dave The Diver"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_SV",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_SV",
		loc_txt = {
			["en-us"] = "Stardew Valley"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_EG",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_EG",
		loc_txt = {
			["en-us"] = "Enter the Gungeon"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_XR",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_XR",
		loc_txt = {
			["en-us"] = "1000xRESIST"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_d_shroomless",
		suit = "Diamonds",
		ranks =  {"Ace"},
		lc_atlas = "d_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}
end

if csau_enabled['enableMusic'] then
	SMODS.Sound({
		vol = 0.6,
		pitch = 1,
		key = "csau_music1",
		path = "csau_music1.ogg",
		select_music_track = function()
			return (G.SETTINGS.music_selection == "cardsauce") and 10 or false
		end,
	})
	SMODS.Sound({
		vol = 0.6,
		pitch = 1,
		key = "csau_music2",
		path = "csau_music2.ogg",
		select_music_track = function()
			return (G.SETTINGS.music_selection == "cardsauce" and G.booster_pack_sparkles and not G.booster_pack_sparkles.REMOVED) and 11 or false
		end,
	})
	SMODS.Sound({
		vol = 0.6,
		pitch = 1,
		key = "csau_music3",
		path = "csau_music3.ogg",
		select_music_track = function()
			return (G.SETTINGS.music_selection == "cardsauce" and G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED) and 11 or false
		end,
	})
	SMODS.Sound({
		vol = 0.6,
		pitch = 1,
		key = "csau_music4",
		path = "csau_music4.ogg",
		select_music_track = function()
			return (G.SETTINGS.music_selection == "cardsauce" and G.shop and not G.shop.REMOVED) and 11 or false
		end,
	})
	SMODS.Sound({
		vol = 0.6,
		pitch = 1,
		key = "csau_music5",
		path = "csau_music5.ogg",
		select_music_track = function()
			return (G.SETTINGS.music_selection == "cardsauce" and G.GAME.blind and G.GAME.blind.boss) and 11 or false
		end,
	})
end

if csau_enabled['enableEasterEggs'] then
	SMODS.Atlas({
		key = "jimbo_shot",
		atlas_table = "ASSET_ATLAS",
		path = "jimbo_shot.png",
		px = 71,
		py = 95
	})

	SMODS.Sound({
		key = "gunshot",
		path = "gunshot.ogg",
		pitch = 1,
		volume = 0.7
	})
	local initref = Card_Character.init
	function Card_Character:init(args)
		initref(self, args)
		self.children.card.click = Card.gunshot_func
	end

	function Card:gunshot_func()
		if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot') then
			play_sound("csau_gunshot", 1, 1)
			self.children.center.atlas = G.ASSET_ATLAS["csau_jimbo_shot"]
			self.children.center:set_sprite_pos({x = 0, y = 0})
			self:juice_up()

			if not G.GAME.shot_jimbo then
				for k, v in pairs(G.I.CARD) do
					if getmetatable(v) == Card_Character then
						v.children.particles = Particles(0, 0, 0,0, {
							timer = 0.01,
							scale = 0.3,
							speed = 2,
							lifespan = 4,
							attach = v,
							colours = {G.C.RED, G.C.RED, G.C.RED},
							fill = true
						})
						v:remove_speech_bubble()
						v.talking = false
					end
				end
			end

			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 2,
				func = (function()
					check_for_unlock({ type = "fuckingkill_jimbo" })
					return true
				end)}))

			G.GAME.shot_jimbo = true
		end
	end
end

G.FUNCS.reset_trophies = function(e)
	local warning_text = e.UIBox:get_UIE_by_ID('warn')
	if warning_text.config.colour ~= G.C.WHITE then
		warning_text:juice_up()
		warning_text.config.colour = G.C.WHITE
		warning_text.config.shadow = true
		e.config.disable_button = true
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06, blockable = false, blocking = false, func = function()
			play_sound('tarot2', 0.76, 0.4);return true end}))
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.35, blockable = false, blocking = false, func = function()
			e.config.disable_button = nil;return true end}))
		play_sound('tarot2', 1, 0.4)
	else
		G.FUNCS.wipe_on()
		for k, v in pairs(SMODS.Achievements) do
			if starts_with(k, 'ach_csau_') then
				G.SETTINGS.ACHIEVEMENTS_EARNED[k] = nil
				G.ACHIEVEMENTS[k].earned = nil
			end
		end
		G:save_settings()
		G.E_MANAGER:add_event(Event({
			delay = 1,
			func = function()
				G.FUNCS.wipe_off()
				return true
			end
		}))
	end
end

local function config_matching()
	for k, v in pairs(csau_enabled) do
		if v ~= csau_config[k] then
			return false
		end
	end
	return true
end

function G.FUNCS.csau_restart()
	if config_matching() then
		send("SETTINGS MATCH :)")
		SMODS.full_restart = 0
	else
		send("SETTINGS DONT MATCH!")
		SMODS.full_restart = 1
	end
end

local text_scale = 0.9
local csauConfigTabs = function() return {
	{
		label = localize("b_options"),
		chosen = true,
		tab_definition_function = function()
			local csau_opts = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {
				{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
					{n=G.UIT.T, config={text = localize("b_options"), scale = text_scale*0.9, colour = G.C.GREEN, shadow = true}},
				}},
				--[[{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
					{n=G.UIT.T, config={text = localize("vs_options_sub"), scale = text_scale*0.5, colour = G.C.GREEN, shadow = true}},
				}},]]--
			}}
			if localize("vs_options_muteWega") then
				csau_opts.nodes[#csau_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						create_toggle({n=G.UIT.T, label = localize("vs_options_muteWega"), ref_table = csau_config, ref_value = 'muteWega' })
					}},
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_muteWega_desc"), scale = text_scale*0.35, colour = G.C.JOKER_GREY, shadow = true}}
					}},
				}}
			end
			if localize("vs_options_resetTrophies_r") then
				csau_opts.nodes[#csau_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
					{n=G.UIT.R, config={align = "cm", minw = 0.5, maxw = 2, minh = 0.6, padding = 0, r = 0.1, hover = true, colour = G.C.RED, button = "reset_trophies", shadow = true, focus_args = {nav = 'wide'}}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_resetTrophies_r"), scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT}}
					}},
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_resetTrophies_desc"), scale = text_scale*0.35, colour = G.C.JOKER_GREY, shadow = true}}
					}},
				}}
			end
			csau_opts.nodes[#csau_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
				{n=G.UIT.T, config={id = 'warn', text = localize('ph_click_confirm'), scale = 0.4, colour = G.C.CLEAR}}
			}}
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 10,
					align = "cm",
					padding = 0.05,
					colour = G.C.BLACK,
				},
				nodes = {
					csau_opts
				}
			}
		end
	}
} end

SMODS.current_mod.extra_tabs = csauConfigTabs


SMODS.current_mod.config_tab = function()
	local ordered_config = {
		'enableVinkers',
		'enableJoelkers',
		'enableOtherJokers',
		'enableSpectrals',
		'enableBosses',
		'enableDecks',
		'enableSkins',
		'enableChallenges',
		'enableMusic',
		'enableTrophies',
		'enableLogo',
		'enableColors',
		'enableTarotSkins',
		'enableEasterEggs',
	}
	local left_settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
	local right_settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
	for i, k in ipairs(ordered_config) do
		if #right_settings.nodes < #left_settings.nodes then
			right_settings.nodes[#right_settings.nodes + 1] = create_toggle({ label = localize("vs_options_"..ordered_config[i]), ref_table = csau_config, ref_value = ordered_config[i], callback = G.FUNCS.csau_restart})
		else
			left_settings.nodes[#left_settings.nodes + 1] = create_toggle({ label = localize("vs_options_"..ordered_config[i]), ref_table = csau_config, ref_value = ordered_config[i], callback = G.FUNCS.csau_restart})
		end
	end
	local csau_config_ui = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { left_settings, right_settings } }
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 6,
			r = 0.1,
			minw = 10,
			align = "cm",
			padding = 0.05,
			colour = G.C.BLACK,
		},
		nodes = {
			csau_config_ui
		}
	}
end

vs_credit_1 = "BarrierTrio/Gote"
vs_credit_2 = "DPS2004"
vs_credit_3 = "SagaciousCejai"
vs_credit_4 = "Nether"
vs_credit_5 = "Mysthaps"
vs_credit_6 = "Numbuh214"
vs_credit_7 = "Aurelius7309"
vs_credit_8 = "Austin L. Matthews"
vs_credit_8_tag = "(AmtraxVA)"
vs_credit_9 = "Lyman"
vs_credit_9_from = "(JankJonklers)"
vs_credit_10 = "Akai"
vs_credit_10_from = "(Balatrostuck)"
vs_credit_5_from = "(LobotomyCorp)"
vs_credit_12 = "Victin"
vs_credit_12_from = "(Victin's Collection)"
vs_credit_13 = "Keku"
vs_credit_14 = "Gappie"
vs_credit_15 = "Arthur Effgus"
vs_credit_16 = "FenixSeraph"
vs_credit_17 = "WhimsyCherry"
vs_credit_18 = "Global-Trance"
vs_credit_19 = "Lyzerus"
vs_credit_20 = "Bassclefff"
vs_credit_20_tag = "(bassclefff.bandcamp.com)"
vs_credit_21 = "fradavovan"
vs_credit_22 = "Greeeg"
vs_credit_23 = "CheesyDraws"
vs_credit_24 = "Jazz_Jen"
vs_credit_25 = "BardVergil"
vs_credit_26 = "GuffNFluff"
vs_credit_27 = "sinewuui"
vs_credit_28 = "Swizik"
vs_credit_29 = "Burdrehnar"
vs_credit_st1 = "tortoise"
vs_credit_st2 = "Protokyuuu"
vs_credit_st3 = "ShrineFox"
vs_credit_st4 = "cyrobolic"
vs_credit_st5 = "ReconBox"

local header_scale = 1.1
local bonus_padding = 1.15
local support_padding = 0.015
local artist_size = 0.43

SMODS.current_mod.credits_tab = function()
	chosen = true
	return {n=G.UIT.ROOT, config={align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 10}, nodes={
		{n = G.UIT.C, config = { align = "tm", padding = 0.2 }, nodes = {
			{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
				{n=G.UIT.T, config={text = localize("b_credits"), scale = text_scale*1.2, colour = G.C.GREEN, shadow = true}},
			}},
			{n=G.UIT.R, config={align = "cm", padding = 0.05,outline_colour = G.C.GREEN, r = 0.1, outline = 1}, nodes= {
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes={
					{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = localize('vs_credits1'), scale = header_scale * 0.5, colour = G.C.GOLD, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = vs_credit_1, scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = vs_credit_13, scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.4, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = localize('vs_credits7'), scale = header_scale * 0.6, colour = G.C.RED, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = vs_credit_20, scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = vs_credit_20_tag, scale = text_scale*0.45, colour = G.C.JOKER_GREY, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.05, colour = G.C.CLEAR, shadow = true}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.4, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = G.SETTINGS.roche and localize('vs_credits4') or "?????", scale = header_scale*0.6, colour = G.C.BLUE, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.SETTINGS.roche and vs_credit_8 or "?????", scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.SETTINGS.roche and vs_credit_8_tag or "?????", scale = text_scale*0.45, colour = G.C.JOKER_GREY, shadow = true}},
								}},
							}},
						}},
					}},
				}},
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes= {
					{ n = G.UIT.C, config = { align = "tm", padding = 0.1 * bonus_padding, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1 }, nodes = {
						{ n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
							{ n = G.UIT.T, config = { text = localize('vs_credits2'), scale = header_scale * 0.6, colour = HEX('f75294'), shadow = true } },
						} },
						{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_1, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_3, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_13, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_14, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_15, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_16, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_17, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_18, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_19, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_25, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_26, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_24, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_27, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_21, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
							}},
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_22, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_23, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_10, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_28, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_29, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
							}}
						}},
					} },
				}},
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes= {
					{ n = G.UIT.C, config = { align = "tm", padding = 0, r = 0.1, }, nodes = {
						{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
							{n=G.UIT.C, config={align = "tl", padding = 0.1*bonus_padding,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = localize('vs_credits3'), scale = header_scale*0.6, colour = G.C.ORANGE, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_1, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_2, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_4, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_5, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_6, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_7, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_13, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}},
							}},
							{n=G.UIT.C, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.3, colour = G.C.CLEAR, vert = true, shadow = true}},
								}},
							}},
							{n=G.UIT.C, config={align = "tl", padding = 0.1*bonus_padding,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = localize('vs_credits5'), scale = header_scale*0.55, colour = G.C.PURPLE, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_9, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_9_from, scale = text_scale*0.375, colour = G.C.JOKER_GREY, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_10, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_10_from, scale = text_scale*0.375, colour = G.C.JOKER_GREY, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_5, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_5_from, scale = text_scale*0.375, colour = G.C.JOKER_GREY, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_12, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_12_from, scale = text_scale*0.375, colour = G.C.JOKER_GREY, shadow = true}},
									}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.3, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = localize('vs_credits6'), scale = header_scale*0.55, colour = G.C.GREEN, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st1, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st3, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st5, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}},
								{n=G.UIT.C, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.15, colour = G.C.CLEAR, shadow = true}},
									}},
								}},
								{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st2, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st4, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}}
							}},
						}},
					}},
				}},
			}}
		}}
	}}
end
