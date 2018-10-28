# Import build-in packages
import logging

# Import our packages
import configuration


class Logger:
    """
    Factory for logging initialization
    """

    # Constants
    CRITICAL = 50
    FATAL = CRITICAL
    ERROR = 40
    WARNING = 30
    WARN = WARNING
    INFO = 20
    DEBUG = 10
    NOTSET = 0

    _is_init = False

    @staticmethod
    def init_logger(level):
        if not Logger._is_init:
            if level not in [
                logging.DEBUG,
                logging.INFO,
                logging.WARN,
                logging.ERROR,
                logging.FATAL
            ]:
                level = logging.INFO
            logging.getLogger().setLevel(level)
            # Set logger for packages used by AWS
            if level < logging.INFO:
                level = logging.INFO
            logging.getLogger('boto3').setLevel(level)
            logging.getLogger('botocore').setLevel(level)
            logging.getLogger('nose').setLevel(level)
            Logger._is_init = True

    @staticmethod
    def get_logger():
        return logging.getLogger()
