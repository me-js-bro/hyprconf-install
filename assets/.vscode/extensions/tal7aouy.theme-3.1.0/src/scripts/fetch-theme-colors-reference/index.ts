import fs from 'fs'
import { JSONSchema4 } from 'json-schema'
import { compile } from 'json-schema-to-typescript'
import path from 'path'
import toJsonSchema from 'to-json-schema'
import { config } from '~/config'
import { scrapeThemeAvailableKeys } from './scrape'

const typeName = 'ThemeColorsReference'

async function run() {
  if (!fs.existsSync(config.typesDir)) {
    await fs.promises.mkdir(config.typesDir, { recursive: true })
  }

  const keys = await scrapeThemeAvailableKeys()

  const obj = keys.reduce((map, key) => {
    map[key] = ''
    return map
  }, {} as { [key: string]: string })

  const schema = toJsonSchema(obj)
  schema.additionalProperties = false

  const prettierConfig = JSON.parse(
    await fs.promises.readFile(config.prettierConfigFile, 'utf8'),
  )

  const tsdBuffer = await compile(schema as JSONSchema4, typeName, {
    style: prettierConfig,
  })
  const tsdFile = path.join(config.typesDir, `${typeName}.d.ts`)

  await fs.promises.writeFile(tsdFile, tsdBuffer)

  console.log(`Successfully compiled ${typeName} to file ${tsdFile}`)
}

run()
