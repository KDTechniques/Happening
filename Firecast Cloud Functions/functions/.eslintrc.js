module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "quotes": ["error", "double"],
    "max-len": 0,
  },
  // Newly added property
  parserOptions: {
    "ecmaVersion": 2020,
  },
};
