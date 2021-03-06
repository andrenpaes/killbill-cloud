require 'spec_helper'

describe KPM::KillbillServerArtifact do

  before(:all) do
    @logger       = Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end

  # Takes about 7 minutes...
  it 'should be able to download and verify artifacts' do
    Dir.mktmpdir do |dir|
      info = KPM::KillbillServerArtifact.pull(@logger,
                                              KPM::BaseArtifact::KILLBILL_GROUP_ID,
                                              KPM::BaseArtifact::KILLBILL_ARTIFACT_ID,
                                              KPM::BaseArtifact::KILLBILL_PACKAGING,
                                              KPM::BaseArtifact::KILLBILL_CLASSIFIER,
                                              'LATEST',
                                              dir)
      info[:file_name].should == "killbill-profiles-killbill-#{info[:version]}.war"
      info[:size].should == File.size(info[:file_path])
    end
  end

  it 'should be able to list versions' do
    versions = KPM::KillbillServerArtifact.versions(KPM::BaseArtifact::KILLBILL_ARTIFACT_ID).to_a
    versions.size.should >= 2
    versions[0].should == '0.11.10'
    versions[1].should == '0.11.11'
  end

  it 'should get dependencies information' do
    info = KPM::KillbillServerArtifact.info('0.15.9')
    info['killbill'].should == '0.15.9'
    info['killbill-oss-parent'].should == '0.62'
    info['killbill-api'].should == '0.27'
    info['killbill-plugin-api'].should == '0.16'
    info['killbill-commons'].should == '0.10'
    info['killbill-platform'].should == '0.13'
  end
end
