local jdtls = require("jdtls")

-- Java uses 4 spaces, unlike most other languages in this config.
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

local markers = {
  ".git",
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
  ".project",
  ".classpath",
}

local bufname = vim.api.nvim_buf_get_name(0)
local root_dir = vim.fs.root(0, markers) or vim.fs.dirname(bufname)

-- Include a hash of the full path so projects that share a directory name
-- don't end up sharing the same jdtls workspace (and each other's indexes).
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_name = project_name .. "-" .. vim.fn.sha256(root_dir):sub(1, 8)
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. workspace_name

local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

local config = {
  cmd = { "jdtls", "-data", workspace_dir },

  root_dir = root_dir,

  capabilities = capabilities,

  settings = {
    java = {
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
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
        importOrder = { "java", "javax", "com", "org" },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = { useJava7Objects = true },
        useBlocks = true,
      },
      saveActions = { organizeImports = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      format = { enabled = true },
      inlayHints = { parameterNames = { enabled = "literals" } },
    },
  },

  init_options = {
    bundles = {},
  },
}

jdtls.start_or_attach(config)

vim.keymap.set("n", "<leader>co", function()
  jdtls.organize_imports()
end, { buffer = 0, desc = "Organize Imports" })
