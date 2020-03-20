const loglevel = require('loglevel')
const loglevelPrefix = require('loglevel-plugin-prefix')

loglevel.setDefaultLevel('info')
loglevelPrefix.reg(loglevel)
loglevelPrefix.apply(loglevel, {
  template: '%t [%l]',
  timestampFormatter: date => date.toISOString()
})

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
