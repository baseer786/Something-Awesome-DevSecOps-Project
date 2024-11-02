// eslint.config.js
import react from 'eslint-plugin-react';
import typescriptPlugin from '@typescript-eslint/eslint-plugin';
import typescriptParser from '@typescript-eslint/parser';

export default [
    {
        ignores: ["node_modules"], // Ignore node_modules by default
    },
    {
        files: ["**/*.js", "**/*.ts", "**/*.jsx", "**/*.tsx"],
        languageOptions: {
            parser: typescriptParser,
            ecmaVersion: "latest",
            sourceType: "module",
            globals: {
                // Jest and browser globals
                test: "readonly",
                expect: "readonly",
                jest: "readonly",
                window: "readonly",
                document: "readonly",
            },
        },
        plugins: {
            react,
            "@typescript-eslint": typescriptPlugin,
        },
        settings: {
            react: {
                version: "detect",
            },
        },
        rules: {
            "no-unused-vars": "warn",
            "no-console": "off",
            "@typescript-eslint/no-require-imports": "error",
        },
    }
];

