module Main where

import Brick
import Brick.Widgets.List           ( list, renderList, List, handleListEvent
                                    , listSelectedElement)
import Control.Monad                (void)
import Control.Monad.Except         (liftIO)
import Data.Vector                  (fromList)
import Graphics.Vty.Attributes      (defAttr, green, black)
import Graphics.Vty.Input.Events    (Event, Key(..), Event(..))
import System.Process               (createProcess, shell, CreateProcess(..), StdStream(..))

import Lib

main :: IO ()
main = do programs <- getPrograms
          void . defaultMain ui $ list ProgramList (fromList programs) 1



data UIWidgets = ProgramList
                 deriving (Show, Ord, Eq)


ui :: App (List UIWidgets Program) Event UIWidgets
ui = App renderUI showFirstCursor eventHandler return attributes
    where attributes = const $ attrMap (green `on` black)
                                    [ (attrName "selected", black `on` green)
                                    ]

renderUI :: List UIWidgets Program -> [Widget UIWidgets]
renderUI ps = [renderList renderItem True ps]
    where renderItem selected p =
                if selected then withAttr (attrName "selected") text else text
                where text = padRight Max . str $ name p

eventHandler :: (List UIWidgets Program) -> BrickEvent UIWidgets Event
             -> EventM UIWidgets (Next (List UIWidgets Program))
eventHandler ps (VtyEvent (EvKey KEsc []))        = halt ps
eventHandler ps (VtyEvent (EvKey (KChar 'q') [])) = halt ps
eventHandler _  (VtyEvent (EvKey (KChar 'r') [])) = continue =<< reloadProgramList
eventHandler ps (VtyEvent (EvKey KEnter []))      = continue =<< runSelectedProgram ps
eventHandler ps (VtyEvent e)                      = continue =<< handleListEvent e ps
eventHandler ps e                                 = continue ps

reloadProgramList :: EventM UIWidgets (List UIWidgets Program)
reloadProgramList = do ps <- liftIO getPrograms
                       return $ list ProgramList (fromList ps) 1

runSelectedProgram :: List UIWidgets Program -> EventM UIWidgets (List UIWidgets Program)
runSelectedProgram ps = case mSelected of
        (Just (n, p)) -> (liftIO $ createProcess $ silentShell $ command p) >> return ps
        Nothing       -> return ps
        where mSelected = listSelectedElement ps
              silentShell cmd = let raw = shell cmd
                                 in raw { std_out = NoStream, std_err = NoStream }
