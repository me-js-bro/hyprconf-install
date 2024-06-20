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
exports.Configuration = void 0;
const path = require("path");
const vscode = require("vscode");
const json5 = require("json5");
const util_1 = require("util");
class Configuration {
    /**
     * Creates a new instance of the Parser class
     */
    constructor() {
        this.commentConfig = new Map();
        this.languageConfigFiles = new Map();
        this.UpdateLanguagesDefinitions();
    }
    /**
     * Generate a map of configuration files by language as defined by extensions
     * External extensions can override default configurations os VSCode
     */
    UpdateLanguagesDefinitions() {
        this.commentConfig.clear();
        for (let extension of vscode.extensions.all) {
            let packageJSON = extension.packageJSON;
            if (packageJSON.contributes && packageJSON.contributes.languages) {
                for (let language of packageJSON.contributes.languages) {
                    if (language.configuration) {
                        let configPath = path.join(extension.extensionPath, language.configuration);
                        this.languageConfigFiles.set(language.id, configPath);
                    }
                }
            }
        }
    }
    /**
     * Gets the configuration information for the specified language
     * @param languageCode
     * @returns
     */
    GetCommentConfiguration(languageCode) {
        return __awaiter(this, void 0, void 0, function* () {
            // * check if the language config has already been loaded
            if (this.commentConfig.has(languageCode)) {
                return this.commentConfig.get(languageCode);
            }
            // * if no config exists for this language, back out and leave the language unsupported
            if (!this.languageConfigFiles.has(languageCode)) {
                return undefined;
            }
            try {
                // Get the filepath from the map
                const filePath = this.languageConfigFiles.get(languageCode);
                const rawContent = yield vscode.workspace.fs.readFile(vscode.Uri.file(filePath));
                const content = new util_1.TextDecoder().decode(rawContent);
                // use json5, because the config can contains comments
                const config = json5.parse(content);
                this.commentConfig.set(languageCode, config.comments);
                return config.comments;
            }
            catch (error) {
                this.commentConfig.set(languageCode, undefined);
                return undefined;
            }
        });
    }
}
exports.Configuration = Configuration;
//# sourceMappingURL=configuration.js.map