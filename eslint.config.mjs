// ESLint-Konfiguration für das Controller-Mapping, angelehnt an die Regeln
// des Mixxx-Projekts (res/controllers).
export default [
    {
        files: ["controllers/**/*.js"],
        languageOptions: {
            ecmaVersion: 2020,
            sourceType: "script",
            globals: {
                engine: "readonly",
                midi: "readonly",
                script: "readonly",
                components: "readonly",
                ColorMapper: "readonly",
                console: "readonly",
                print: "readonly",
            },
        },
        rules: {
            camelcase: ["error", {properties: "never"}],
            curly: "error",
            eqeqeq: "error",
            indent: ["error", 4],
            "no-unused-vars": ["error", {args: "none"}],
            "no-var": "error",
            "prefer-const": "error",
            "prefer-template": "error",
            quotes: ["error", "double"],
            semi: "error",
            "no-trailing-spaces": "error",
            "comma-dangle": ["error", "always-multiline"],
        },
    },
];
