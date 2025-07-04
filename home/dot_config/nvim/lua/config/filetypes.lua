local M = {}
function M.setup()
  vim.filetype.add({
    pattern = {
      [".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
      [".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
      [".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
      [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
      [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
      [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
    },
  })
end
return M
