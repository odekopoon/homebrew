require 'formula'

class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage 'http://www.gnu.org/software/kawa/'
  url 'http://ftpmirror.gnu.org/kawa/kawa-2.0.jar'
  mirror 'http://ftp.gnu.org/gnu/kawa/kawa-2.0.jar'
  sha1 '150dacc0b1dbf55c5493da022a590d9d8549b3b6'

  def install
    prefix.install "kawa-#{version}.jar"
    (bin+'kawa').write <<-EOS.undent
      #!/bin/sh
      thisfile=`which $0`
      thisdir=`dirname $thisfile`
      if [ "$#" -eq 0 ]
      then
         command_line="$0"
      else
         command_line="$0 $*"
      fi
      test -t 0 || no_console="--no-console"

      KAWA_HOME="#{prefix}"
      KAWA_LIB="$KAWA_HOME/kawa-#{version}.jar"
      CLASSPATH="${KAWA_LIB}:${CLASSPATH}"
      export CLASSPATH

      # This ugly duplication is so we only have to use arrays (which are
      # non-Posix and non-portable) if there is a -D or -J option.
      case "$1" in
          -D* | -J*)
              i=0
              for arg in "$@"; do
                  case "$arg" in
                      -D*)
                          jvm_args[i++]="$arg"
                          shift
                      ;;
                      -J*)
                          jvm_args[i++]="$(echo $arg|cut -c 3-)"
                          shift
                      ;;
                      *) break
                      ;;
                  esac
              done
              exec ${JAVA-"java"} -Dkawa.command.line="${command_line}" "${jvm_args[@]}" kawa.repl ${no_console} "$@"
              ;;
          *)
              exec ${JAVA-"java"} -Dkawa.command.line="${command_line}" kawa.repl ${no_console} "$@"
              ;;
      esac
    EOS
  end
end
