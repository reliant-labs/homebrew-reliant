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
      url "https://github.com/reliant-labs/forge/releases/download/v1.7.0/forge_darwin_arm64.tar.gz"
      sha256 "61efdd58fc54133a62df91307761191d7f6098a856d1902112a931a2843b91bb"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.7.0/forge_darwin_amd64.tar.gz"
      sha256 "d4b44873f42168d0ce711a371197d4117c900670e67f9755a5fda6d2cb3b8bcd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.7.0/forge_linux_arm64.tar.gz"
      sha256 "8b94faa04b0edf6d3f0d21894ee0d47d0841d735028b20b6b8e692857361227a"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.7.0/forge_linux_amd64.tar.gz"
      sha256 "57b2cfd6dd44cb20e14f69f5750bafd9c0d0d6b97163913c85835aa1048fd34c"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
