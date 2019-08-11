local mod = get_mod("NumericUI")

local SIZE_X = 1920
local SIZE_Y = 1080
local RETAINED_MODE_ENABLED = true
local portrait_scale = 1

-- gonna keep it here for referense, in case if I will have to do more workaround like this
--local PRE_1_2_1 = (tonumber(script_data.settings.content_revision) < 123106)

-- controller UI -----------------------------------------------------------

-- just so I can align that stupid cooldown properly :O
local custom_controller_ui_scenegraph = {
	vertical_alignment = "bottom",
	parent = "root",
	horizontal_alignment = "right",
	size = {
		0,
		0
	},
	position = {
		0,
		60,
		0
	}
}

local settings_controller_ui = {
	hp_bar = {
		z = -8,
		x = -276.5,
		y = 35
	}
}

-- now thats a needlessly long function name, right?
local function create_dynamic_health_widget_local_player_controller_ui()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content, style)
						return not content.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						local hp_bar_content = content.hp_bar
						local internal_bar_value = hp_bar_content.internal_bar_value
						local actual_active_percentage = content.actual_active_percentage or 1
						local grim_progress = math.max(internal_bar_value, actual_active_percentage)

						return grim_progress < 1
					end,
					content_change_function = function (content, style)
						local hp_bar_content = content.hp_bar
						local internal_bar_value = hp_bar_content.internal_bar_value
						local actual_active_percentage = content.actual_active_percentage or 1
						local grim_progress = math.max(internal_bar_value, actual_active_percentage)
						local offset = style.offset
						offset[1] = settings_controller_ui.hp_bar.x - 7 + 553 * grim_progress
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.draw_health_bar
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "total_health_bar",
					texture_id = "texture_id",
					content_id = "total_health_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_change_function = function (content, style)
						local parent_content = content.parent
						local hp_bar_content = parent_content.hp_bar
						local internal_bar_value = hp_bar_content.internal_bar_value
						local actual_active_percentage = parent_content.actual_active_percentage or 1
						local grim_progress = math.max(internal_bar_value, actual_active_percentage)
						local size = style.size
						local uvs = content.uvs
						local offset = style.offset
						local bar_length = 553
						uvs[1][1] = grim_progress
						size[1] = bar_length * (1 - grim_progress)
						offset[1] = 2 + settings_controller_ui.hp_bar.x + bar_length * grim_progress
					end
				},
				{
					style_id = "hp_text",
					pass_type = "text",
					text_id = "health_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.hp_bar.draw_health_bar
					end
				},
				{
					style_id = "hp_text_shadow",
					pass_type = "text",
					text_id = "health_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.hp_bar.draw_health_bar
					end
				},				
			}
		},
		content = {
			grimoire_debuff_divider = "hud_player_hp_bar_grim_divider",
			hp_bar_highlight = "hud_player_hp_bar_highlight",
			bar_start_side = "left",
			health_string = "",
			hp_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "player_hp_bar_color_tint",
				draw_health_bar = true
			},
			total_health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "player_hp_bar",
				draw_health_bar = true
			},
			grimoire_bar = {
				texture_id = "hud_panel_hp_bar_bg_grimoire",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		},
		style = {
			total_health_bar = {
				gradient_threshold = 1,
				size = {
					553,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					settings_controller_ui.hp_bar.x,
					settings_controller_ui.hp_bar.y,
					settings_controller_ui.hp_bar.z + 2
				}
			},
			hp_bar = {
				gradient_threshold = 1,
				size = {
					553,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					settings_controller_ui.hp_bar.x,
					settings_controller_ui.hp_bar.y,
					settings_controller_ui.hp_bar.z + 3
				}
			},
			grimoire_bar = {
				size = {
					553,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					settings_controller_ui.hp_bar.x,
					settings_controller_ui.hp_bar.y,
					settings_controller_ui.hp_bar.z + 4
				}
			},
			grimoire_debuff_divider = {
				size = {
					21,
					36
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					settings_controller_ui.hp_bar.x + 10,
					settings_controller_ui.hp_bar.y - 8,
					settings_controller_ui.hp_bar.z + 20
				}
			},
			hp_bar_highlight = {
				size = {
					553,
					30
				},
				offset = {
					settings_controller_ui.hp_bar.x,
					settings_controller_ui.hp_bar.y - 4,
					settings_controller_ui.hp_bar.z + 5
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			-- health text
			hp_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = {
					255,
					225,
					205,
					225
				},
				offset = {
					0, settings_controller_ui.hp_bar.y + 7, settings_controller_ui.hp_bar.z + 22
				}
			},
			hp_text_shadow = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_table("black"),
				offset = {
					2, settings_controller_ui.hp_bar.y + 7 - 2, settings_controller_ui.hp_bar.z + 21
				}
			},			
		},
		offset = {
			0,
			0,
			0
		}
	}
end

-- unlike in PC UI, I can't just get away with parenting cooldown text relative to health widget, sooooooo...
local function create_dynamic_ability_widget_local_player_controller_ui()
	return {
		scenegraph_id = "ability",
		element = {
			passes = {
				-- ability cooldown text
				{
					style_id = "cooldown_text",
					pass_type = "text",
					text_id = "cooldown_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.cooldown_string ~= "0:00"
					end
				},
				{
					style_id = "cooldown_text_shadow",
					pass_type = "text",
					text_id = "cooldown_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.cooldown_string ~= "0:00"
					end
				},
				{
					style_id = "ability_bar",
					pass_type = "texture",
					texture_id = "texture_id",
					content_id = "ability_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_change_function = function (content, style)
						local ability_progress = content.bar_value
						local size = style.texture_size
						local offset = style.offset
						offset[2] = -size[2] + size[2] * ability_progress
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_bar_mask",
					texture_id = "ability_bar_mask",
					retained_mode = RETAINED_MODE_ENABLED
				},				
			}
		},
		content = {
			ability_bar_mask = "gamepad_ability_outline_mask",
			bar_start_side = "left",
			cooldown_string = "0:00",
			ability_bar = {
				bar_value = 1,
				texture_id = "gamepad_ability_outline_fill"
			}
		},
		style = {
			ability_bar = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					101,
					133
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			ability_bar_mask = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					96,
					115
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			--ability timer text
			cooldown_text = {
				scenegraph_id = "ability_cooldown_root",
				word_wrap = false,
				font_size = 24,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					22,
					18
				},
				offset = {
					-77,
					152,
					105
				}
			},
			cooldown_text_shadow = {
				scenegraph_id = "ability_cooldown_root",
				word_wrap = false,
				font_size = 24,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					22,
					18
				},
				offset = {
					-75,
					150,
					104
				}
			},
		},
		offset = {
			-15,
			15,
			0
		}
	}
end



-- PC UI -------------------------------------------------------------------

local settings = {
	hp_bar = {
		z = -8,
		x = -232,
		y = 10
	},
	ability_bar = {
		z = -8,
		x = -224,
		y = 33
	}
}

