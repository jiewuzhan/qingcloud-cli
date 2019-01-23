module Qingcloud
  module Cli
    class App
      COMMAND_MAP = {
        'describe-instances' => 'Get the list of host computers.',
        'run-instances' => 'Create host computers.',
        'terminate-instances' => 'Destroy host computers.'
      }
  
      def initialize(client, args=[])
        @subopts, @command = nil, nil
        @client = client
  
        @mainopts = Optimist::options do
          synopsis "A Command Line Interface for QingCloud API."
          version "qingcloud v#{Qingcloud::Cli::VERSION}"
    
          banner "Usage:"
          banner "  qingcloud [options] [<command> [suboptions]]\n \n"
          banner "Options:"
          opt :version, "Print version and exit" 
          opt :help, "Show help message" 
          stop_on COMMAND_MAP.keys
          stop_on_unknown
          banner "\nCommands:"
          COMMAND_MAP.each { |cmd, desc| banner format("  %-20s %s", cmd, desc) }
        end
  
        @command = args.shift

        if @command.nil?
          puts "Error: must with options or command."
          puts "Try --help for help."
          return
        elsif COMMAND_MAP.keys.include?(@command)
          self.send("opt_#{@command.gsub("-", "_")}")
        else 
          puts "Error: unknown command #{@command}."
          puts "Try --help for help."
          return
        end

        ret = Qingcloud::Api::Iaas.new(
          @client, 
          @command.split('-').map(&:capitalize).join, 
          @subopts.select { |k, v| v }).invoke
       
        puts "\n\nResponse: "
        ap ret.parsed_response
      end
  
      def opt_run_instances
        @subopts = Optimist::options do
          banner "options for #{@command}"
          opt :image_id, "映像ID，此映像将作为主机的模板。可传青云提供的映像ID，或自己创建的映像ID"
          opt :instance_type, "主机类型"
          opt :cpu, "CPU core，有效值为: 1, 2, 4, 8, 16", type: :integer
          opt :memory, "内存，有效值为: 1024, 2048, 4096, 6144, 8192, 12288, 16384, 24576, 32768", type: :integer 
          opt :os_disk_size, "系统盘大小，单位GB。Linux操作系统的有效值为：20-100，默认值为：20.Windows操作系统的有效值为：50-100，默认值为：50", default: 50
          opt :count, "创建主机的数量，默认是1", type: :integer, default: 1
          opt :instance_name, "主机名称"
          opt :login_mode, "指定登录方式。当为 linux 主机时，有效值为 keypair 和 passwd; 当为 windows 主机时，只能选用 passwd 登录方式。" +
            "当登录方式为 keypair 时，需要指定 login_keypair 参数；当登录方式为 passwd 时，需要指定 login_passwd 参数"
          opt :login_keypair, "登录密钥ID。"
          opt :login_passwd, "登录密码"
          opt "vxnets.n", "主机要加入的私有网络ID，如果不传此参数，则表示不加入到任何网络。" +
            "如果是自建的受管私有网络（不包括基础网络 vxnet-0 ），则可以在创建主机时指定内网IP， 这时参数值要改为 vxnet-id|ip-address ，如 vxnet-abcd123|192.168.1.2 。"
          opt :security_group, "主机加载的防火墙ID，只有在 vxnets.n 包含基础网络（即：vxnet-0）时才需要提供。 若未提供，则默认加载缺省防火墙"
          opt "volumes.n", "主机创建后自动加载的硬盘ID，如果传此参数，则参数 count 必须为1 。"
          opt :hostname, "可指定主机的 hostname 。"
          opt :need_newsid, "1: 生成新的SID，0: 不生成新的SID, 默认为0；只对Windows类型主机有效。", type: :integer
          opt :instance_class, "主机性能类型: 性能型:0 ,超高性能型:1"
          opt :cpu_model, "CPU 指令集, 有效值: Westmere, SandyBridge, IvyBridge, Haswell, Broadwell"
          opt :cpu_topology, "CPU 拓扑结构: 插槽数, 核心数, 线程数; 插槽数 * 核心数 * 线程数 应等于您应选择的CPU数量。"
          opt :gpu, "GPU 个数"
          opt :nic_mqueue, "网卡多对列: 关闭(默认)：0，开启：1", type: :integer
          opt :need_userdata, "1: 使用 User Data 功能；0: 不使用 User Data 功能；默认为 0 。", type: :integer
          opt :userdata_type, "User Data 类型，有效值：’plain’, ‘exec’ 或 ‘tar’。为 ‘plain’或’exec’ 时，使用一个 Base64 编码后的字符串；为 ‘tar’ 时，使用一个压缩包（种类为 zip，tar，tgz，tbz）。"
          opt :userdata_value, "User Data 值。当类型为 ‘plain’ 时，为字符串的 Base64 编码值，长度限制 4K；当类型为 ‘tar’，为调用 UploadUserDataAttachment 返回的 attachment_id。"
          opt :userdata_path, "User Data 和 MetaData 生成文件的存放路径。不输入或输入不合法时，为默认目录 /etc/qingcloud/userdata"
          opt :userdata_file, "userdata_type 为 ‘exec’ 时，指定生成可执行文件的路径，默认为/etc/rc.local"
          opt :target_user, "目标用户 ID ，可用于主账号为其子账号创建资源。"
          opt :dedicated_host_group_id, "虚机创建到指定的专属宿主机组中"
          opt :dedicated_host_id, "虚机创建到某专属宿主机组中指定的宿主机上"
          opt :instance_group, "虚机创建加入到指定的主机组中"
          opt :hypervisor, "hypervisor 类型，当前支持 kvm 和 bm, 默认是 kvm"
        end
      end
  
      def opt_describe_instances
        @subopts = Optimist::options do
          banner "options for #{@command}"
          # opt "instances.n", "主机ID"
          # opt "image_id.n", "一个或多个映像ID"
          # opt "instance_type.n", "主机配置类型"
          opt :instance_class, "主机性能类型: 性能型:0, 超高性能型:1", type: :integer
          # opt "status.n", "主机状态: pending, running, stopped, suspended, terminated, ceased"
          opt :search_word, "搜索关键词, 支持主机ID, 主机名称"
          # opt "tags.n", "按照标签ID过滤, 只返回已绑定某标签的资源"
          opt :dedicated_host_group_id, "按照专属宿主机组过滤"
          opt :dedicated_host_id, "按照专属宿主机组中某个宿主机过滤"
          opt :owner, "按照用户账户过滤, 只返回指定账户的资源"
          # opt :verbose, "是否返回冗长的信息, 若为1, 则返回主机相关其他资源的详细数据。", type: :integer 
          opt :offset, "数据偏移量, 默认为0", type: :integer, default: 0
          opt :limit, "返回数据长度，默认为20，最大100", type: :integer, default: 20
        end
      end

      def opt_terminate_instances
        @subopts = Optimist::options do
          banner "options for #{@command}"
          opt "instances.n", "一个或多个主机ID"
          opt :direct_cease, "是否直接彻底销毁主机，如果指定 “1” 则不会进入回收站直接销毁，默认是 “0”", default: 0
        end
      end
    end
  end
end
