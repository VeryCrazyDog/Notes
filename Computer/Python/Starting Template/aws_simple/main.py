# Import our packages
import configuration
from util.logger import Logger

# Main implementation
Logger.init_logger(Logger.DEBUG)
logger = Logger.get_logger()
config = configuration.get_configuration(logger)
message = config.get('default', 'message')
logger.info('Info is not shown on console, include logging.basicConfig() if needed')
logger.warn(message)

# Clean up
configuration.unload_configuration()
