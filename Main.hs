module Main where

import System.Environment (getArgs)
import WitchHouse.Invocation (handleArgs)
import WitchHouse.Server
import WitchHouse.Wisp
import Data.Monoid (mempty)

-- | Startup goes like this:
-- 1. Parse command line arguments.
-- 2. Hand over control to the server, which...
-- 3. Forks off a process to listen for incoming connections. This process will
-- spawn additional processes as necessary to handle clients.
main :: IO ()
main = do
  load toplevel (mempty, stl)
  getArgs >>= handleArgs >>= startServer

