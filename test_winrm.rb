#!/usr/bin/env ruby

require 'winrm'

endpoint = '127.0.0.1'
client_cert = '/Users/George.Holt/git/train-winrm/test/integration/fixtures/.openssl/user.pem'
client_key = '/Users/George.Holt/git/train-winrm/test/integration/fixtures/.openssl/key.pem'

opts = {
  endpoint: "https://#{endpoint}:55986/wsman",
  transport: :ssl,
  no_ssl_peer_verification: true,
  client_cert: client_cert,
  client_key: client_key,
}

ps_script = <<-PS_SCRIPT
# Must use net commands pre Powershell 5.1
$PSVersionTable
# net user Administrator #{ENV['WINRM_PASSWORD']}
PS_SCRIPT

conn = WinRM::Connection.new(opts)
conn.shell(:powershell) do |shell|
  output = shell.run(ps_script) do |stdout, stderr|
    STDOUT.print stdout
    STDERR.print stderr
  end
  puts "The script exited with exit code #{output.exitcode}"
end
