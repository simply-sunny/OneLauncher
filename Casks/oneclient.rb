cask "oneclient" do
  arch arm: "aarch64", intel: "x64"

  version "2.12.1"
  sha256 arm:   "246cecbb8aff56a722c5b1432164fa150dd27d6ed32425507d483931633212bb",
         intel: "c5f72d26cb497d79c1323aa3cc32780dd695fd8fc8e633fc2c259654b7ec782f"

  url "https://github.com/Polyfrost/OneLauncher/releases/download/oneclient-#{version}/OneClient_#{version}_#{arch}.dmg"
  name "OneClient"
  desc "Open-source Minecraft launcher"
  homepage "https://polyfrost.org/projects/oneclient"

  auto_updates true

  app "OneClient.app"

  uninstall quit:   "org.polyfrost.OneClient",
            signal: [["TERM", "org.polyfrost.OneClient"]]
end
