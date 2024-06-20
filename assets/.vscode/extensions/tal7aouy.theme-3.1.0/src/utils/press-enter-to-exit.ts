export function pressEnterToExit() {
  const stdin = process.openStdin()

  console.log('Press ENTER to exit.')

  stdin.on('data', () => {
    process.exit()
  })
}
