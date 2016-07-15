module Main where

import Brick
import Brick.Widgets.List           ( list, renderList, List, handleListEvent
                                    , listSelectedElement)
import Control.Monad                (void)
import Control.Monad.Error          (liftIO)
import Data.Vector                  (fromList)
import Graphics.Vty.Attributes      (defAttr, green, black)
import Graphics.Vty.Input.Events    (Event, Key(..), Event(..))
import System.Process               (createProcess, shell, CreateProcess(..), StdStream(..))

import Lib

main :: IO ()
main = do programs <- getPrograms
          void . defaultMain ui $ list "programs" (fromList programs) 1


ui :: App (List String Program) Event [Char]
ui = App draw showFirstCursor events return attributes id
    where draw ps = [renderList renderItem True ps]
          renderItem selected p = if selected
                                      then withAttr (attrName "selected") text
                                      else text
            where text = padRight Max . str $ name p
          events ps e = case e of
            (EvKey KEsc [])         -> halt ps
            (EvKey (KChar 'q') [])  -> halt ps
            (EvKey (KChar 'r') [])  -> continue =<< reloadProgramList
            (EvKey KEnter [])       -> continue =<< runSelectedProgram ps
            otherwise               -> continue =<< handleListEvent e ps
          attributes = const $ attrMap (green `on` black)
                                    [ (attrName "selected", black `on` green)
                                    ]

reloadProgramList :: EventM String (List String Program)
reloadProgramList = do ps <- liftIO getPrograms
                       return $ list "programs" (fromList ps) 1

runSelectedProgram :: List String Program -> EventM String (List String Program)
runSelectedProgram ps = case mSelected of
        (Just (n, p)) -> (liftIO $ createProcess $ silentShell $ command p) >> return ps
        Nothing       -> return ps
        where mSelected = listSelectedElement ps
              silentShell cmd = let raw = shell cmd
                                 in raw { std_out = NoStream, std_err = NoStream }
