"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Parser = void 0;
const vscode = require("vscode");
class Parser {
    /**
     * Creates a new instance of the Parser class
     * @param configuration
     */
    constructor(config) {
        this.tags = [];
        this.expression = "";
        this.delimiter = "";
        this.blockCommentStart = "";
        this.blockCommentEnd = "";
        this.highlightSingleLineComments = true;
        this.highlightMultilineComments = false;
        this.highlightJSDoc = false;
        // * this will allow plaintext files to show comment highlighting if switched on
        this.isPlainText = false;
        // * this is used to prevent the first line of the file (specifically python) from coloring like other comments
        this.ignoreFirstLine = false;
        // * this is used to trigger the events when a supported language code is found
        this.supportedLanguage = true;
        // Read from the package.json
        this.contributions = vscode.workspace.getConfiguration('better-comments');
        this.configuration = config;
        this.setTags();
    }
    /**
     * Sets the regex to be used by the matcher based on the config specified in the package.json
     * @param languageCode The short code of the current language
     * https://code.visualstudio.com/docs/languages/identifiers
     */
    SetRegex(languageCode) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.setDelimiter(languageCode);
            // if the language isn't supported, we don't need to go any further
            if (!this.supportedLanguage) {
                return;
            }
            let characters = [];
            for (let commentTag of this.tags) {
                characters.push(commentTag.escapedTag);
            }
            if (this.isPlainText && this.contributions.highlightPlainText) {
                // start by tying the regex to the first character in a line
                this.expression = "(^)+([ \\t]*[ \\t]*)";
            }
            else {
                // start by finding the delimiter (//, --, #, ') with optional spaces or tabs
                this.expression = "(" + this.delimiter + ")+( |\t)*";
            }
            // Apply all configurable comment start tags
            this.expression += "(";
            this.expression += characters.join("|");
            this.expression += ")+(.*)";
        });
    }
    /**
     * Finds all single line comments delimited by a given delimiter and matching tags specified in package.json
     * @param activeEditor The active text editor containing the code document
     */
    FindSingleLineComments(activeEditor) {
        // If highlight single line comments is off, single line comments are not supported for this language
        if (!this.highlightSingleLineComments)
            return;
        let text = activeEditor.document.getText();
        // if it's plain text, we have to do mutliline regex to catch the start of the line with ^
        let regexFlags = (this.isPlainText) ? "igm" : "ig";
        let regEx = new RegExp(this.expression, regexFlags);
        let match;
        while (match = regEx.exec(text)) {
            let startPos = activeEditor.document.positionAt(match.index);
            let endPos = activeEditor.document.positionAt(match.index + match[0].length);
            let range = { range: new vscode.Range(startPos, endPos) };
            // Required to ignore the first line of .py files (#61)
            if (this.ignoreFirstLine && startPos.line === 0 && startPos.character === 0) {
                continue;
            }
            // Find which custom delimiter was used in order to add it to the collection
            let matchTag = this.tags.find(item => item.tag.toLowerCase() === match[3].toLowerCase());
            if (matchTag) {
                matchTag.ranges.push(range);
            }
        }
    }
    /**
     * Finds block comments as indicated by start and end delimiter
     * @param activeEditor The active text editor containing the code document
     */
    FindBlockComments(activeEditor) {
        // If highlight multiline is off in package.json or doesn't apply to his language, return
        if (!this.highlightMultilineComments)
            return;
        let text = activeEditor.document.getText();
        // Build up regex matcher for custom delimiter tags
        let characters = [];
        for (let commentTag of this.tags) {
            characters.push(commentTag.escapedTag);
        }
        // Combine custom delimiters and the rest of the comment block matcher
        let commentMatchString = "(^)+([ \\t]*[ \\t]*)(";
        commentMatchString += characters.join("|");
        commentMatchString += ")([ ]*|[:])+([^*/][^\\r\\n]*)";
        // Use start and end delimiters to find block comments
        let regexString = "(^|[ \\t])(";
        regexString += this.blockCommentStart;
        regexString += "[\\s])+([\\s\\S]*?)(";
        regexString += this.blockCommentEnd;
        regexString += ")";
        let regEx = new RegExp(regexString, "gm");
        let commentRegEx = new RegExp(commentMatchString, "igm");
        // Find the multiline comment block
        let match;
        while (match = regEx.exec(text)) {
            let commentBlock = match[0];
            // Find the line
            let line;
            while (line = commentRegEx.exec(commentBlock)) {
                let startPos = activeEditor.document.positionAt(match.index + line.index + line[2].length);
                let endPos = activeEditor.document.positionAt(match.index + line.index + line[0].length);
                let range = { range: new vscode.Range(startPos, endPos) };
                // Find which custom delimiter was used in order to add it to the collection
                let matchString = line[3];
                let matchTag = this.tags.find(item => item.tag.toLowerCase() === matchString.toLowerCase());
                if (matchTag) {
                    matchTag.ranges.push(range);
                }
            }
        }
    }
    /**
     * Finds all multiline comments starting with "*"
     * @param activeEditor The active text editor containing the code document
     */
    FindJSDocComments(activeEditor) {
        // If highlight multiline is off in package.json or doesn't apply to his language, return
        if (!this.highlightMultilineComments && !this.highlightJSDoc)
            return;
        let text = activeEditor.document.getText();
        // Build up regex matcher for custom delimiter tags
        let characters = [];
        for (let commentTag of this.tags) {
            characters.push(commentTag.escapedTag);
        }
        // Combine custom delimiters and the rest of the comment block matcher
        let commentMatchString = "(^)+([ \\t]*\\*[ \\t]*)("; // Highlight after leading *
        let regEx = /(^|[ \t])(\/\*\*)+([\s\S]*?)(\*\/)/gm; // Find rows of comments matching pattern /** */
        commentMatchString += characters.join("|");
        commentMatchString += ")([ ]*|[:])+([^*/][^\\r\\n]*)";
        let commentRegEx = new RegExp(commentMatchString, "igm");
        // Find the multiline comment block
        let match;
        while (match = regEx.exec(text)) {
            let commentBlock = match[0];
            // Find the line
            let line;
            while (line = commentRegEx.exec(commentBlock)) {
                let startPos = activeEditor.document.positionAt(match.index + line.index + line[2].length);
                let endPos = activeEditor.document.positionAt(match.index + line.index + line[0].length);
                let range = { range: new vscode.Range(startPos, endPos) };
                // Find which custom delimiter was used in order to add it to the collection
                let matchString = line[3];
                let matchTag = this.tags.find(item => item.tag.toLowerCase() === matchString.toLowerCase());
                if (matchTag) {
                    matchTag.ranges.push(range);
                }
            }
        }
    }
    /**
     * Apply decorations after finding all relevant comments
     * @param activeEditor The active text editor containing the code document
     */
    ApplyDecorations(activeEditor) {
        for (let tag of this.tags) {
            activeEditor.setDecorations(tag.decoration, tag.ranges);
            // clear the ranges for the next pass
            tag.ranges.length = 0;
        }
    }
    //#region  Private Methods
    /**
     * Sets the comment delimiter [//, #, --, '] of a given language
     * @param languageCode The short code of the current language
     * https://code.visualstudio.com/docs/languages/identifiers
     */
    setDelimiter(languageCode) {
        return __awaiter(this, void 0, void 0, function* () {
            this.supportedLanguage = false;
            this.ignoreFirstLine = false;
            this.isPlainText = false;
            const config = yield this.configuration.GetCommentConfiguration(languageCode);
            if (config) {
                let blockCommentStart = config.blockComment ? config.blockComment[0] : null;
                let blockCommentEnd = config.blockComment ? config.blockComment[1] : null;
                this.setCommentFormat(config.lineComment || blockCommentStart, blockCommentStart, blockCommentEnd);
                this.supportedLanguage = true;
            }
            switch (languageCode) {
                case "apex":
                case "javascript":
                case "javascriptreact":
                case "typescript":
                case "typescriptreact":
                    this.highlightJSDoc = true;
                    break;
                case "elixir":
                case "python":
                case "tcl":
                    this.ignoreFirstLine = true;
                    break;
                case "plaintext":
                    this.isPlainText = true;
                    // If highlight plaintext is enabled, this is a supported language
                    this.supportedLanguage = this.contributions.highlightPlainText;
                    break;
            }
        });
    }
    /**
     * Sets the highlighting tags up for use by the parser
     */
    setTags() {
        let items = this.contributions.tags;
        for (let item of items) {
            let options = { color: item.color, backgroundColor: item.backgroundColor };
            // ? the textDecoration is initialised to empty so we can concat a preceeding space on it
            options.textDecoration = "";
            if (item.strikethrough) {
                options.textDecoration += "line-through";
            }
            if (item.underline) {
                options.textDecoration += " underline";
            }
            if (item.bold) {
                options.fontWeight = "bold";
            }
            if (item.italic) {
                options.fontStyle = "italic";
            }
            let escapedSequence = item.tag.replace(/([()[{*+.$^\\|?])/g, '\\$1');
            this.tags.push({
                tag: item.tag,
                escapedTag: escapedSequence.replace(/\//gi, "\\/"),
                ranges: [],
                decoration: vscode.window.createTextEditorDecorationType(options)
            });
        }
    }
    /**
     * Escapes a given string for use in a regular expression
     * @param input The input string to be escaped
     * @returns {string} The escaped string
     */
    escapeRegExp(input) {
        return input.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
    }
    /**
     * Set up the comment format for single and multiline highlighting
     * @param singleLine The single line comment delimiter. If NULL, single line is not supported
     * @param start The start delimiter for block comments
     * @param end The end delimiter for block comments
     */
    setCommentFormat(singleLine, start = null, end = null) {
        this.delimiter = "";
        this.blockCommentStart = "";
        this.blockCommentEnd = "";
        // If no single line comment delimiter is passed, single line comments are not supported
        if (singleLine) {
            if (typeof singleLine === 'string') {
                this.delimiter = this.escapeRegExp(singleLine).replace(/\//ig, "\\/");
            }
            else if (singleLine.length > 0) {
                // * if multiple delimiters are passed, the language has more than one single line comment format
                var delimiters = singleLine
                    .map(s => this.escapeRegExp(s))
                    .join("|");
                this.delimiter = delimiters;
            }
        }
        else {
            this.highlightSingleLineComments = false;
        }
        if (start && end) {
            this.blockCommentStart = this.escapeRegExp(start);
            this.blockCommentEnd = this.escapeRegExp(end);
            this.highlightMultilineComments = this.contributions.multilineComments;
        }
    }
}
exports.Parser = Parser;
//# sourceMappingURL=parser.js.map