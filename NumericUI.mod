return {
	run = function()
		fassert(rawget(_G, "new_mod"), "NumericUI must be lower than Vermintide Mod Framework in your launcher's load order.")
		new_mod("NumericUI", {
			mod_script       = "scripts/mods/NumericUI/NumericUI",
			mod_data         = "scripts/mods/NumericUI/NumericUI_data",
			mod_localization = "scripts/mods/NumericUI/NumericUI_localization"
		})
	end,
	packages = {
		"resource_packages/NumericUI/NumericUI"
	}
}
