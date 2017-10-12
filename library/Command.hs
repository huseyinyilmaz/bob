module Command (main) where

import Turtle
import Env

import Control.Monad.Reader(ReaderT)
import Control.Monad.Reader(runReaderT)
import Data.Maybe(fromMaybe)

main = readData
