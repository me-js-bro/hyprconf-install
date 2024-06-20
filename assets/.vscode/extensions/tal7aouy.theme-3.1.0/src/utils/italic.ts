import { TokenColor } from '~/@types/ThemeSchema'
const Italic: TokenColor[] = [
  {
    name: 'Comments',
    scope: 'comment, punctuation.definition.comment',
    settings: {
      fontStyle: 'italic',
    },
  },
  {
    name: 'js/ts italic',
    scope:
      'entity.other.attribute-name.js,entity.other.attribute-name.ts,entity.other.attribute-name.jsx,entity.other.attribute-name.tsx,variable.parameter,variable.language.super',
    settings: {
      fontStyle: 'italic',
    },
  },
  {
    name: 'comment',
    scope: 'comment.line.double-slash,comment.block.documentation',
    settings: {
      fontStyle: 'italic',
    },
  },
  {
    name: 'Python Keyword Control',
    scope:
      'keyword.control.import.python,keyword.control.flow.python,keyword.operator.logical.python',
    settings: {
      fontStyle: 'italic',
    },
  },
  {
    name: 'markup.italic.markdown',
    scope: 'markup.italic.markdown',
    settings: {
      fontStyle: 'italic',
    },
  },
  {
    name: 'Keyword Operator Comparison,constant, imports, returns and Keyword Operator Ruby',
    scope: [
      'entity.other.attribute-name.html',
      'storage.type',
      'entity.name.function',
      'constant.numeric.css',
      'keyword.other.unit.px.css',
      'keyword.operator.comparison',
      'keyword.control.flow.js',
      'keyword.control.flow.ts',
      'keyword.control.flow.tsx',
      'keyword.control.ruby',
      'keyword.control.module.ruby',
      'keyword.control.class.ruby',
      'keyword.control.def.ruby',
      'keyword.control.loop.js',
      'keyword.control.loop.ts',
      'keyword.control.import.js',
      'keyword.control.import.ts',
      'keyword.control.import.tsx',
      'keyword.control.from.js',
      'keyword.control.from.ts',
      'keyword.control.from.tsx',
      'keyword.operator.instanceof.js',
      'keyword.operator.expression.instanceof.ts',
      'keyword.operator.expression.instanceof.tsx',
    ],
    settings: {
      fontStyle: 'italic',
    },
  },
]

export default Italic
