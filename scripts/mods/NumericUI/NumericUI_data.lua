local mod = get_mod("NumericUI")


return {
	name = "Numeric UI",                            
	description = "Makes default HUD more informative and descriptive.",
	is_togglable = false,  -- not unless I'll make a good way of removing all these widgets injections I've made                       
	is_mutator = false,	                         
	
	
	options_widgets = {
	{
		["setting_name"] = "player_health",
		["widget_type"] = "dropdown",
		["text"] = "Numeric Health",
		["tooltip"] = "Displays numeric health values.\n\nDetailed - [Perm. Health + Temp. Health]\nTotal - [Sum] of Perm. and Temp. Health\nCombined - [Sum(Temp. Health)]\nDisable - Disables health numbers entirely",
		["options"] = {
			{text = "Detailed", value = 1},
			{text = "Total", value = 2},
			{text = "Combined", value = 3},
			{text = "Disabled", value = false}
		},
		["default_value"] = 1,
	},
	{
		["setting_name"] = "player_maxhp",
		["widget_type"] = "checkbox",
		["text"] = "Show Max Health",
		["tooltip"] = "\nWill only appear if 'Numeric Health' is enabled.",
		["default_value"] = true
	},
	{
		["setting_name"] = "teammate_health",
		["widget_type"] = "dropdown",
		["text"] = "Numeric Health (Team)",
		["tooltip"] = "Displays numeric health values for teammates.\n\nDetailed - [Perm. Health + Temp. Health]\nTotal - [Sum] of Perm. and Temp. Health\nCombined - [Sum(Temp. Health)]\nDisable - Disables health numbers entirely",
		["options"] = {
			{text = "Detailed", value = 1},
			{text = "Total", value = 2},
			{text = "Combined", value = 3},
			{text = "Disabled", value = false}
		},
		["default_value"] = 1,
	},
	{
		["setting_name"] = "teammate_maxhp",
		["widget_type"] = "checkbox",
		["text"] = "Show Max Health (Team)",
		["tooltip"] = "\nWill only appear if 'Numeric Health (Team)' is enabled.",
		["default_value"] = true
	},
	{
		["setting_name"] = "teammate_ammo",
		["widget_type"] = "dropdown",
		["text"] = "Ammo Counter (Team)",
		["tooltip"] = "Displays numeric ammo values for teammates.\n\nDetailed - [Current/Maximum]\nSimple - [Current]\nIcon Only - Icon without numeric values\nDisable - Disables ammo counter entirely",
		["options"] = {
			{text = "Detailed", value = 2},
			{text = "Simple", value = 1},
			{text = "Icon Only", value = 3},
			{text = "Disabled", value = false}
		},
		["default_value"] = 2
	},
	{
		["setting_name"] = "cooldown_timer",
		["widget_type"] = "dropdown",
		["text"] = "Career Skill Cooldown Timer",
		["tooltip"] = "Displays timer indicating an amount of time until character's career skill is recharged.",
		["options"] = {
			{text = "Own & Team", value = 1},
			{text = "Own", value = 2},
			{text = "Team", value = 3},
			{text = "Disabled", value = false}
		},
		["default_value"] = 1
	},
	{
		["setting_name"] = "teammate_deaths_door",
		["widget_type"] = "checkbox",
		["text"] = "Last Life Icon",
		["tooltip"] = "Displays icon indicating if character is on their last life (will die instead of being 'downed').",
		["default_value"] = true
	},
	{
		["setting_name"] = "teammate_nb",
		["widget_type"] = "checkbox",
		["text"] = "Natural Bond Icon",
		["tooltip"] = "Displays icon indicating if character has necklace with 'Natural Bond' trait equipped.",
		["default_value"] = true
	}
	}
}
