import { build } from '~/scripts/build'
import { pressEnterToExit } from '~/utils/press-enter-to-exit'
import Theme from '~/variants/theme'
import ThemeDarker from '~/variants/themeDarker'
import ThemeFlat from '~/variants/ThemeFlat'
import themeMix from '~/variants/themeMix'

async function run() {
  await build(Theme)
  await build(ThemeDarker)
  await build(ThemeFlat)
  await build(themeMix)

  if (process.env.DEBUG_VSCODE) {
    pressEnterToExit() // Hold the process alive
  }
}

run()
