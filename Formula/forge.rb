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
      url "https://github.com/reliant-labs/forge/releases/download/v1.5.0/forge_darwin_arm64.tar.gz"
      sha256 "0285f11dd39471d9bf2286cd1e9d7a6636c650ca40af90646770be6393563fd4"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.5.0/forge_darwin_amd64.tar.gz"
      sha256 "9038229a3f0222ac1f923e11d5583019c2ed6efbdeee3848e4d35e34b329365e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.5.0/forge_linux_arm64.tar.gz"
      sha256 "3fa11e319aa1a76a3433e7bd9731e4c88d92a69cfd053c6f154ee1b70391cf46"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.5.0/forge_linux_amd64.tar.gz"
      sha256 "0c58ad5a23fa8d36d5d8a27ca83b6b2ec932cbef10cf40ef977b46fcec931aff"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
