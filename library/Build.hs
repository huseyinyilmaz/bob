module Build(buildRepo) where
import System.Directory (getHomeDirectory)
import qualified Data.Text as Text
import Turtle

echoText :: Text -> IO ()
echoText = echo . fromString . Text.unpack

toFilePath :: Text -> Turtle.FilePath
toFilePath = fromString . Text.unpack

rmIfExists :: Turtle.FilePath -> IO()
rmIfExists path = do
  exists <- testdir path
  if exists
    then rmtree path
    else return ()

gitClone :: Text -> IO()
gitClone repo = stdout $ inproc "git" ["clone", repo] empty

gitCheckout :: Text -> IO()
gitCheckout branch = stdout $ inproc "git" ["checkout", branch] empty

dockerBuild :: Text -> IO()
dockerBuild dockerUrl = stdout $ inproc "docker" ["build", ".", "--tag=" <> dockerUrl] empty

dockerPush :: Text -> IO()
dockerPush dockerUrl = stdout $ inproc "docker" ["push", dockerUrl] empty

buildRepo :: Text -> Text -> Text -> (Maybe Turtle.FilePath) -> Text -> Text  -> Bool -> IO ()
buildRepo name branch repoUrl maybeRepoUpdatePath dockerUrl dockerFilePath pushFlag = do
  homeDir <- getHomeDirectory
  let buildDir = fromString homeDir </> "build" </> (toFilePath name)
      projectDir = buildDir </> (toFilePath dockerFilePath)
  echoSummary
  rmIfExists buildDir
  mktree buildDir
  cd buildDir
  gitClone repoUrl
  cd projectDir
  gitCheckout branch
  case maybeRepoUpdatePath of
    Just repoUpdatePath -> cptree repoUpdatePath projectDir
    Nothing -> return ()
  -- cptree repoUpdatePath projectDir
  dockerBuild dockerUrl
  rmtree projectDir
  when pushFlag $ dockerPush dockerUrl
  echo "Complete"
  echoSummary
  where
    echoSummary = do
      echo "============="
      echo "Configuration"
      echo "============="
      echoText ("name: " <> name)
      echoText ("branch: " <> branch)
      echoText ("repo url: " <> repoUrl)
      echoText ("docker url: " <> dockerUrl)
      echo "============="
