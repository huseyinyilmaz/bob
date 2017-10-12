module Env where

import Types(BobInput(..),
             BobEnv(..))
import Build(buildRepo)
import Turtle
import qualified Data.Text as Text
import System.Environment (lookupEnv)
import Data.Monoid(First(..), (<>))
import Data.Maybe(fromJust)

command :: Parser BobInput
command = BobInput <$>
          (optText "name" 'n' "Git Project Name.") <*>
          (optText "branch" 'b' "Git Branch to use for build.") <*>
          (optional $ optText "repo-url" 'u' "URL for git repository.") <*>
          (optional $ optText "docker-name" 'n' "Project name on dockerhub.") <*>
          (optional $ optText "docker-owner" 'o' "User name on dockerhub.") <*>
          (optional $ optText "docker-tag" 't' "Docker tag for dockerhub.") <*>
          (switch "push" 'p' "Push to dockerhub after build.")


getEnvironment :: Text -> IO BobEnv
getEnvironment n = do
  maybeOwner <- lookupEnvText "BOB_DOCKER_OWNER"
  putStrLn ("Attempting to get url from environment variable " <> (Text.unpack varName))
  bobRepoUrl <- lookupEnvText $ Text.unpack $ varName
  return BobEnv {
    repoUrl=bobRepoUrl,
    dockerOwner=maybeOwner
    }
  where
    varName = "BOB_" <> (Text.toUpper n) <> "_REPO_URL"
    lookupEnvText = (fmap (fmap Text.pack)) . lookupEnv



description :: Description
description = "This is bob description"

getFirstMaybe :: Maybe a -> Maybe a -> a
getFirstMaybe a b = fromJust $ getFirst $ First a <> First b


readData :: IO ()
readData = do
  bobCommand <- options description command
  let bobName = name bobCommand
      bobBranch = branch bobCommand
  bobEnv <- getEnvironment bobName
  let bobRepoUrl = getFirstMaybe (repoUrl (bobCommand::BobInput)) (repoUrl (bobEnv::BobEnv))
      bobDockerName = getFirstMaybe (dockerName bobCommand) (Just bobName)
      bobDockerTag = getFirstMaybe (dockerTag bobCommand) (Just bobBranch)
      bobDockerOwner = getFirstMaybe (dockerOwner (bobCommand::BobInput)) (dockerOwner (bobEnv::BobEnv))
      dockerRepo = bobDockerOwner <> "/" <> bobDockerName <> ":" <> bobDockerTag
  buildRepo bobName bobBranch bobRepoUrl dockerRepo (pushFlag bobCommand)
