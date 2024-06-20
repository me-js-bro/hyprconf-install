import { ThemeColorsReference } from './ThemeColorsReference'

export type TokenColor = {
  name?: string
  scope: string | string[] // There are semantic, common scopes which can be found at https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide#standard-token-types-and-modifiers
  settings: {
    fontStyle?: string
    foreground?: string
  }
}

type OrNull<T> = { [K in keyof T]: T[K] | null }

export type ThemeSchema = {
  name: string
  type: 'dark' | 'light'
  colors: OrNull<ThemeColorsReference>
  tokenColors: TokenColor[]
}
