require "logger"

module WinCI
  module Updater

    UPDATER_WINDOW_TITLE = 'Updater'

    LOG_FILE = 'git_responses.log' # file used to log git command responses
    LOGGER_LEVEL = Logger::DEBUG # possible values: Logger::DEBUG, Logger::INFO, Logger::WARN, Logger::ERROR, Logger::FATAL

    TOLERATED_STASH_MESSAGES = [\
    'No local changes to save', \
    'Saved working directory .*HEAD is now at .*',\
    ]

    # actually they are not messages from 'pull' but from 'merge' which is part of 'pull' command
    TOLERATED_PULL_MESSAGES = [\
    'Already up-to-date.', \
    'Updating .*', \
    'Merge made by recursive..*',\
    ]

    TOLERATED_CLONE_MESSAGES = [\
    'Already up-to-date.',\
    ]

    # button constants
    MB_OK = 0x00000000
    MB_OKCANCEL = 0x00000001
    MB_ABORTRETRYIGNORE = 0x00000002
    MB_YESNOCANCEL = 0x00000003
    MB_YESNO = 0x00000004
    MB_RETRYCANCEL = 0x00000005
    MB_SETFOREGROUND = 0x00010000
    MB_TOPMOST = 0x00040000
    MB_ICONEXCLAMATION = 0x00000030
    MB_CANCELTRYCONTINUE = 0x00000006
    MB_ICONHAND = 0x00000010
    MB_ICONQUESTION = 0x00000020
    MB_ICONASTERISK = 0x00000040
    MB_USERICON = 0x00000080
    MB_ICONWARNING = MB_ICONEXCLAMATION
    MB_ICONERROR = MB_ICONHAND
    MB_ICONINFORMATION = MB_ICONASTERISK
    MB_ICONSTOP = MB_ICONHAND

    # return code constants
    CLICKED_OK = 1
    CLICKED_CANCEL = 2
    CLICKED_ABORT = 3
    CLICKED_RETRY = 4
    CLICKED_IGNORE = 5
    CLICKED_YES = 6
    CLICKED_NO = 7

  end
end