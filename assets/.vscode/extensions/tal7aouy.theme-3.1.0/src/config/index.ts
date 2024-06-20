import path from 'path'

export const config = {
  variantsDir: path.resolve(__dirname, '..', 'variants'),
  typesDir: path.resolve(__dirname, '..', '@types'),
  themesDir: path.resolve(__dirname, '..', '..', 'themes'),
  prettierConfigFile: path.join(__dirname, '..', '..', '.prettierrc'),
  themeColorReferenceURL:
    'https://code.visualstudio.com/api/references/theme-color',
  disposableKeys: [
    'workbench.colorCustomizations',
    'editor.tokenColorCustomizations',
  ],
}
