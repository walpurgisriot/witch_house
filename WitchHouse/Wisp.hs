module WitchHouse.Wisp
( eval
, repl
, toplevel
, env
, stl
, bind
, unbind
, getFrame
, pushFrame
, dropFrame
, envLookup
, gc
, gcW
) where

import WitchHouse.Types
import WitchHouse.Wisp.Core
import WitchHouse.Wisp.Parser
import WitchHouse.Wisp.STL

import System.IO
import System.IO.Error

import Control.Exception
import qualified Data.HashTable.IO as H

repl :: IO ()
repl = loop `catch` eof
  where loop = do gc
                  putStr "\n> "
                  hFlush stdout
                  l <- getLine
                  case l of
                    "\\env" -> do bl <- H.toList env
                                  putStrLn (show bl)
                                  loop
                    "" -> loop
                    _ -> do res <- eval l toplevel
                            case res of
                              Left err -> putStr err >> loop
                              Right v -> putStr (show v) >> loop
        eof x = if isEOFError x then putStrLn "" else ioError x

eval :: String -> Int -> IO (Either String Sval)
eval s f = case parseWisp s of
  Right sv -> do v <- p_apply p_eval [sv] f
                 return v
  Left err -> return . Left $ show err

