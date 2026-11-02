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
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.13/forge_darwin_arm64.tar.gz"
      sha256 "c2c8700c678187409b4b4264a66b61dfcbdc864e10cb59641c20bd7fe539e16f"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.13/forge_darwin_amd64.tar.gz"
      sha256 "2c179c737c6d1dd631f59be37fe307a26e72ff66c0ab0281c9431e25d695cab0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.13/forge_linux_arm64.tar.gz"
      sha256 "d445538e49d549f8eaa72433d987f56add6dfa88bad80d2d56417d9ba5bc178a"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.13/forge_linux_amd64.tar.gz"
      sha256 "cad8438552a1c7e6f34053439b57ac7793fc8b2c1d8a243ba6d479a9b1133caf"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
