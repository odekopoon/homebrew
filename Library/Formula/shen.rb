require 'formula'

class Shen < Formula
  homepage 'http://www.shenlanguage.org/'
  url 'http://shenlanguage.org/Download/Shen.zip'
  version '19.2'

  if ARGV.include? "--sbcl"
    depends_on 'sbcl'
  else
    depends_on 'clisp'
  end

  def options
    [["--sbcl", "Build SBCL version."]]
  end

  def install
    if ARGV.include?("--sbcl") then
      system "cp KLambda/* Platforms/SBCL"
      safe_system "cd Platforms/SBCL; sbcl --load install.lsp"
      system "mv Platforms/SBCL/Shen.exe shen"
    else
      system "cp KLambda/* Platforms/CLisp"
      safe_system "cd Platforms/CLisp; clisp -i install.lsp"
      system "echo \"#!/bin/bash\nclisp -M #{prefix}/Shen.mem $*\" > shen"
      prefix.install ['Platforms/CLisp/Shen.mem']
    end
    system "chmod 755 shen"
    bin.install 'shen'
  end
end
