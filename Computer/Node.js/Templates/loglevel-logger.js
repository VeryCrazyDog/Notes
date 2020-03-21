'use strict'

// Include 3rd party modules
const loglevel = require('loglevel')
const loglevelPrefix = require('loglevel-plugin-prefix')

// Build level description mapping
const levelDescriptions = Object.entries(loglevel.levels).reduce((accumulator, [desc, index]) => {
  accumulator[index] = desc
  return accumulator
}, [])

// Module initialization
loglevel.setDefaultLevel('info')
loglevelPrefix.reg(loglevel)
loglevelPrefix.apply(loglevel, {
  template: '%t [%l]',
  timestampFormatter: date => date.toISOString()
})

// Apply our log level
if (process.env.LOG_LEVEL) {
  loglevel.setLevel(process.env.LOG_LEVEL)
}

// Add extra function
loglevel.getLevelDescription = function () {
  return levelDescriptions[this.getLevel()]
}

module.exports = loglevel

// TODO Remove the code below when using this template
if (require.main === module) {
  loglevel.trace('trace')
  loglevel.debug('debug')
  loglevel.debug('debug', 'm1', 'm2', 'm3')
  loglevel.getLogger('critical').info('Something significant happened')
  loglevel.log('log')
  loglevel.info('info')
  loglevel.warn('warn')
  loglevel.error('error')
}
