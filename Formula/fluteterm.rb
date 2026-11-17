class Fluteterm < Formula
  desc "Drop-down terminal for macOS with Claude Code and Orca integration"
  homepage "https://vuhiza.github.io/fluteterm/"
  url "https://github.com/vuhiza/fluteterm/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "8142be6286ae0f778b1ae20f4cbbb238553b88e64cf16364abaad364e183baff"
  license "MIT"
  head "https://github.com/vuhiza/fluteterm.git", branch: "main"

  depends_on "rust" => :build
  depends_on :macos
  depends_on "tmux"

  def install
    # Builds target/release/fluteterm and wraps it in dist/fluteterm.app (icon, Info.plist).
    system "./scripts/bundle.sh"
    prefix.install "dist/fluteterm.app"
    bin.install_symlink prefix/"fluteterm.app/Contents/MacOS/fluteterm"
  end

  service do
    run [opt_prefix/"fluteterm.app/Contents/MacOS/fluteterm", "run"]
    keep_alive successful_exit: false
    process_type :interactive
    log_path var/"log/fluteterm.log"
    error_log_path var/"log/fluteterm.log"
  end

  def caveats
    <<~EOS
      Start fluteterm, then press F12 (fn+F12 on laptop keyboards):
        fluteterm

      Start it at login:
        brew services start fluteterm

      Optional Claude Code integration (live tab state, permission pop-ups):
        fluteterm install claude
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fluteterm --version")
  end
end
