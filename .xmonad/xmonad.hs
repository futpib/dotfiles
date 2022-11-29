
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Util.Run
import XMonad.Util.Themes

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.BoringWindows
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Tabbed
import XMonad.Layout.Simplest

import XMonad.Actions.NoBorders
import XMonad.Actions.Submap

main = do
    xmonad $ ewmh $ def
        { modMask = mod4Mask -- use the Windows button as mod
        , manageHook = manageHook'
        , layoutHook = layoutHook'
--         , handleEventHook = handleEventHook'
        , terminal = "konsole"
        , normalBorderColor = "#5C5B5A"
        , focusedBorderColor = "#275EA0"
        , keys = keys'
        , workspaces = [ "`" ] ++ (map show ([1..9] ++ [0])) ++ [ "-", "=", "⌫", "⇱" ]
        }


manageHook' = composeAll . concat $
    [ [ className   =? c --> doFloat           | c <- myClassFloats]
    , [ title       =? t --> doFloat           | t <- myTitleFloats]
    ,   [ manageDocks
        , isFullscreen --> (doF W.focusDown <+> doFullFloat)
        ]
    ]
  where myClassFloats = []
        myTitleFloats = []

layoutHook' = lessBorders Screen
    $ mkToggle (FULL ?? EOT)
    $ windowNavigation
--     $ subTabbed'
    $ avoidStruts
    $ boringWindows
    $ layoutHook
    $ def
-- layoutHook' = noBorders Full ||| Accordion

-- subTabbed' x = addTabs shrinkText myTheme $ subLayout [] Simplest x

myTheme = (theme xmonadTheme) { decoHeight = 12 }

keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    [ ((modMask,               xK_Return), spawn $ XMonad.terminal conf)
    , ((modMask,               xK_F2    ), spawnRunner)
    , ((modMask,               xK_slash ), spawnSwitcher)
    , ((modMask,               xK_Escape), spawnDunstctl "close")
    , ((modMask .|. controlMask, xK_Escape), spawnDunstctl "close-all")
    , ((modMask .|. shiftMask, xK_Escape), spawnDunstctl "history-pop")
    , ((modMask .|. altMask,   xK_Escape), spawnDunstctl "set-paused toggle")
    , ((modMask,               xK_t     ), spawnTranslateClipboard)
    , ((modMask,               xK_F4    ), kill)

    --layouts
    , ((modMask,               xK_e     ), sendMessage NextLayout)

    -- refresh
    , ((modMask,               xK_r     ), refresh)

    -- toggle border
    , ((modMask,               xK_b     ), withFocused toggleBorder >> refresh)

    -- focus
    , ((modMask,               xK_Tab   ), windows W.focusDown)
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask,               xK_k     ), windows W.focusUp)
    , ((modMask,               xK_m     ), windows W.focusMaster)

    -- swapping
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- increase or decrease number of windows in the master area
    , ((modMask .|. shiftMask, xK_h   ), sendMessage (IncMasterN 1))
    , ((modMask .|. shiftMask, xK_l   ), sendMessage (IncMasterN (-1)))

    -- resizing
    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_l     ), sendMessage Expand)
--     , ((modMask .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
--     , ((modMask .|. shiftMask, xK_l     ), sendMessage MirrorExpand)

    -- groups
    , ((modMask .|. controlMask, xK_h   ), sendMessage $ pullGroup L)
    , ((modMask .|. controlMask, xK_l   ), sendMessage $ pullGroup R)
    , ((modMask .|. controlMask, xK_k   ), sendMessage $ pullGroup U)
    , ((modMask .|. controlMask, xK_j   ), sendMessage $ pullGroup D)

    , ((modMask .|. controlMask, xK_m   ), withFocused (sendMessage . MergeAll))
    , ((modMask .|. controlMask, xK_u   ), withFocused (sendMessage . UnMerge))

    , ((modMask .|. controlMask, xK_period), onGroup W.focusUp')
    , ((modMask .|. controlMask, xK_comma), onGroup W.focusDown')

    , ((modMask,                 xK_s   ), submap $ defaultSublMap conf)

--     , ((modMask,                 xK_j   ), focusDown)
--     , ((modMask,                 xK_k   ), focusUp)

    -- undo float
    , ((modMask,               xK_space ), withFocused $ windows . W.sink)

    -- toggle fullscreen
    , ((modMask,               xK_f     ), sendMessage $ Toggle FULL)

    -- quit, or restart
    , ((modMask              , xK_q     ), restart "xmonad" True)

    ]

    ++

    [ ((m .|. modMask, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf)
        $ workspaceKeys
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]

    -- mod-alt-[`, 1..] %! Switch to physical/Xinerama screens 0, 1..
    ++

    [ ((m .|. modMask .|. altMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip workspaceKeys [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    where
        workspaceKeys = [xK_grave, xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_minus, xK_equal, xK_BackSpace, xK_Home]
        altMask = mod1Mask

spawnRunner = spawn "rofi -show run"
spawnSwitcher = spawn "rofi -show window"

spawnDunstctl :: String -> X ()
spawnDunstctl s = spawn $ "dunstctl " ++ s

spawnTranslateClipboard = spawn "translate-clipboard"