-- change our own healthbar
local function create_dynamic_health_widget_local_player()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content, style)
						return not content.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						local hp_bar_content = content.hp_bar
						local internal_bar_value = hp_bar_content.internal_bar_value
						local actual_active_percentage = content.actual_active_percentage or 1
						local grim_progress = math.max(internal_bar_value, actual_active_percentage)

						return grim_progress < 1
					end,
					content_change_function = function (content, style)
						local hp_bar_content = content.hp_bar
						local internal_bar_value = hp_bar_content.internal_bar_value
						local actual_active_percentage = content.actual_active_percentage or 1
						local grim_progress = math.max(internal_bar_value, actual_active_percentage)
						local offset = style.offset
						offset[1] = settings.hp_bar.x - 7 + 464 * grim_progress
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.draw_health_bar
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "total_health_bar",
					texture_id = "texture_id",
					content_id = "total_health_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_change_function = function (content, style)
						local parent_content = content.parent
						local hp_bar_content = parent_content.hp_bar
						local internal_bar_value = hp_bar_content.internal_bar_value
						local actual_active_percentage = parent_content.actual_active_percentage or 1
						local grim_progress = math.max(internal_bar_value, actual_active_percentage)
						local size = style.size
						local uvs = content.uvs
						local offset = style.offset
						local bar_length = 464
						uvs[1][1] = grim_progress
						size[1] = bar_length * (1 - grim_progress)
						offset[1] = 2 + settings.hp_bar.x + bar_length * grim_progress
					end
				},
				{
					style_id = "hp_text",
					pass_type = "text",
					text_id = "health_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.hp_bar.draw_health_bar
						--return content.draw_health_bar
					end
				},
				{
					style_id = "hp_text_shadow",
					pass_type = "text",
					text_id = "health_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.hp_bar.draw_health_bar
						--return content.draw_health_bar
					end
				},
				
				-- ideally I should've put this somewhere but the health widget, so don't judge me :v
				
				{
					style_id = "cooldown_text",
					pass_type = "text",
					text_id = "cooldown_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.cooldown_string == "0:00" then return end
						return content.hp_bar.draw_health_bar
					end
				},
				{
					style_id = "cooldown_text_shadow",
					pass_type = "text",
					text_id = "cooldown_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.cooldown_string == "0:00" then return end
						return content.hp_bar.draw_health_bar
					end
				},
				
			}
		},
		content = {
			grimoire_debuff_divider = "hud_player_hp_bar_grim_divider",
			hp_bar_highlight = "hud_player_hp_bar_highlight",
			bar_start_side = "left",
			health_string = "",
			cooldown_string = "0:00",
			hp_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "player_hp_bar_color_tint",
				draw_health_bar = true
			},
			total_health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "player_hp_bar",
				draw_health_bar = true
			},
			grimoire_bar = {
				texture_id = "hud_panel_hp_bar_bg_grimoire",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		},
		style = {
			total_health_bar = {
				gradient_threshold = 1,
				size = {
					464,
					19
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					settings.hp_bar.x,
					settings.hp_bar.y,
					settings.hp_bar.z + 2
				}
			},
			hp_bar = {
				gradient_threshold = 1,
				size = {
					464,
					19
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					settings.hp_bar.x,
					settings.hp_bar.y,
					settings.hp_bar.z + 3
				}
			},
			grimoire_bar = {
				size = {
					464,
					19
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					settings.hp_bar.x,
					settings.hp_bar.y,
					settings.hp_bar.z + 4
				}
			},
			grimoire_debuff_divider = {
				size = {
					21,
					36
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					settings.hp_bar.x + 10,
					settings.hp_bar.y - 8,
					settings.hp_bar.z + 20
				}
			},
			hp_bar_highlight = {
				size = {
					464,
					30
				},
				offset = {
					settings.hp_bar.x,
					settings.hp_bar.y - 4,
					settings.hp_bar.z + 5
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			hp_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = {
					255,
					225,
					205,
					225
				},
				offset = {
					0, settings.hp_bar.y + 8, settings.hp_bar.z + 22
				}
			},
			hp_text_shadow = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_table("black"),
				offset = {
					2, settings.hp_bar.y + 8 - 2, settings.hp_bar.z + 21
				}
			},
			cooldown_text = {
				word_wrap = false,
				font_size = 16,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					22,
					22
				},
				offset = {
					251,
					78,
					2
				}
			},
			cooldown_text_shadow = {
				word_wrap = false,
				font_size = 16,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					22,
					22
				},
				offset = {
					253,
					76,
					1
				}
			},
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function create_dynamic_portait_widget_local_player()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.display_portrait_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator",
					texture_id = "talk_indicator",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_glow",
					texture_id = "talk_indicator_glow",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight",
					texture_id = "talk_indicator_highlight",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight_glow",
					texture_id = "talk_indicator_highlight_glow",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "rotated_texture",
					style_id = "connecting_icon",
					texture_id = "connecting_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.connecting
					end
				},
				{
					pass_type = "texture",
					style_id = "wounded_icon",
					texture_id = "wounded_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.is_at_deaths_door
					end
				},
			}
		},
		content = {
			display_portrait_overlay = false,
			connecting = false,
			display_portrait_icon = false,
			is_at_deaths_door = false,
			wounded_icon = "tabs_icon_all_selected",
			connecting_icon = "matchmaking_connecting_icon",
			talk_indicator_highlight = "voip_wave",
			talk_indicator_highlight_glow = "voip_wave_glow",
			talk_indicator = "voip_speaker",
			talk_indicator_glow = "voip_speaker_glow",
			portrait_icon = "status_icon_needs_assist"
		},
		style = {
			talk_indicator = {
				scenegraph_id = "portrait_pivot",
				size = {
					64,
					64
				},
				offset = {
					60,
					6,
					3
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			talk_indicator_glow = {
				scenegraph_id = "portrait_pivot",
				size = {
					64,
					64
				},
				offset = {
					60,
					6,
					2
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			talk_indicator_highlight = {
				scenegraph_id = "portrait_pivot",
				size = {
					64,
					64
				},
				offset = {
					60,
					6,
					3
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			talk_indicator_highlight_glow = {
				scenegraph_id = "portrait_pivot",
				size = {
					64,
					64
				},
				offset = {
					60,
					6,
					2
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			connecting_icon = {
				vertical_alignment = "center",
				scenegraph_id = "portrait_pivot",
				horizontal_alignment = "center",
				angle = 0,
				pivot = {
					26.5,
					26.5
				},
				texture_size = {
					53,
					53
				},
				offset = {
					0,
					0,
					12
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			portrait_icon = {
				vertical_alignment = "center",
				scenegraph_id = "portrait_pivot",
				horizontal_alignment = "center",
				texture_size = {
					86,
					108
				},
				offset = {
					0,
					0,
					7
				},
				color = {
					150,
					255,
					255,
					255
				}
			},
			wounded_icon = {
				scenegraph_id = "portrait_pivot",
				size = {
					28,
					28
				},
				offset = {
					37,
					-63, -- 55 -40
					50
				},
				color = {
					205,
					255,
					255,
					255
				}
			},
		},
		offset = {
			0,
			0,
			0
		}
	}
end

-- changing some stuff in widgets for teammates
local slot_scale = 1

local health_bar_size_fraction = 1
local new_healthbar_size = 110--92
local diff = new_healthbar_size - 92
local health_bar_size = {
	health_bar_size_fraction * new_healthbar_size,
	health_bar_size_fraction * 18 --9
}
local health_bar_offset = {
	-(health_bar_size[1] / 2),
	-30 * health_bar_size_fraction, -- -25
	0
}

-- for items we only need to move these a bit
local override_dynamic_loadout_widget_offset = {
	-15,
	health_bar_offset[2] - 96 - 8,
	0
}

-- move ability bar and make it fit
local function create_dynamic_ability_widget()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					style_id = "ability_bar",
					pass_type = "texture_uv",
					content_id = "ability_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_change_function = function (content, style)
						local ability_progress = content.bar_value
						local size = style.size
						local uvs = content.uvs
						local offset = style.offset
						local bar_length = health_bar_size[1]
						uvs[2][2] = ability_progress
						size[1] = bar_length * ability_progress
					end
				}
			}
		},
		content = {
			bar_start_side = "left",
			ability_bar = {
				bar_value = 1,
				texture_id = "hud_teammate_ability_bar_fill",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		},
		style = {
			ability_bar = {
				size = {
					health_bar_size[1],
					8
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					(health_bar_offset[1] + health_bar_size[1] / 2) - 46 - diff/2,
					health_bar_offset[2] - 9 - 4,
					health_bar_offset[3] + 18
				}
			}
		},
		offset = {
			0,
			-55 * portrait_scale,
			0
		}
	}
end

-- fix healthbar frame, since it's going to be a bit bigger
local function create_static_widget()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "character_portrait",
					texture_id = "character_portrait",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					style_id = "player_level",
					pass_type = "text",
					text_id = "player_level",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "host_icon",
					texture_id = "host_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.is_host
					end
				},
				{
					style_id = "player_name",
					pass_type = "text",
					text_id = "player_name",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					style_id = "player_name_shadow",
					pass_type = "text",
					text_id = "player_name",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_bg",
					texture_id = "hp_bar_bg",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_fg",
					texture_id = "hp_bar_fg",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "ability_bar_bg",
					texture_id = "ability_bar_bg",
					retained_mode = RETAINED_MODE_ENABLED
				}
			}
		},
		content = {
			character_portrait = "unit_frame_portrait_default",
			player_name = "n/a",
			host_icon = "host_icon",
			hp_bar_bg = "hud_teammate_hp_bar_bg",
			is_host = false,
			player_level = "",
			hp_bar_fg = "hud_teammate_hp_bar_frame",
			ability_bar_bg = "hud_teammate_ability_bar_bg"
		},
		style = {
			character_portrait = {
				size = {
					86 * portrait_scale,
					108 * portrait_scale
				},
				offset = {
					-43 * portrait_scale,
					-54 * portrait_scale + 55 * portrait_scale,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			host_icon = {
				size = {
					18,
					14
				},
				offset = {
					-50,
					10,
					50
				},
				color = {
					150,
					255,
					255,
					255
				}
			},
			player_level = {
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = 14,
				horizontal_alignment = "center",
				text_color = Colors.get_table("cheeseburger"),
				offset = {
					health_bar_offset[1],
					health_bar_offset[2] - 130,
					health_bar_offset[3] + 15
				}
			},
			player_name = {
				vertical_alignment = "bottom",
				font_type = "arial",
				font_size = 18,
				horizontal_alignment = "center",
				text_color = Colors.get_table("white"),
				offset = {
					0,
					110 * portrait_scale,
					health_bar_offset[3] + 15
				}
			},
			player_name_shadow = {
				vertical_alignment = "bottom",
				font_type = "arial",
				font_size = 18,
				horizontal_alignment = "center",
				text_color = Colors.get_table("black"),
				offset = {
					2,
					110 * portrait_scale - 2,
					health_bar_offset[3] + 14
				}
			},
			hp_bar_bg = {
				size = {
					100 + diff,
					30--17
				},
				offset = {
					(health_bar_offset[1] + health_bar_size[1] / 2) - 50 - diff/2,
					(health_bar_offset[2] + health_bar_size[2] / 2) - 8.5 - 11,
					health_bar_offset[3] + 15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar_fg = {
				size = {
					100 + diff,
					37--24
				},
				offset = {
					(health_bar_offset[1] + health_bar_size[1] / 2) - 50 - diff/2,
					(health_bar_offset[2] + health_bar_size[2] / 2) - 8.5 - 7 - 11,
					health_bar_offset[3] + 20
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			ability_bar_bg = {
				size = {
					health_bar_size[1],
					10
				},
				offset = {
					(health_bar_offset[1] + health_bar_size[1] / 2) - 46 - diff/2,
					health_bar_offset[2] - 9 - 5,
					health_bar_offset[3] + 15
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			-55 * portrait_scale,
			0
		}
	}
end

-- replace old ammo indicator with a new one (I know there are leftovers from overcharge that I had to disable, but whatever)
local function create_dynamic_portait_widget()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.display_portrait_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator",
					texture_id = "talk_indicator",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_glow",
					texture_id = "talk_indicator_glow",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight",
					texture_id = "talk_indicator_highlight",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight_glow",
					texture_id = "talk_indicator_highlight_glow",
					retained_mode = RETAINED_MODE_ENABLED
				},
				{
					pass_type = "rotated_texture",
					style_id = "connecting_icon",
					texture_id = "connecting_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.connecting
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator_full",
					texture_id = "ammo_indicator",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.ammo_string and content.ammo_string == "-1" then return false end
						if content.ammo_string and content.ammo_string == "-1/-1" then return false end
						local ammo_progress = content.ammo_percent
						local check = ammo_progress and ammo_progress <= 1 and ammo_progress > 0.5
						return not content.is_overcharge and check
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator_half",
					texture_id = "ammo_indicator",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.ammo_string and content.ammo_string == "-1" then return false end
						if content.ammo_string and content.ammo_string == "-1/-1" then return false end
						local ammo_progress = content.ammo_percent
						local check = ammo_progress and ammo_progress <= 0.5 and ammo_progress > 0.25
						return not content.is_overcharge and check
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator_quarter",
					texture_id = "ammo_indicator",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.ammo_string and content.ammo_string == "-1" then return false end
						if content.ammo_string and content.ammo_string == "-1/-1" then return false end
						local ammo_progress = content.ammo_percent
						local check = ammo_progress and ammo_progress <= 0.25 and ammo_progress > 0
						return not content.is_overcharge and check
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator_empty",
					texture_id = "ammo_indicator_empty",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.ammo_string and content.ammo_string == "-1" then return false end
						if content.ammo_string and content.ammo_string == "-1/-1" then return false end
						local ammo_progress = content.ammo_percent
						local check = ammo_progress and ammo_progress == 0
						return not content.is_overcharge and check 
					end
				},
				{
					style_id = "ammo_text",
					pass_type = "text",
					text_id = "ammo_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_change_function = function (content, style)
						style.font_size = content.ammo_style == 2 and 18 or 22
						style.font_type = content.ammo_style == 2 and "hell_shark_header" or "hell_shark" 
					end,
					content_check_function = function (content)
						if content.ammo_string and content.ammo_string == "-1" then return false end
						if content.ammo_string and content.ammo_string == "-1/-1" then return false end
						local ammo_progress = content.ammo_percent
						local check = ammo_progress and ammo_progress >= 0
						return not content.is_overcharge and check
					end
				},
				{
					style_id = "ammo_text_shadow",
					pass_type = "text",
					text_id = "ammo_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_change_function = function (content, style)
						style.font_size = content.ammo_style == 2 and 18 or 22
						style.font_type = content.ammo_style == 2 and "hell_shark_header" or "hell_shark" 
					end,
					content_check_function = function (content)
						if content.ammo_string and content.ammo_string == "-1" then return false end
						if content.ammo_string and content.ammo_string == "-1/-1" then return false end
						local ammo_progress = content.ammo_percent
						local check = ammo_progress and ammo_progress >= 0
						return not content.is_overcharge and check
					end
				},
				{
					pass_type = "texture",
					style_id = "overcharge_indicator",
					texture_id = "overcharge_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return false
						--return content.is_overcharge
					end
				},
				{
					style_id = "overcharge_text",
					pass_type = "text",
					text_id = "ammo_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return false -- until there is a way to get overcharge
						--return content.is_overcharge
					end
				},
				{
					style_id = "overcharge_text_shadow",
					pass_type = "text",
					text_id = "ammo_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return false -- until there is a way to get overcharge
						--return content.is_overcharge
					end
				},
				{
					pass_type = "texture",
					style_id = "wounded_icon",
					texture_id = "wounded_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_change_function = function (content, style)
						style.offset[1] = content.has_natural_bond and 85 or 60
					end,
					content_check_function = function (content)
						return content.is_at_deaths_door
					end
				},
				{
					pass_type = "texture",
					style_id = "nb_icon",
					texture_id = "nb_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.has_natural_bond
					end
				},
				{
					style_id = "cooldown_text",
					pass_type = "text",
					text_id = "cooldown_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.cooldown_string == "0:00" then return end
						return true
					end
				},
				{
					style_id = "cooldown_text_shadow",
					pass_type = "text",
					text_id = "cooldown_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.cooldown_string == "0:00" then return end
						return true
					end
				},
				
			}
		},
		content = {
			talk_indicator_highlight = "voip_wave",
			connecting = false,
			talk_indicator_glow = "voip_speaker_glow",
			talk_indicator_highlight_glow = "voip_wave_glow",
			talk_indicator = "voip_speaker",
			ammo_string = "32",
			ammo_style = 1,
			overcharge_icon = "tooltip_icon_overheat",
			is_overcharge = false,
			display_portrait_icon = false,
			ammo_indicator_empty = "unit_frame_ammo_empty",
			bar_start_side = "left",
			portrait_icon = "status_icon_needs_assist",
			display_portrait_overlay = false,
			connecting_icon = "matchmaking_connecting_icon",
			wounded_icon = "tabs_icon_all_selected",
			nb_icon = "necklace_no_healing_health_regen",
			is_at_deaths_door = false, -- something about how quickly the tide turns
			has_natural_bond = false,
			ammo_indicator = "unit_frame_ammo_low",
			cooldown_string = "0:00",
			ammo_bar = {
				bar_value = 1,
				texture_id = "hud_teammate_ammo_bar_fill",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		},
		style = {
			-- 50 - 100%
			ammo_indicator_full = {
				size = {
					32,
					32
				},
				offset = {
					55 + 5,
					55, -- -40
					5
				},
				color = {
					255,
					1,
					255,
					255
				}
			},
			-- 25 - 50%
			ammo_indicator_half = {
				size = {
					32,
					32
				},
				offset = {
					55 + 5,
					55, -- -40
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			-- 1 - 25%
			ammo_indicator_quarter = {
				size = {
					32,
					32
				},
				offset = {
					55 + 5,
					55, -- -40
					5
				},
				color = {
					255,
					255,
					148, --128
					255
				}
			},
			-- oh no, it is empty!
			ammo_indicator_empty = {
				size = {
					32,
					32
				},
				offset = {
					55 + 5,
					55, -- -40
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			overcharge_indicator = {
				size = {
					32,
					32
				},
				offset = {
					55 + 5,
					46, -- 55 -40
					5
				},
				color = {
					255,
					225,
					145,
					145
				}
			},
			ammo_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 22,
				horizontal_alignment = "center",
				text_color = Colors.get_table("white"),
				offset = {
					60 + 8 + 6,
					45, -- -40
					51
				}
			},
			ammo_text_shadow = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 22,
				horizontal_alignment = "center",
				text_color = Colors.get_table("black"),
				offset = {
					60 + 8 + 8,
					45 - 2, -- -40
					50
				}
			},
			wounded_icon = {
				size = {
					32,
					32
				},
				offset = {
					60,
					-45, -- 55 -40
					5
				},
				color = {
					205,
					255,
					255,
					255
				}
			},
			nb_icon = {
				size = {
					22,
					22
				},
				offset = {
					65,
					-40,
					5
				},
				color = {
					165,
					105,
					255,
					105
				}
			},
			cooldown_text = {
				font_size = 16,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					22,
					22
				},
				offset = {
					64,
					0, -- -2 -75
					5
				}
			},
			cooldown_text_shadow = {
				font_size = 16,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					22,
					22
				},
				offset = {
					66,
					-2, -- -2 -77
					4
				}
			},
			overcharge_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 19,
				horizontal_alignment = "center",
				text_color = Colors.get_table("white"),
				offset = {
					60 + 8 + 10,
					45, -- -40
					5
				}
			},
			overcharge_text_shadow = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 19,
				horizontal_alignment = "center",
				text_color = Colors.get_table("black"),
				offset = {
					60 + 8 + 10,
					45 - 2, -- -40
					4
				}
			},
			talk_indicator = {
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
					3
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			talk_indicator_glow = {
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
					2
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			talk_indicator_highlight = {
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
					3
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			talk_indicator_highlight_glow = {
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
					2
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			connecting_icon = {
				angle = 0,
				size = {
					53,
					53
				},
				offset = {
					-25,
					34,
					15
				},
				color = {
					255,
					255,
					255,
					255
				},
				pivot = {
					27,
					27
				}
			},
			portrait_icon = {
				size = {
					86 * portrait_scale,
					108 * portrait_scale
				},
				offset = {
					-(86 * portrait_scale) / 2,
					0,
					1
				},
				color = {
					150,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			-55 * portrait_scale,
			0
		}
	}
end


-- change health widget + health numbers
local function create_dynamic_health_widget()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content, style)
						return not content.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.hp_bar.draw_health_bar
					end,
					content_change_function = function (content, style)
						local hp_bar_content = content.hp_bar
						local internal_bar_value = hp_bar_content.internal_bar_value
						local actual_active_percentage = content.actual_active_percentage or 1
						local grim_progress = math.max(internal_bar_value, actual_active_percentage)
						local offset = style.offset
						offset[1] = health_bar_offset[1] + health_bar_size[1] * grim_progress
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.draw_health_bar
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "total_health_bar",
					texture_id = "texture_id",
					content_id = "total_health_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = RETAINED_MODE_ENABLED,
					content_change_function = function (content, style)
						local parent_content = content.parent
						local hp_bar_content = parent_content.hp_bar
						local internal_bar_value = hp_bar_content.internal_bar_value
						local actual_active_percentage = parent_content.actual_active_percentage or 1
						local grim_progress = math.max(internal_bar_value, actual_active_percentage)
						local size = style.size
						local uvs = content.uvs
						local offset = style.offset
						local bar_length = health_bar_size[1]
						uvs[1][1] = grim_progress
						size[1] = bar_length * (1 - grim_progress)
						offset[1] = 2 + health_bar_offset[1] + bar_length * grim_progress
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar",
					texture_id = "hp_bar_mask",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.hp_bar.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						return content.display_portrait_icon
					end
				},
				{
					style_id = "hp_text",
					pass_type = "text",
					text_id = "health_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.health_string == "0/0" then return end
						if content.health_string == "0" then return end
						return content.hp_bar.draw_health_bar
					end
				},
				{
					style_id = "hp_text_shadow",
					pass_type = "text",
					text_id = "health_string",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						if content.health_string == "0/0" then return end
						if content.health_string == "0" then return end
						return content.hp_bar.draw_health_bar
					end
				},
			}
		},
		content = {
			health_string = "",
			grimoire_debuff_divider = "hud_teammate_hp_bar_grim_divider",
			hp_bar_highlight = "hud_teammate_hp_bar_highlight",
			bar_start_side = "left",
			hp_bar_mask = "teammate_hp_bar_mask",
			hp_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "teammate_hp_bar_color_tint_1",
				draw_health_bar = true
			},
			total_health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "teammate_hp_bar_1",
				draw_health_bar = true
			},
			grimoire_bar = {
				texture_id = "hud_panel_hp_bar_bg_grimoire",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		},
		style = {
			total_health_bar = {
				gradient_threshold = 1,
				size = {
					health_bar_size[1],
					health_bar_size[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					health_bar_offset[1],
					health_bar_offset[2],
					health_bar_offset[3] + 17
				}
			},
			hp_bar = {
				gradient_threshold = 1,
				size = {
					health_bar_size[1],
					health_bar_size[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					health_bar_offset[1],
					health_bar_offset[2],
					health_bar_offset[3] + 18
				}
			},
			grimoire_bar = {
				size = {
					health_bar_size[1],
					health_bar_size[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					health_bar_offset[1],
					health_bar_offset[2],
					health_bar_offset[3] + 16
				}
			},
			grimoire_debuff_divider = {
				masked = true,
				size = {
					3,
					28
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					health_bar_offset[1],
					health_bar_offset[2],
					23
				}
			},
			hp_bar_highlight = {
				size = {
					100,
					17
				},
				offset = {
					(health_bar_offset[1] + health_bar_size[1] / 2) - 50,
					health_bar_offset[2] - 7,
					health_bar_offset[3] + 19
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			hp_text = {
				vertical_alignment = "center",
				font_type = "hell_shark_arial",
				font_size = 17,
				horizontal_alignment = "center",
				text_color = Colors.get_table("white"),
				offset = {
					0, health_bar_offset[2] + health_bar_size[2] / 2 - 2, health_bar_offset[3] + 25
				}
			},
			hp_text_shadow = {
				vertical_alignment = "center",
				font_type = "hell_shark_arial",
				font_size = 17,
				horizontal_alignment = "center",
				text_color = Colors.get_table("black"),
				offset = {
					1, health_bar_offset[2] + health_bar_size[2] / 2 - 2 - 1, health_bar_offset[3] + 24
				}
			}
			
		},
		offset = {
			0,
			-55 * portrait_scale,
			0
		}
	}
end

-- messy way to make sure it shows proper ammo for all characters and careers
-- "trust but verify"
local ranger_buffs = TalentBuffTemplates and TalentBuffTemplates.dwarf_ranger
local ranger_passive_ammo = ranger_buffs and ranger_buffs.bardin_ranger_passive_increased_ammunition

local wh_buffs = TalentBuffTemplates and TalentBuffTemplates.witch_hunter
local bh_passive_ammo = wh_buffs and wh_buffs.victor_bountyhunter_passive_increased_ammunition
local wh_talent_ammo = wh_buffs and wh_buffs.victor_witchhunter_max_ammo

local elf_buffs = TalentBuffTemplates and TalentBuffTemplates.wood_elf
local ww_passive_ammo = elf_buffs and elf_buffs.kerillian_waywatcher_passive_increased_ammunition
local mg_talent_ammo = elf_buffs and elf_buffs.kerillian_maidenguard_max_ammo

local es_buffs = TalentBuffTemplates and TalentBuffTemplates.empire_soldier
local mh_passive_ammo = es_buffs and es_buffs.markus_huntsman_passive_increased_ammunition
local mrc_talent_ammo = es_buffs and es_buffs.markus_mercenary_max_ammo


local career_ammo = {
	["dr_ranger"] = ranger_passive_ammo and ranger_passive_ammo.buffs and ranger_passive_ammo.buffs[1] and ranger_passive_ammo.buffs[1].multiplier or 0,
	["wh_bountyhunter"] = bh_passive_ammo and bh_passive_ammo.buffs and bh_passive_ammo.buffs[1] and bh_passive_ammo.buffs[1].multiplier or 0,
	["we_waywatcher"] = ww_passive_ammo and ww_passive_ammo.buffs and ww_passive_ammo.buffs[1] and ww_passive_ammo.buffs[1].multiplier or 0,
	["es_huntsman"] = mh_passive_ammo and mh_passive_ammo.buffs and mh_passive_ammo.buffs[1] and mh_passive_ammo.buffs[1].multiplier or 0
}

-- oh and talents, I suppose
local career_talents_ammo = {
	["we_maidenguard"] = mg_talent_ammo and mg_talent_ammo.buffs and mg_talent_ammo.buffs[1] and mg_talent_ammo.buffs[1].multiplier or 0,
	["wh_captain"] = wh_talent_ammo and wh_talent_ammo.buffs and wh_talent_ammo.buffs[1] and wh_talent_ammo.buffs[1].multiplier or 0,
	["es_mercenary"] = mrc_talent_ammo and mrc_talent_ammo.buffs and mrc_talent_ammo.buffs[1] and mrc_talent_ammo.buffs[1].multiplier or 0
}


-- based on the only way to get ammo from teammates
local ammo_delta = 0.005
local function calculate_ammo( weapon_template, game, go_id, career_extension, data, player_unit )

	local result = 0
	local result_max = 0
	local talent_ammo = nil

	if weapon_template and weapon_template.ammo_data and game and go_id and career_extension then
		
		local percentage = GameSession.game_object_field(game, go_id, "ammo_percentage")
		local max_ammo = weapon_template.ammo_data.max_ammo
		
		if max_ammo then
		
			local career_name = career_extension:career_name()
		
			-- check extra ammo from careers
			if career_name and career_ammo[ career_name ] then
				max_ammo = math.ceil( max_ammo * ( 1 + career_ammo[ career_name ] ) )
			end
					
			-- save our base ammo for comparison
			local base_ammo = max_ammo * 1
			
			result_max = max_ammo
			
			-- and extra ammo from talents		
			if career_name and career_talents_ammo[ career_name ] then
				
				data.got_talent_ammo = data.got_talent_ammo or false
				data.checked_for_talent_ammo = data.checked_for_talent_ammo or false
				
				if data.checked_for_talent_ammo then
					
					if data.got_talent_ammo then
						
						max_ammo = math.ceil( max_ammo * ( 1 + career_talents_ammo[ career_name ] ) ) 
						result_max = max_ammo
						
					end
					
				else
					
					
					local got_talent = false
					
					max_ammo = math.ceil( max_ammo * ( 1 + career_talents_ammo[ career_name ] ) )
				
					local one_shot_default = math.round( 1 / base_ammo * 1000 ) / 1000
					local one_shot_talent = math.round( 1 / max_ammo * 1000 ) / 1000
					
					-- check for multishots for witch hunter
					local eight_shot_default = math.round( 1 / base_ammo * 1000 ) / 1000 * 8
					local eight_shot_talent = math.round( 1 / max_ammo * 1000 ) / 1000 * 8
					
					local triple_shot_default = math.round( 3 / base_ammo * 1000 ) / 1000
					local triple_shot_talent = math.round( 1 / max_ammo * 1000 ) / 1000 * 3
					
					data.last_ammo_count = data.last_ammo_count or percentage
					
					local ammo_diff = math.round( ( data.last_ammo_count - percentage ) * 1000 ) / 1000
					
					if ammo_diff > 0 then
									
						-- check single shots with talent equipped
						if math.abs( ammo_diff - one_shot_talent ) < ammo_delta then
							got_talent = true
						end
						
						-- check 8 shots (repeater handgun)
						if math.abs( ammo_diff - eight_shot_talent ) < ammo_delta then
							got_talent = true
						end
						
						-- check 3 shots (repeater crossbow)
						if math.abs( ammo_diff - triple_shot_talent ) < ammo_delta then
							got_talent = true
						end
						
						data.checked_for_talent_ammo = true
						
					end
					
					data.last_ammo_count = percentage
					
					if got_talent then
						data.got_talent_ammo = true
						result_max = max_ammo
					end
									
				end
			else
				-- reset just in case
				if data.checked_for_talent_ammo then
					data.checked_for_talent_ammo = false
				end
				if data.got_talent_ammo then
					data.got_talent_ammo = false
				end
				
				
			end		

			result = math.round( result_max * percentage )
		end

	end
	
	return result, result_max
	
end

-- inject our own definitions into UnitFrameHandler
-- "UnitFramesHandler._create_unit_frame_by_type"
mod:hook( UnitFramesHandler, "_create_unit_frame_by_type", function (func, self, frame_type, frame_index)
	local ingame_ui_context = self.ingame_ui_context
	local unit_frame = {}
	local state_data = {}
	local player_data = {}
	local definitions = nil
	
	if frame_type == "team" then
		definitions = local_require("scripts/ui/hud_ui/team_member_unit_frame_ui_definitions")
		
		mod:pcall( function() 
			definitions.widget_definitions.default_static = create_static_widget()
			definitions.widget_definitions.health_dynamic = create_dynamic_health_widget()
			definitions.widget_definitions.ability_dynamic = create_dynamic_ability_widget()
			definitions.widget_definitions.default_dynamic = create_dynamic_portait_widget()
			definitions.widget_definitions.loadout_dynamic.offset = override_dynamic_loadout_widget_offset
		end )
		
	elseif frame_type == "player" then
		local gamepad_active = self.input_manager:is_device_active("gamepad")
		
		if self.platform ~= "win32" or ((gamepad_active or UISettings.use_gamepad_hud_layout == "always") and UISettings.use_gamepad_hud_layout ~= "never") then
			definitions = local_require("scripts/ui/hud_ui/player_console_unit_frame_ui_definitions")
			unit_frame.gamepad_version = true
			
			mod:pcall( function()
				-- make something that we can anchor our cooldown text to
				definitions.scenegraph_definition.ability_cooldown_root = custom_controller_ui_scenegraph
			
				definitions.widget_definitions.health_dynamic = create_dynamic_health_widget_local_player_controller_ui()
				definitions.widget_definitions.ability_dynamic = create_dynamic_ability_widget_local_player_controller_ui()
				-- portrait area seems to be the same as PC one, so lets just copy that one instead
				definitions.widget_definitions.default_dynamic = create_dynamic_portait_widget_local_player()
			end )
		else
			definitions = local_require("scripts/ui/hud_ui/player_unit_frame_ui_definitions")
		
			mod:pcall( function() 
				definitions.widget_definitions.health_dynamic = create_dynamic_health_widget_local_player()
				definitions.widget_definitions.default_dynamic = create_dynamic_portait_widget_local_player()
			end )
		end
		
	else
		definitions = local_require("scripts/ui/hud_ui/team_member_unit_frame_ui_definitions")
	end
	
	unit_frame.data = state_data
	unit_frame.player_data = player_data
	unit_frame.definitions = definitions
	unit_frame.features_list = definitions.features_list
	unit_frame.widget_name_by_feature = definitions.widget_name_by_feature	
	unit_frame.widget = UnitFrameUI:new(ingame_ui_context, definitions, state_data, frame_index, player_data)

	return unit_frame	
end)


-- get direct cooldown times in case if they will be changed at some point
local cooldown_table = {
	
	-- kruber
	["es_mercenary"] = "es_3",
	["es_huntsman"] = "es_1",
	["es_knight"] = "es_2",
	
	-- dwarf
	["dr_ranger"] = "dr_3",
	["dr_ironbreaker"] = "dr_1",
	["dr_slayer"] = "es_2",
	
	-- elf
	["we_waywatcher"] = "we_3",
	["we_maidenguard"] = "we_2",
	["we_shade"] = "we_1",
	
	-- victor
	["wh_captain"] = "wh_3",
	["wh_bountyhunter"] = "wh_2",
	["wh_zealot"] = "wh_1",
	
	-- sienna
	["bw_scholar"] = "bw_1",
	["bw_adept"] = "bw_2",
	["bw_unchained"] = "bw_3",

}

-- and make sure they will be updated properly
-- "UnitFramesHandler._sync_player_stats"

mod:hook( UnitFramesHandler, "_sync_player_stats", function (func, self, unit_frame)
	
	func( self, unit_frame )
	
	mod:pcall( function() 
		
		local dirty = false
		local force_dirty = false
		
		local player_data = unit_frame.player_data
		local player = player_data.player

		if not player then
			return
		end
		
		local widget = unit_frame.widget
		local data = unit_frame.data
		
		if not player_data.extensions then
			local player_unit = player.player_unit

			if player_unit then
				self:_set_player_extensions(player_data, player_unit)
			end
		end
		
		local player_unit = player_data.player_unit

		if (not player_unit or not Unit.alive(player_unit)) and player_data.extensions then
			player_data.extensions = nil
		end
		
		-- only reset it if player disconnects
		if not player_unit then
			data.got_talent_ammo = false
			data.checked_for_talent_ammo = false
		end
		
		local extensions = player_data.extensions
		local hp_perm, hp_temp, hp_max = nil
		local cur_ammo = nil
		local max_ammo = nil
		local cur_cooldown = 0
		local is_overcharge = false
		local is_at_deaths_door = false
		local has_nb = false
		
		local equipment = nil
		local network_manager = Managers.state.network
		local game = network_manager:game()
		local go_id = Managers.state.unit_storage:go_id(player_unit)

		local dont_draw = nil
		
		if extensions then
			local health_extension = extensions.health
			local status_extension = extensions.status
			local career_extension = extensions.career
			local buff_extension = extensions.buff
			
			local career_name = career_extension and career_extension:career_name()

			if status_extension:is_dead() then
				hp_perm, hp_temp, hp_max = 0, 0, 0
			else
				hp_perm = health_extension:current_permanent_health()
				hp_temp = health_extension:current_temporary_health()
				hp_max = health_extension:get_max_health()
			end
			
			if status_extension.wounds and status_extension.wounds == 1 then
				is_at_deaths_door = true
			end
			
			if career_extension then --and career_extension:current_ability_cooldown() then
				
				-- get cooldown timer for local player (aka the cool way)
				if player_data.own_player then
					
					cur_cooldown = math.ceil( career_extension:current_ability_cooldown() )
					
				-- same but for teammates (the ugly way)
				else
				
					local ability_percentage = 0
					
					if game and go_id then
						ability_percentage = GameSession.game_object_field(game, go_id, "ability_percentage") or 0						
					end
			
					if career_name and cooldown_table[ career_name ] and ActivatedAbilitySettings[ cooldown_table[ career_name ] ] and ActivatedAbilitySettings[ cooldown_table[ career_name ] ][1] and ActivatedAbilitySettings[ cooldown_table[ career_name ] ][1].cooldown then
						local max_cooldown = ActivatedAbilitySettings[ cooldown_table[ career_name ] ][1].cooldown
						local raw_cooldown = ability_percentage * max_cooldown
						
						cur_cooldown = raw_cooldown --math.modf( raw_cooldown )
											
					end
				end
			end
			
			-- check for natural bond
			if buff_extension and buff_extension:has_buff_type("trait_necklace_no_healing_health_regen") then
				has_nb = true
			end
			
			local inventory_extension = extensions.inventory
			equipment = inventory_extension:equipment()
			
			if equipment then
				
				local inventory_slots = InventorySettings.slots
				
				for _, slot in ipairs(inventory_slots) do
					
					if slot.name == "slot_ranged" then
						local slot_name = slot.name
						local slot_data = equipment.slots[slot_name]
						local item_data = slot_data and slot_data.item_data
						
						if slot_data then
							
							local item_name = item_data.name
							local item_template = BackendUtils.get_item_template(item_data)
							
							-- guns
							if item_template.ammo_data then
							
								local desired_ammo, desired_max_ammo = calculate_ammo( item_template, game, go_id, career_extension, data, player_unit )
								
								if cur_ammo ~= desired_ammo then
									cur_ammo = desired_ammo
								end
								
								
								if max_ammo ~= desired_max_ammo then
									max_ammo = desired_max_ammo
								end
								
																								
							-- melee or magic and wizardry
							else	
								

							end
							
							if item_template.overcharge_data then
								is_overcharge = true
							end
							
						end
					end
					
				end
			
			end
			
			
		else
			hp_perm, hp_temp, hp_max = 0, 0, 0
			cur_ammo = -1
			max_ammo = -1
			dont_draw = true
		end
		
		if player_data.own_player then
			if data.show_player_health ~= mod:get("player_health") then
				data.show_player_health = mod:get("player_health")
				force_dirty = true
			end
		else
			if data.show_teammate_health ~= mod:get("teammate_health") then
				data.show_teammate_health = mod:get("teammate_health")
				force_dirty = true
			end
		end
		
		if data.show_player_maxhp ~= mod:get("player_maxhp") then
			data.show_player_maxhp = mod:get("player_maxhp")
			force_dirty = true
		end
		
		if data.show_teammate_maxhp ~= mod:get("teammate_maxhp") then
			data.show_teammate_maxhp = mod:get("teammate_maxhp")
			force_dirty = true
		end
		
		if data.show_teammate_ammo ~= mod:get("teammate_ammo") then
			data.show_teammate_ammo = mod:get("teammate_ammo")
			force_dirty = true
		end
		
		if data.show_teammate_deaths_door ~= mod:get("teammate_deaths_door") then
			data.show_teammate_deaths_door = mod:get("teammate_deaths_door")
			force_dirty = true
		end
		
		if data.show_teammate_nb ~= mod:get("teammate_nb") then
			data.show_teammate_nb = mod:get("teammate_nb")
			force_dirty = true
		end
		
		if data.show_cooldown_timer ~= mod:get("cooldown_timer") then
			data.show_cooldown_timer = mod:get("cooldown_timer")
			force_dirty = true
		end
		
		if not data.show_teammate_ammo then
			cur_ammo = -1
		end
		
		if not data.show_teammate_deaths_door then
			is_at_deaths_door = false
		end
		
		if not data.show_teammate_nb then
			has_nb = false
		end
		
		if player_data.own_player then
			if not data.show_cooldown_timer or data.show_cooldown_timer == 3 then
				cur_cooldown = 0
			end
		else
			if not data.show_cooldown_timer or data.show_cooldown_timer == 2 then
				cur_cooldown = 0
			end
		end
		
		if cur_cooldown and ( force_dirty or data.cur_cooldown ~= cur_cooldown ) then
		
			data.cur_cooldown = cur_cooldown
			
			local widget2 = player_data.own_player and ( unit_frame.gamepad_version and widget:_widget_by_feature("ability", "dynamic") or widget:_widget_by_feature("health", "dynamic") ) or widget:_widget_by_feature("default", "dynamic")

			if widget2 then
				local widget2_content = widget2.content
				
				if not player_data.own_player then
				--	if cur_cooldown < 1 and cur_cooldown > 0.8 then
						cur_cooldown = cur_cooldown + 0.5
				--	end
				end
				
				local minutes = math.modf( cur_cooldown / 60 )
				local seconds = cur_cooldown - minutes * 60
				
				
				widget2_content.cooldown_string = string.format( "%i:%02i", minutes, seconds )
				
				if dont_draw then
					widget2_content.cooldown_string = "0:00"
				end
				
				
				widget:_set_widget_dirty( widget2 )
			end

			dirty = true
		end		
		
		if force_dirty or data.hp_perm ~= hp_perm or data.hp_temp ~= hp_temp or data.hp_max ~= hp_max then
			data.hp_perm = hp_perm
			data.hp_temp = hp_temp
			data.hp_max = hp_max
			
			local widget2 = widget:_widget_by_feature("health", "dynamic")

			if widget2 then
				local widget2_content = widget2.content
				
				local clean_hp_perm = math.ceil( hp_perm ) --math.modf( hp_perm )
				local clean_hp_temp = math.ceil( hp_temp ) --math.modf( hp_temp )
				local clean_hp_max = math.ceil( hp_max ) --math.modf( hp_max )
				
				clean_hp_temp = math.min( clean_hp_max - clean_hp_perm, math.max( clean_hp_temp, 0 ) )
				
				local clean_hp_sum = math.ceil( hp_perm + hp_temp ) --math.modf( hp_perm + hp_temp )
				clean_hp_sum = math.min( clean_hp_max, math.max( clean_hp_sum, 0 ) )
				
				-- make sure we wont get any 0 hp issues
				if hp_perm < 1 and hp_perm > 0 then
					clean_hp_perm = 1
				end
				
				if hp_temp < 1 and hp_temp > 0 then
					clean_hp_temp = 1
				end
				
				if ( hp_perm + hp_temp ) < 1 and ( hp_perm + hp_temp ) > 0 then
					clean_hp_sum = 1
				end
				
				local new_health = ""
				
				if player_data.own_player then
				
					local add_maxhp = data.show_player_maxhp
					
					if data.show_player_health == 1 then
						if clean_hp_temp > 0 then
							new_health = clean_hp_perm > 0 and string.format( "%i+%i", clean_hp_perm, clean_hp_temp ) or string.format( "%i", clean_hp_temp )
						else
							new_health = string.format( "%i", clean_hp_perm )
						end
					elseif data.show_player_health == 2 then
						new_health = string.format( "%i", clean_hp_perm + clean_hp_temp )
					elseif data.show_player_health == 3 then
						if clean_hp_perm > 0 then
							new_health = clean_hp_temp > 0 and string.format( "%i(%i)", clean_hp_sum, clean_hp_temp ) or string.format( "%i", clean_hp_sum )
						else
							new_health = clean_hp_temp > 0 and string.format( "(%i)", clean_hp_temp ) or string.format( "%i", clean_hp_sum )
						end
					else
						add_maxhp = false
						new_health = ""
					end
					
					if add_maxhp then
						new_health = new_health.."/"..clean_hp_max
					end
					
				else
					
					local add_maxhp = data.show_teammate_maxhp
					
					if data.show_teammate_health == 1 then
						if clean_hp_temp > 0 then
							new_health = clean_hp_perm > 0 and string.format( "%i+%i", clean_hp_perm, clean_hp_temp ) or string.format( "%i", clean_hp_temp )
						else
							new_health = string.format( "%i", clean_hp_perm )
						end
					elseif data.show_teammate_health == 2 then
						new_health = string.format( "%i", clean_hp_sum )
					elseif data.show_teammate_health == 3 then
						if clean_hp_perm > 0 then
							new_health = clean_hp_temp > 0 and string.format( "%i(%i)", clean_hp_sum, clean_hp_temp ) or string.format( "%i", clean_hp_sum )
						else
							new_health = clean_hp_temp > 0 and string.format( "(%i)", clean_hp_temp ) or string.format( "%i", clean_hp_sum )
						end
					else
						add_maxhp = false
						new_health = ""
					end
					
					if add_maxhp then
						new_health = new_health.."/"..clean_hp_max
					end
					
				end
				
				if dont_draw then
					new_health = ""
				end
				
				widget2_content.health_string = new_health
				
				widget:_set_widget_dirty( widget2 )
			end

			dirty = true
		end
		
		if force_dirty or data.is_overcharge ~= is_overcharge then
			
			data.is_overcharge = is_overcharge
			
			local widget2 = widget:_widget_by_feature("default", "dynamic")

			if widget2 then
				local widget2_content = widget2.content

				widget2_content.is_overcharge = is_overcharge
				
				widget:_set_widget_dirty( widget2 )
			end

			dirty = true			
		end
		
		if cur_ammo and ( force_dirty or data.cur_ammo ~= cur_ammo ) then
		
			data.cur_ammo = cur_ammo
			
			local widget2 = widget:_widget_by_feature("default", "dynamic")

			if widget2 then
				local widget2_content = widget2.content
				
				if data.show_teammate_ammo == 1 or data.show_teammate_ammo == true then -- backward compatibility
					widget2_content.ammo_string = ""..cur_ammo..""..( is_overcharge and "%" or "" )
					widget2_content.ammo_style = 1
				elseif data.show_teammate_ammo == 2 then
					widget2_content.ammo_string = ""..cur_ammo.."/"..max_ammo
					widget2_content.ammo_style = 2
				elseif data.show_teammate_ammo == 3 then
					widget2_content.ammo_string = ""
					widget2_content.ammo_style = 3
				else
					widget2_content.ammo_string = "-1"
					widget2_content.ammo_style = 1
				end
				
				if dont_draw then
					widget2_content.ammo_string = "-1"
				end
				
				widget:_set_widget_dirty( widget2 )
			end

			dirty = true
		end
		
		if data.is_at_deaths_door ~= is_at_deaths_door then
			
			data.is_at_deaths_door = is_at_deaths_door
			
			local widget2 = widget:_widget_by_feature("default", "dynamic")

			if widget2 then
				local widget2_content = widget2.content
				
				widget2_content.is_at_deaths_door = dont_draw and false or is_at_deaths_door
				
				widget:_set_widget_dirty( widget2 )
			end

			dirty = true
			
		end
		
		if data.has_nb ~= has_nb then
			
			data.has_nb = has_nb
			
			local widget2 = widget:_widget_by_feature("default", "dynamic")

			if widget2 then
				local widget2_content = widget2.content
				
				widget2_content.has_natural_bond = has_nb
				
				widget:_set_widget_dirty( widget2 )
			end

			dirty = true
			
		end
		
		if dirty then
			widget:set_dirty()

			if self.cleanui then
				self.cleanui.dirty = true
			end
		end
		
		
	end )
	
end)

mod.update = function(dt)
	
end


mod.on_unload = function()
	
end

mod.on_game_state_changed = function(status, state)
	
end

mod.on_setting_changed = function(setting_name)
	
end

mod.on_disabled = function(is_first_call)
	
end

mod.on_enabled = function(is_first_call)
	
end

