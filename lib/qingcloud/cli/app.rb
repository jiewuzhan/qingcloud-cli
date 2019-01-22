module Qingcloud
  module Cli
    class App
      COMMAND_MAP = {
        'describe-instances' => 'Get the list of host computers.',
        'run-instances' => 'Create host computers.',
        'terminate-instance' => 'Destroy host computers.'
      }
  
      def initialize(args)
        @subopts, @command = nil, nil
  
        @mainopts = Optimist::options do
          version "qingcloud v#{Qingcloud::Cli::VERSION}"
    
          banner "Usage:"
          banner "  qingcloud [options] [<command> [suboptions]]\n \n"
          banner "Options:"
          opt :version, "Print version and exit" 
          opt :help, "Show help message" 
          opt :configuration, "Path of configuration"
          stop_on COMMAND_MAP.keys
          stop_on_unknown
          banner "\nCommands:"
          COMMAND_MAP.each { |cmd, desc| banner format("  %-20s %s", cmd, desc) }
        end
  
        return if args.empty?
  
        @command = args.shift
        self.send("opt_#{@command.gsub("-", "_")}")
      end
  
      def opt_run_instances
        @subopts = Optimist::options do
          banner "options for #{@command}"
          opt :depth, "depth", :type => :integer
          opt :bare, "bare mode"
          opt :mirror, "mirror something"
        end
      end
  
      def opt_describe_instances
        @subopts = Optimist::options do
          banner "options for #{@command}"
          opt :quiet, "be quiet"
        end
      end

      def opt_terminate_instances
        @subopts = Optimist::options do
          banner "options for #{@command}"
          opt :quiet, "be quiet"
        end
      end
    end
  end
end
