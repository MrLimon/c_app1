const { jestConfig } = require('@salesforce/lwc-jest/config');
module.exports = {
  ...jestConfig,
  "modulePathIgnorePatterns": [ "node_modules" ]
};