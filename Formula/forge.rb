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
      url "https://github.com/reliant-labs/forge/releases/download/v1.6.0/forge_darwin_arm64.tar.gz"
      sha256 "9e18299b5e22a38105f4efac43451a655b8eedccbaff0a920e1168b9e05fea4d"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.6.0/forge_darwin_amd64.tar.gz"
      sha256 "4547e0976e8f0b73c1db5c032cd6ae95c070927ad7b7cdeae25c4bfdb6f4e06d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.6.0/forge_linux_arm64.tar.gz"
      sha256 "a6765e52a4bb99a5a250bbad1057a84365892bcad8b0b357570618d698e35216"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.6.0/forge_linux_amd64.tar.gz"
      sha256 "021d9c9978b1e06c47813b20de9f2e4268b227696eaeea8ef7a06d41b461de50"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
