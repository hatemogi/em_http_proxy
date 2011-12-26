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

  def initialize verbose_mode = true
    @verbose = verbose_mode
  end
    
  def post_init
    @lines = []
  end

  def receive_line line
    @lines << line

    if line.start_with? "Host: "
      host, port = line[6..-1].split(':')
      port = (port || 80).to_i
      set_binary_mode
      puts uri = @lines.first.split[1]
      @proxy = EM.connect host, port, ProxyConnection, self do |p|
        p.send_data @lines.join("\n") + "\n"
      end
    end
  end

  def receive_binary_data data
    @proxy.send_data data
  end
  
  def unbind
    @proxy.close_connection_after_writing if @proxy
  end
end

EM.run {
  EM.start_server "0.0.0.0", 9000, HttpProxy
  puts "em_http_proxy is ready on :9000"
}
