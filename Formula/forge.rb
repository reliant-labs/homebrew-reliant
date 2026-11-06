class Forge < Formula
  desc "Production-ready Go + Connect RPC + Postgres + Next.js project framework"
  homepage "https://github.com/reliant-labs/forge"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.16/forge_darwin_arm64.tar.gz"
      sha256 "d6d09e63df6cff8bff6068e154dbbf1f4a8817cd66205db681ccd8eff835010e"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.16/forge_darwin_amd64.tar.gz"
      sha256 "be4565edfdfcf8fca02af652aa1421c8e457615619928152eb89ba57f35f58aa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.16/forge_linux_arm64.tar.gz"
      sha256 "52f03283bfe5267fc303f85947329f5573a9d05ee21f793265c13b7d38d0831c"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.16/forge_linux_amd64.tar.gz"
      sha256 "61e6b1586ae4ae332c8477ee8bab26829c7917023e475c894fc6613e6e672943"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
