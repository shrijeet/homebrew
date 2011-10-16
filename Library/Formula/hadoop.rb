require 'formula'

class Hadoop < Formula
  url 'http://archive.cloudera.com/cdh/3/hadoop-0.20.2-cdh3u0.tar.gz'
  homepage 'http://hadoop.apache.org/common/'
  md5 'cc4b15e1dfd768109f98501a22105e95'

  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec #{libexec}/bin/#{target} $*
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf contrib lib webapps]
    libexec.install Dir['*.jar']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end

  def caveats
    <<-EOS.undent
      $JAVA_HOME must be set for Hadoop commands to work.
    EOS
  end
end
