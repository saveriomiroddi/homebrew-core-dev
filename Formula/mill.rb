class Mill < Formula
  desc "Scala build tool"
  homepage "https://www.lihaoyi.com/mill/"
  url "https://github.com/lihaoyi/mill/releases/download/0.5.9/0.5.9"
  sha256 "3f7cf234c8ceb7ae8adb1bcbcd5ee05edd4429dda87597ca1baeff8fb1a87900"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.java_home_env("1.8+")
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.12.8"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
