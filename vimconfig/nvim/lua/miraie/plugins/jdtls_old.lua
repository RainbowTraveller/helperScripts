return {
	--1. Installed nvim-jdtls using Lazy
	--2. Installed jdtls using Mason : search installation path under .local
	-- refer to : https://github.com/eclipse-jdtls/eclipse.jdt.ls#installation
	"mfussenegger/nvim-jdtls",
	dependencies = { "folke/which-key.nvim" },
	ft = { "java" },
	config = function()
		-- Initialize the workspace
		local home = os.getenv("HOME") -- /Users/miraie/
		local jdtls = require("jdtls")

		-- 'data' points to /Users/miraie/.local/share/nvim
		-- Executable for jdtls
		local jdtls_bin = vim.fn.stdpath("data") .. "/mason/packages/jdtls/bin/jdtls"

		-- File types that signify a Java project's root directory. This will be
		-- used by eclipse to determine what constitutes a workspace
		local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }

		-- These markers are added to jdtls setup as follows
		local root_dir = require("jdtls.setup").find_root(root_markers)

		-- eclipse.jdt.ls stores project specific data within a folder. If you are working
		-- with multiple different projects, each project must use a dedicated data directory.
		-- This variable is used to configure eclipse to use the directory name of the
		-- current project found using the root_marker as the folder for project specific data.
		-- This enables jdtls track each project separately, providing umbrella directory
		local workspace_folder = home .. "/.cache/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

		-- TODO : Add Keymaps

		local config = {
			flags = {
				debounce_text_changes = 80,
			},

			root_dir = root_dir, -- Set the root directory to our found root_marker
			-- TODO : Deep dive into settings param
			settings = {
				java = {

					-- Formatting based on eclipse ( TODO : google style)
					format = {
						settings = {
							-- Use Google Java style guidelines for formatting
							-- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
							-- and place it in the ~/.local/share/eclipse directory
							url = "/.local/share/eclipse/eclipse-java-google-style.xml",
							profile = "GoogleStyle",
						},
					},

					signatureHelp = { enabled = true },

					contentProvider = { preferred = "fernflower" }, -- Use fernflower to decompile library code

					-- Specify any completion options
					completion = {
						favoriteStaticMembers = {
							"org.hamcrest.MatcherAssert.assertThat",
							"org.hamcrest.Matchers.*",
							"org.hamcrest.CoreMatchers.*",
							"org.junit.jupiter.api.Assertions.*",
							"java.util.Objects.requireNonNull",
							"java.util.Objects.requireNonNullElse",
							"org.mockito.Mockito.*",
						},
						filteredTypes = {
							"com.sun.*",
							"io.micrometer.shaded.*",
							"java.awt.*",
							"jdk.*",
							"sun.*",
						},
					},

					-- Specify any options for organizing imports
					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},

					-- How code generation should act
					codeGeneration = {
						toString = {
							template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
						},
						hashCodeEquals = {
							useJava7Objects = true,
						},
						useBlocks = true,
					},

					-- If you are developing in projects with different Java versions, you need
					-- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
					-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
					-- And search for `interface RuntimeOption`
					-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
					configuration = {
						runtimes = {
							{
								name = "JavaSE-17",
								path = "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home",
							},
						},
					},
				}, -- end java
			}, -- end settings

			cmd = {
				jdtls_bin,
				"-data",
				workspace_folder,
			},
		} -- end config
		jdtls.start_or_attach(config)
	end,
}
