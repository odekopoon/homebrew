require 'formula'

class Smlsharp < Formula
  homepage 'http://www.pllab.riec.tohoku.ac.jp/smlsharp/'
  url 'http://www.pllab.riec.tohoku.ac.jp/smlsharp/download/smlsharp-1.2.0.tar.gz'
  sha1 '4eb9c0559656e35a989c8500daf99883767825d9'

  depends_on 'xz'
  depends_on 'gmp'
  depends_on 'smlnj'

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    ENV.m32
    ENV.append 'AS', '-m32'
    ENV.append 'CC', '-m32'
    ENV.append 'CXX', '-m32'

    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fast-build"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test smlsharp`.
    system "false"
  end
end
