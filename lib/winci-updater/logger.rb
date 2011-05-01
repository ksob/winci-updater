require 'logger'

module WinCI
  module Updater

    class TLogger < Logger
      attr_reader :logger

      def initialize(file, shift_age, stdout, verbose=false)
        @logger = Logger.new(file, shift_age)
        @logger.level = Logger::INFO
        @verbose = verbose
        @stdout = stdout
      end

      def log(str, lvl=:info)
        @logger.send(lvl, str)
        if lvl == :fatal
          raise str
        elsif (@verbose or !(lvl == :info))
          @stdout.puts(str) if (@verbose or !(lvl == :info))
        end
      end

      def info(str, lvl=:info)
        @logger.send(lvl, str)
        if lvl == :fatal
          raise str
        elsif (@verbose or !(lvl == :info))
          @stdout.puts(str) if (@verbose or !(lvl == :info))
        end
      end

      def debug(str, lvl=:debug)
        @logger.send(lvl, str)
        if lvl == :fatal
          raise str
        elsif (@verbose or !(lvl == :info))
          @stdout.puts(str) if (@verbose or !(lvl == :info))
        end
      end

      def fatal(str, lvl=:fatal)
        @logger.send(lvl, str)
        if lvl == :fatal
          raise str
        elsif (@verbose or !(lvl == :info))
          @stdout.puts(str) if (@verbose or !(lvl == :info))
        end
      end
    end # of Class TLogger

  end
end