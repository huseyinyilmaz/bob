module Types(BobInput(..),
             BobEnv(..)) where

import Data.Text (Text)
import Turtle

-- input fields
--------------
-- name BOB_NAME
-- branch BOB_BRANCH
-- repo-owner BOB_REPO_OWNER
-- repo-url (BOB_REPO_URL)

-- Output fields
--------------
-- docker docker-name (BOB_DOCKER_NAME) (same as name if not provided.)
-- docker user (BOB_DOCKER_USER)
-- tag (same as branch if not provided.)


data BobInput = BobInput {
  name :: Text,
  branch :: Text,
  repoUrl :: Maybe Text,
  repoUpdatePath :: Maybe Turtle.FilePath,
  dockerName :: Maybe Text,
  dockerOwner :: Maybe Text,
  dockerTag :: Maybe Text,
  pushFlag :: Bool
  } deriving (Show, Eq, Ord)

data BobEnv = BobEnv {
  repoUrl :: Maybe Text,
  repoUpdatePath :: Maybe Turtle.FilePath,
  dockerOwner :: Maybe Text,
  dockerFilePath :: Text
  } deriving (Show, Eq, Ord)
