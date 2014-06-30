require 'highline'
require 'thor'

module KPM
  module Tasks
    def self.included(base)
      base.send :include, ::Thor::Actions
      base.class_eval do

        class_option :overrides,
                     :type => :hash,
                     :default => nil,
                     :desc => "A hashed list of overrides. Available options are 'url', 'repository', 'username', and 'password'."

        class_option :ssl_verify,
                     :type => :boolean,
                     :default => true,
                     :desc => "Set to false to disable SSL Verification."

        desc "install config_file", "Install Kill Bill server and plugins according to the specified YAML configuration file."
        def install(config_file)
          Installer.from_file(config_file).install
        end

        method_option :destination,
                      :type => :string,
                      :default => nil,
                      :desc => "A different folder other than the current working directory."
        desc "pull_kb_server_war version", "Pulls Kill Bill server war from Sonatype and places it on your machine."
        def pull_kb_server_war(version='LATEST')
          response = KillbillServerArtifact.pull(BaseArtifact::KILLBILL_GROUP_ID, KillbillServerArtifact::KILLBILL_ARTIFACT_ID, KillbillServerArtifact::KILLBILL_PACKAGING, KillbillServerArtifact::KILLBILL_CLASSIFIER, version, options[:destination], options[:overrides], options[:ssl_verify])
          say "Artifact has been retrieved and can be found at path: #{response[:file_path]}", :green
        end

        desc "search_for_kb_server", "Searches for all versions of Kill Bill server and prints them to the screen."
        def search_for_kb_server
          say "Available versions: #{KillbillServerArtifact.versions(BaseArtifact::KILLBILL_GROUP_ID, KillbillServerArtifact::KILLBILL_ARTIFACT_ID, KillbillServerArtifact::KILLBILL_PACKAGING, KillbillServerArtifact::KILLBILL_CLASSIFIER, options[:overrides], options[:ssl_verify]).to_a.join(', ')}", :green
        end

        method_option :destination,
                      :type => :string,
                      :default => nil,
                      :desc => "A different folder other than the current working directory."
        desc "pull_kp_server_war version", "Pulls Kill Pay server war from Sonatype and places it on your machine."
        def pull_kp_server_war(version='LATEST')
          response = KillbillServerArtifact.pull(BaseArtifact::KILLBILL_GROUP_ID, KillbillServerArtifact::KILLPAY_ARTIFACT_ID, KillbillServerArtifact::KILLPAY_PACKAGING, KillbillServerArtifact::KILLPAY_CLASSIFIER, version, options[:destination], options[:overrides], options[:ssl_verify])
          say "Artifact has been retrieved and can be found at path: #{response[:file_path]}", :green
        end

        desc "search_for_kp_server", "Searches for all versions of Kill Pay server and prints them to the screen."
        def search_for_kp_server
          say "Available versions: #{KillbillServerArtifact.versions(BaseArtifact::KILLBILL_GROUP_ID, KillbillServerArtifact::KILLPAY_ARTIFACT_ID, KillbillServerArtifact::KILLPAY_PACKAGING, KillbillServerArtifact::KILLPAY_CLASSIFIER, options[:overrides], options[:ssl_verify]).to_a.join(', ')}", :green
        end

        method_option :destination,
                      :type => :string,
                      :default => nil,
                      :desc => "A different folder other than the current working directory."
        desc "pull_java_plugin artifact_id", "Pulls a java plugin from Sonatype and places it on your machine."
        def pull_java_plugin(artifact_id, version='LATEST')
          response = KillbillPluginArtifact.pull(artifact_id, version, :java, options[:destination], options[:overrides], options[:ssl_verify])
          say "Artifact has been retrieved and can be found at path: #{response[:file_path]}", :green
        end

        method_option :destination,
                      :type => :string,
                      :default => nil,
                      :desc => "A different folder other than the current working directory."
        desc "pull_ruby_plugin artifact_id", "Pulls a ruby plugin from Sonatype and places it on your machine."
        def pull_ruby_plugin(artifact_id, version='LATEST')
          response = KillbillPluginArtifact.pull(artifact_id, version, :ruby, options[:destination], options[:overrides], options[:ssl_verify])
          say "Artifact has been retrieved and can be found at path: #{response[:file_path]}", :green
        end

        desc "search_for_plugins", "Searches for all available plugins and prints them to the screen."
        def search_for_plugins
          all_plugins = KillbillPluginArtifact.versions(options[:overrides], options[:ssl_verify])

          result = ''
          all_plugins.each do |type, plugins|
            result << "Available #{type} plugins:\n"
            Hash[plugins.sort].each do |name, versions|
              result << "  #{name}: #{versions.to_a.join(', ')}\n"
            end
          end

          say result, :green
        end

        method_option :destination,
                      :type => :string,
                      :default => nil,
                      :desc => "A different folder other than the current working directory."
        desc "pull_kaui_war version", "Pulls Kaui war from Sonatype and places it on your machine."
        def pull_kaui_war(version='LATEST')
          response = KauiArtifact.pull(version, options[:destination], options[:overrides], options[:ssl_verify])
          say "Artifact has been retrieved and can be found at path: #{response[:file_path]}", :green
        end

        desc "search_for_kaui", "Searches for all versions of Kaui and prints them to the screen."
        def search_for_kaui
          say "Available versions: #{KauiArtifact.versions(options[:overrides], options[:ssl_verify]).to_a.join(', ')}", :green
        end
      end
    end
  end
end
