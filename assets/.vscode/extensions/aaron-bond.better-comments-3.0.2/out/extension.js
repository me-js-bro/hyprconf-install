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
exports.deactivate = exports.activate = void 0;
const vscode = require("vscode");
const configuration_1 = require("./configuration");
const parser_1 = require("./parser");
// this method is called when vs code is activated
function activate(context) {
    return __awaiter(this, void 0, void 0, function* () {
        let activeEditor;
        let configuration = new configuration_1.Configuration();
        let parser = new parser_1.Parser(configuration);
        // Called to handle events below
        let updateDecorations = function () {
            // if no active window is open, return
            if (!activeEditor)
                return;
            // if lanugage isn't supported, return
            if (!parser.supportedLanguage)
                return;
            // Finds the single line comments using the language comment delimiter
            parser.FindSingleLineComments(activeEditor);
            // Finds the multi line comments using the language comment delimiter
            parser.FindBlockComments(activeEditor);
            // Finds the jsdoc comments
            parser.FindJSDocComments(activeEditor);
            // Apply the styles set in the package.json
            parser.ApplyDecorations(activeEditor);
        };
        // Get the active editor for the first time and initialise the regex
        if (vscode.window.activeTextEditor) {
            activeEditor = vscode.window.activeTextEditor;
            // Set the regex patterns for the specified language's comments
            yield parser.SetRegex(activeEditor.document.languageId);
            // Trigger first update of decorators
            triggerUpdateDecorations();
        }
        // * Handle extensions being added or removed
        vscode.extensions.onDidChange(() => {
            configuration.UpdateLanguagesDefinitions();
        }, null, context.subscriptions);
        // * Handle active file changed
        vscode.window.onDidChangeActiveTextEditor((editor) => __awaiter(this, void 0, void 0, function* () {
            if (editor) {
                activeEditor = editor;
                // Set regex for updated language
                yield parser.SetRegex(editor.document.languageId);
                // Trigger update to set decorations for newly active file
                triggerUpdateDecorations();
            }
        }), null, context.subscriptions);
        // * Handle file contents changed
        vscode.workspace.onDidChangeTextDocument(event => {
            // Trigger updates if the text was changed in the same document
            if (activeEditor && event.document === activeEditor.document) {
                triggerUpdateDecorations();
            }
        }, null, context.subscriptions);
        // * IMPORTANT:
        // * To avoid calling update too often,
        // * set a timer for 100ms to wait before updating decorations
        var timeout;
        function triggerUpdateDecorations() {
            if (timeout) {
                clearTimeout(timeout);
            }
            timeout = setTimeout(updateDecorations, 100);
        }
    });
}
exports.activate = activate;
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map