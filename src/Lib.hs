{-# LANGUAGE FlexibleContexts #-}
module Lib where

import Data.ConfigFile
import Control.Monad.Except         (runExceptT, join, liftIO)
import System.Directory             (getHomeDirectory)
import System.Exit                  (exitFailure)

data Program = Program { name :: String
                       , command :: String
                       }


getPrograms :: IO [Program]
getPrograms = do
        path <- configPath
        programs <- runExceptT $ do
            cp <- join $ liftIO $ readfile emptyCP path
            mapM (makeProgram cp) $ sections cp
        case programs of
            (Left e)   -> print e >> exitFailure
            (Right ps) -> return ps
    where configPath = do homeDir <- getHomeDirectory
                          return $ homeDir ++ "/.hklaunchrc"
          makeProgram cp sect = do sectionCommand <- get cp sect "command"
                                   return $ Program sect sectionCommand
