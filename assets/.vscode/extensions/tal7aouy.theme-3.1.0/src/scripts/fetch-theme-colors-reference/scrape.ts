import https from 'https'
import { config } from '~/config'

function get(url: string) {
  return new Promise<string>((resolve, reject) => {
    https.get(url, res => {
      let body = ''
      res.setEncoding('utf8')
      res.on('data', data => (body += data))
      res.on('end', () => resolve(body))
      res.on('error', reject)
    })
  })
}

export async function scrapeThemeAvailableKeys() {
  const xml: string = await get(config.themeColorReferenceURL)

  const matches = xml.match(/<code>.+?<\/code>/g)

  if (!matches) {
    throw new Error(
      "Couldn't find any matches with <code>...</code>, maybe do  cs have changed?",
    )
  }

  const keys = [...matches].map(key =>
    key.replace('<code>', '').replace('</code>', ''),
  )

  return keys
    .filter(key => !/ /.test(key)) // Remove if contains spaces
    .filter(key => !/#.../.test(key)) // Remove if is a hex color
    .filter(key => !/&quot;/.test(key)) // Remove if contains quotes
    .filter(key => key.length > 4) // Remove if it's very small
    .filter(key => !config.disposableKeys.includes(key)) // Remove if its in the list of disposable keys
    .sort()
}
