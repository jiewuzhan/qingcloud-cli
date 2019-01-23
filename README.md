# Qingcloud::Cli

Command line tool for QingCloud

## Installation

This tool(gem) is not ready, you can only install it from source code. It'll be published to [RubyGems](https://rubygems.org) when it's ok.

Get Code from Github:

	$ git clone https://github.com/jiewuzhan/qingcloud-cli.git

Build and Install with Bundle:

    $ cd qingcloud-cli
    $ bundle install
    $ bundle exec rake install

## Uninstall

	$ gem uninstall qingcloud-cli
	

## Usage

    Usage:
        qingcloud [options] [<command> [suboptions]]

    Options:
        -v, --version    Print version and exit
        -h, --help       Show help message

    Commands:
        describe-instances   Get the list of host computers.
        run-instances        Create host computers.
        terminate-instances  Destroy host computers.

## Getting Started

After install this command line tool, just bring up your terminal and give it a try.

```bash
$ qingcloud --help
Usage:
  qingcloud [options] [<command> [suboptions]]

Options:
  -v, --version    Print version and exit
  -h, --help       Show help message

Commands:
  describe-instances   Get the list of host computers.
  run-instances        Create host computers.
  terminate-instances  Destroy host computers.
```

```bash
$ qingcloud describe-instances --help
Usage: qingcloud describe-instances [options]

Specific options:
  -i, --instances-N=<s>                主机ID
  -m, --image-id-N=<s>                 一个或多个映像ID
  -n, --instance-type-N=<s>            主机配置类型
  -s, --instance-class=<i>             主机性能类型: 性能型:0, 超高性能型:1
  -t, --status-N=<s>                   主机状态: pending, running, stopped, suspended, terminated, ceased
  -e, --search-word=<s>                搜索关键词, 支持主机ID, 主机名称
  -a, --tags-N=<s>                     按照标签ID过滤, 只返回已绑定某标签的资源
  -d, --dedicated-host-group-id=<s>    按照专属宿主机组过滤
  -c, --dedicated-host-id=<s>          按照专属宿主机组中某个宿主机过滤
  -o, --owner=<s>                      按照用户账户过滤, 只返回指定账户的资源
  -v, --verbose=<i>                    是否返回冗长的信息, 若为1, 则返回主机相关其他资源的详细数据。
  -f, --offset=<i>                     数据偏移量, 默认为0 (default: 0)
  -l, --limit=<i>                      返回数据长度，默认为20，最大100 (default: 20)
  -z, --zone=<s>                       区域ID，注意要小写
  -h, --help                           Show this message
```

#### Command Suggestions

```bash
$ qingcloud des # press enter now, and you will get subcommand suggestions
qingcloud describe-instances
```

## Example

```bash
# Describe Instances

$ qingcloud describe-instances -z ap1
{
  "action": "DescribeInstancesResponse",
  "instance_set": [

  ],
  "total_count": 0,
  "ret_code": 0
}

# Run Instances

$ qingcloud run-instances -m centos7x64b -l keypair -k keypair-id -C 1 -M 1024 -z ap1
{
  "action": "RunInstancesResponse",
  "instances": [
    "instance-id"
  ],
  "job_id": "job-id",
  "ret_code": 0
}


## Contributing

1. Fork it ( https://github.com/jiewuzhan/qingcloud-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

