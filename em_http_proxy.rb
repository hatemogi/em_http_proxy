require 'eventmachine'

class ProxyConnection < EM::Connection
  def initialize peer
    @peer = peer
  end

  def receive_data data
    @peer.send_data data
  end

  def unbind
    @peer.close_connection_after_writing
  end
end
  
module HttpProxy 
  include EM::P::LineText2

  def post_init
    @lines = []
  end

  def receive_line line
    @lines << line
    if line.start_with? 'Host'
      set_binary_mode
      field, host, port = line.split ':'
      @proxy = EM.connect host.strip, (port || 80).to_i, ProxyConnection, self do |p|
        p.send_data @lines.join("\r\n") + "\r\n"
      end
      puts uri = @lines[0].split[1]
    end
  end

  def receive_binary_data data
    @proxy.send_data data
  end
  
  def unbind
    @proxy.close_connection if @proxy
  end
end

EM.run do
  EM.start_server "0.0.0.0", 9000, HttpProxy
  puts "em_http_proxy is ready on :9000"
end
