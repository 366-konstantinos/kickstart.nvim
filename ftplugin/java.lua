local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspace_dir = '/home/konstantinos/jdtls/workspace/' .. project_name

local config = {
  -- cmd = { ' /opt/jdt-language-server/jdt-language-server-1.38.0-202408011337/bin/jdtls' },
  --
  --
  cmd = {
    '/usr/lib/jvm/java-17-openjdk-amd64/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    '/opt/jdt-language-server/jdt-language-server-1.38.0-202408011337/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
    '-configuration',
    '/opt/jdt-language-server/jdt-language-server-1.38.0-202408011337/config_linux',
    '-data',
    workspace_dir,
  },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  settings = {
    java = {
      configurations = {
        runtimes = {
          {
            name = 'JavaSE-11',
            path = '/usr/lib/jvm/java-11-openjdk-amd64/',
          },
          {
            name = 'JavaSE-17',
            path = '/usr/lib/jvm/java-17-openjdk-amd64/',
          },
          {
            name = 'JavaSE-1.8',
            path = '/usr/lib/jvm/java-1.8.0-openjdk-amd64/',
          },
        },
      },
    },
  },
  on_init = function(client)
    client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end,
}
require('jdtls').start_or_attach(config)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
