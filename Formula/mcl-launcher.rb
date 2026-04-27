class MclLauncher < Formula
  desc "A fully featured Minecraft launcher TUI"
  homepage "https://github.com/objz/mcl"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/mcl/releases/download/v0.2.4/mcl-launcher-aarch64-apple-darwin.tar.xz"
      sha256 "520080aef0648ffa53147b18f5ca6e524d11f6309ad9039a299389d6883371bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/mcl/releases/download/v0.2.4/mcl-launcher-x86_64-apple-darwin.tar.xz"
      sha256 "95c50ff7dddf2980618f4a55d5ba351eae76767f8c5250c943cf9685130ef47e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/mcl/releases/download/v0.2.4/mcl-launcher-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60bcb610aecc3ca529fe2fd836998ece6fb716be61d699052b1287fb87ca5fc1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/mcl/releases/download/v0.2.4/mcl-launcher-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c582f6f794583cd6e5eae96aa9f59d354ec88fdf97b5143e1c967aa47695bb0b"
    end
  end
  license "GPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "mcl" if OS.mac? && Hardware::CPU.arm?
    bin.install "mcl" if OS.mac? && Hardware::CPU.intel?
    bin.install "mcl" if OS.linux? && Hardware::CPU.arm?
    bin.install "mcl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
