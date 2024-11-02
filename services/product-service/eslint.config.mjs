// eslint.config.mjs
import globals from "globals";
import tsPlugin from "@typescript-eslint/eslint-plugin";
import tsParser from "@typescript-eslint/parser";
import reactPlugin from "eslint-plugin-react";
import jestPlugin from "eslint-plugin-jest";

export default [
    {
        ignores: ["node_modules"], // Ignore node_modules by default
    },
    {
        files: ["**/*.{js,mjs,cjs,ts,jsx,tsx}"],
        languageOptions: {
            parser: tsParser,
            ecmaVersion: "latest",
            sourceType: "module",
            globals: {
                ...globals.browser,
                ...globals.node,
                jest: "readonly", // Enables Jest globals like `test` and `expect`
            },
        },
        plugins: {
            "@typescript-eslint": tsPlugin,
            react: reactPlugin,
            jest: jestPlugin,
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
    },
    // Jest-specific rules for test files
    {
        files: ["**/*.test.js", "**/*.test.ts"],
        plugins: {
            jest: jestPlugin,
        },
        rules: {
            "jest/no-disabled-tests": "warn",
            "jest/no-focused-tests": "error",
            "jest/no-identical-title": "error",
            "jest/prefer-to-have-length": "warn",
            "jest/valid-expect": "error",
        },
    },
];
