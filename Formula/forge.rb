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
      url "https://github.com/reliant-labs/forge/releases/download/v1.4.0/forge_darwin_arm64.tar.gz"
      sha256 "f37834bc4b349dc459dc4553db2288a847d464ef9ba5ca620e87fe0e7c72b3dc"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.4.0/forge_darwin_amd64.tar.gz"
      sha256 "c286a4b9abc5d01188957f0212d6ba32464f8f38af37b84a2ec82d5c2be198bf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.4.0/forge_linux_arm64.tar.gz"
      sha256 "2c3818d600b3cc8f7f057b1e995f8f6235648ee5fca1694006c5e365e0368a2e"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.4.0/forge_linux_amd64.tar.gz"
      sha256 "4de0e855c43c4a8ff894c8de27320acf5f8087ae11a8364e4b10bacefd0695b7"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
