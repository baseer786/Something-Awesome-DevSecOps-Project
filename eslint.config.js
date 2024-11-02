// eslint.config.js
import react from 'eslint-plugin-react';
import typescript from '@typescript-eslint/eslint-plugin';
import typescriptParser from '@typescript-eslint/parser';

export default [
    {
        ignores: ["node_modules"], // Ignore node_modules by default
    },
    {
        files: ["**/*.js", "**/*.ts"],
        plugins: {
            react,
            "@typescript-eslint": typescript,
        },
        languageOptions: {
            parser: typescriptParser,
            ecmaVersion: "latest",
            sourceType: "module",
            globals: {
                browser: true,
                es2021: true,
            },
        },
        settings: {
            react: {
                version: "detect"
            }
        },
        rules: {
            "no-unused-vars": "warn",
            "no-console": "off",
            "@typescript-eslint/no-require-imports": "error"
        }
    },
    {
        // Separate configuration for test files to enable Jest globals
        files: ["**/*.test.js", "**/*.test.ts"],
        languageOptions: {
            globals: {
                test: true,
                expect: true,
                jest: true,
            },
        },
    },
];
