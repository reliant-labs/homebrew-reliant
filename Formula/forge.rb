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
      url "https://github.com/reliant-labs/forge/releases/download/v1.12.0/forge_darwin_arm64.tar.gz"
      sha256 "83b3f768b8e2711186d4c50e04b10097ec61aa3d73d71900ebd8b8b4c722b0f1"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.12.0/forge_darwin_amd64.tar.gz"
      sha256 "1f16413fdf567671ad098c8cbaad3e3f2df184004d9a30661e5a455af0f5f643"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.12.0/forge_linux_arm64.tar.gz"
      sha256 "95e199eab79418402b6601df75c578dcd9fe00b95e2de4227f166a062346503f"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.12.0/forge_linux_amd64.tar.gz"
      sha256 "fcbf7bbbfbc7ccb1c8410879ed22482ddad856483bde4d8bc7b567476241c7ac"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
