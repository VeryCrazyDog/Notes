For invoking and testing AWS Lambda function. Expected folder structure is:
```yaml
- app: Top level folder
  - env: Folder for environment variables configuration files
    - local.json: The default environment variables configuration file
  - test: Folder containing testing source codes and resources
    - run.js: The Lambda invoking source code below.
  - index.js: AWS Lambda function to be tested.
```
Source code:
```js
'use strict'

// Include build-in libraries
const path = require('path')
const fs = require('fs')

// Our constants
const DEFAULT_ENV_CONFIG_PATH = 'local.json'

// Handle arguments
let explicitEnvConfigPath = false
let envConfigPathInput
if (process.argv[2]) {
  explicitEnvConfigPath = true
  envConfigPathInput = process.argv[2]
} else {
  envConfigPathInput = DEFAULT_ENV_CONFIG_PATH
}
let envConfigPath = path.join(__dirname, envConfigPathInput)

// Read environment variables configuration file
if (!fs.existsSync(envConfigPath)) { envConfigPath = envConfigPathInput }
if (!fs.existsSync(envConfigPath)) { envConfigPath = path.join(__dirname, 'env', envConfigPathInput) }
if (!fs.existsSync(envConfigPath)) {
  let message
  if (explicitEnvConfigPath) {
    message = `Failed to load environment variables configuration file from '${envConfigPathInput}'`
  } else {
    message = `Please create environment variables configuration file at '${envConfigPath}' before running`
  }
  console.log(message)
  process.exit(1)
}
let envConfig = JSON.parse(fs.readFileSync(envConfigPath, 'utf8'))

// Update environment variables
process.env = {
  ...process.env,
  ...envConfig
}

// Include our Lambda function
const app = require('../index.js')

// Main implementation
;(async () => {
  try {
    console.log('----- Calling app -----')
    // Execute our Lambda function
    let result = await app.handler()
    console.log('----- App ended with result -----')
    console.log(result)
  } catch (error) {
    console.log('----- App ended with error -----')
    console.log(error)
  }
})()
```
