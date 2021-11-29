import System.Taffybar
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget

main :: IO ()
main = do
  let workspaces = workspacesNew defaultWorkspacesConfig
      clock = textClockNewWith defaultClockConfig
      simpleConfig =
        defaultSimpleTaffyConfig
          { startWidgets = [workspaces],
            endWidgets = [clock, sniTrayNew],
            monitorsAction = useAllMonitors
          }

  simpleTaffybar defaultSimpleTaffyConfig
