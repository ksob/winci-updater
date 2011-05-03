module WinCI
  module Updater
    module Gui

      def message_box(txt, title='Ruby', buttons=MB_OK | MB_SETFOREGROUND)
        user32 = DL.dlopen('user32')
        msgbox = user32['MessageBoxA', 'ILSSI']
        r, rs = msgbox.call(0, txt, title, buttons)
        return r
      end

      def inputbox(message, title="Message from #{__FILE__}")
        # returns nil if 'cancel' is clicked
        # returns a (possibly empty) string otherwise
        require 'win32ole'
        # hammer the arguments to vb-script style
        vb_msg = %Q| "#{message.gsub("\n", '"& vbcrlf &"')}"|
        vb_msg.gsub!("\t", '"& vbtab &"')
        vb_msg.gsub!('&""&', '&')
        vb_title = %Q|"#{title}"|
        # go!
        sc = WIN32OLE.new("ScriptControl")
        sc.language = "VBScript"
        sc.eval(%Q|Inputbox(#{vb_msg}, #{vb_title})|)
      end

      def popup(message)
        require 'win32ole'
        wsh = WIN32OLE.new('WScript.Shell')
        wsh.popup(message, 0, __FILE__)
      end

      def prompt_user(msgRequest, msgWrong)
        answer = ''
        # prompt user to select destination installation disk
        i = 0
        begin
          puts msgWrong if i > 0
          answer = inputbox msgRequest
          exit if not answer
          answer = answer.upcase[0].chr if answer.length > 0
          i = i + 1
        end while !answer or (answer !~ /\A[A-Z]\Z/)
        answer
      end
    end
  end
end