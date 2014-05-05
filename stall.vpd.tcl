# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Fri Apr 19 03:18:14 2013
# Designs open: 1
#   Sim: dve_simv
# Toplevel windows open: 7
# 	TopLevel.1
# 	TopLevel.2
# 	TopLevel.3
# 	TopLevel.6
# 	TopLevel.7
# 	TopLevel.8
# 	TopLevel.9
#   Source.1: RAS
#   Wave.1: 37 signals
#   Wave.2: 9 signals
#   Wave.5: 14 signals
#   Wave.6: 1 signals
#   Wave.7: 128 signals
#   Wave.8: 62 signals
#   Group count = 20
#   Group Group1 signal count = 75
#   Group Group2 signal count = 181
#   Group Group3 signal count = 4
#   Group Group4 signal count = 12
#   Group Group5 signal count = 18
#   Group Group6 signal count = 7
#   Group Group7 signal count = 2
#   Group Group8 signal count = 7
#   Group Group9 signal count = 75
#   Group Group10 signal count = 5
#   Group Group11 signal count = 0
#   Group Group12 signal count = 19
#   Group Group13 signal count = 16
#   Group Group14 signal count = 32
#   Group Group15 signal count = 4
#   Group Group16 signal count = 6
#   Group Group17 signal count = 8
#   Group Group18 signal count = 1
#   Group Group19 signal count = 128
#   Group Group20 signal count = 62
# End_DVE_Session_Save_Info

# DVE version: E-2011.03_Full64
# DVE build date: Feb 23 2011 21:10:05


#<Session mode="Full" path="/afs/umich.edu/user/c/h/chengfu/Desktop/chech/stall.vpd.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set -value 10000

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDensity
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Grading
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE Topleve session: 


# Create and position top-level windows :TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state normal -rect {{20 144} {1789 1171}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 229]
set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier]
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 229
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value -1
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 228} {height 756} {dock_state left} {dock_on_new_line true} {child_hier_colhier 267} {child_hier_coltype 107} {child_hier_col1 0} {child_hier_col2 1}}
set DLPane.1 [gui_create_window -type DLPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 295]
set Data.1 [gui_share_window -id ${DLPane.1} -type Data]
gui_set_window_pref_key -window ${DLPane.1} -key dock_width -value_type integer -value 295
gui_set_window_pref_key -window ${DLPane.1} -key dock_height -value_type integer -value 802
gui_set_window_pref_key -window ${DLPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DLPane.1} {{left 0} {top 0} {width 294} {height 756} {dock_state left} {dock_on_new_line true} {child_data_colvariable 197} {child_data_colvalue 100} {child_data_coltype 40} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 173]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value -1
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 173
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 271} {height 172} {dock_state bottom} {dock_on_new_line true}}
set DriverLoad.1 [gui_create_window -type DriverLoad -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line false -dock_extent 173]
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_width -value_type integer -value 150
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_height -value_type integer -value 173
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DriverLoad.1} {{left 0} {top 0} {width 1497} {height 172} {dock_state bottom} {dock_on_new_line false}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings


# Create and position top-level windows :TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state normal -rect {{72 76} {1633 1175}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.2}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 235} {child_wave_right 1321} {child_wave_colname 169} {child_wave_colvalue 62} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level windows :TopLevel.3

if {![gui_exist_window -window TopLevel.3]} {
    set TopLevel.3 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.3 TopLevel.3
}
gui_show_window -window ${TopLevel.3} -show_state normal -rect {{87 222} {1647 1320}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.3} -option true

# MDI window settings
set Wave.2 [gui_create_window -type {Wave}  -parent ${TopLevel.3}]
gui_show_window -window ${Wave.2} -show_state maximized
gui_update_layout -id ${Wave.2} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 454} {child_wave_right 1101} {child_wave_colname 225} {child_wave_colvalue 225} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level windows :TopLevel.6

if {![gui_exist_window -window TopLevel.6]} {
    set TopLevel.6 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.6 TopLevel.6
}
gui_show_window -window ${TopLevel.6} -show_state normal -rect {{118 99} {1676 1195}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.6} -option true

# MDI window settings
set Wave.5 [gui_create_window -type {Wave}  -parent ${TopLevel.6}]
gui_show_window -window ${Wave.5} -show_state maximized
gui_update_layout -id ${Wave.5} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 452} {child_wave_right 1101} {child_wave_colname 224} {child_wave_colvalue 224} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level windows :TopLevel.7

if {![gui_exist_window -window TopLevel.7]} {
    set TopLevel.7 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.7 TopLevel.7
}
gui_show_window -window ${TopLevel.7} -show_state normal -rect {{109 76} {1665 1170}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.7} -option true

# MDI window settings
set Wave.6 [gui_create_window -type {Wave}  -parent ${TopLevel.7}]
gui_show_window -window ${Wave.6} -show_state maximized
gui_update_layout -id ${Wave.6} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 451} {child_wave_right 1100} {child_wave_colname 223} {child_wave_colvalue 224} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level windows :TopLevel.8

if {![gui_exist_window -window TopLevel.8]} {
    set TopLevel.8 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.8 TopLevel.8
}
gui_show_window -window ${TopLevel.8} -show_state normal -rect {{58 51} {1917 1170}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.8} -option true

# MDI window settings
set Wave.7 [gui_create_window -type {Wave}  -parent ${TopLevel.8}]
gui_show_window -window ${Wave.7} -show_state maximized
gui_update_layout -id ${Wave.7} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 539} {child_wave_right 1315} {child_wave_colname 267} {child_wave_colvalue 268} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level windows :TopLevel.9

if {![gui_exist_window -window TopLevel.9]} {
    set TopLevel.9 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.9 TopLevel.9
}
gui_show_window -window ${TopLevel.9} -show_state normal -rect {{58 51} {1917 1170}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.9} -option true

# MDI window settings
set Wave.8 [gui_create_window -type {Wave}  -parent ${TopLevel.9}]
gui_show_window -window ${Wave.8} -show_state maximized
gui_update_layout -id ${Wave.8} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 539} {child_wave_right 1315} {child_wave_colname 267} {child_wave_colvalue 268} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}
gui_update_statusbar_target_frame ${TopLevel.2}
gui_update_statusbar_target_frame ${TopLevel.3}
gui_update_statusbar_target_frame ${TopLevel.6}
gui_update_statusbar_target_frame ${TopLevel.7}
gui_update_statusbar_target_frame ${TopLevel.8}
gui_update_statusbar_target_frame ${TopLevel.9}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { [llength [lindex [gui_get_db -design Sim] 0]] == 0 } {
gui_set_env SIMSETUP::SIMARGS {{-ucligui +vcs+loopreport +v2k +vc +memcbk}}
gui_set_env SIMSETUP::SIMEXE {dve_simv}
gui_set_env SIMSETUP::ALLOW_POLL {0}
if { ![gui_is_db_opened -db {dve_simv}] } {
gui_sim_run Ucli -exe dve_simv -args {-ucligui +vcs+loopreport +v2k +vc +memcbk} -dir ../chech -nosource
}
}
if { ![gui_sim_state -check active] } {error "Simulator did not start correctly" error}
gui_set_precision 100ps
gui_set_time_units 100ps
#</Database>

# DVE Global setting session: 


# Global: Breakpoints

# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {testbench.pipeline_0.icache_0}
gui_load_child_values {testbench.pipeline_0.Execute}
gui_load_child_values {testbench.pipeline_0.Dispatch.maptable}

set Group1 Group1
gui_sg_create ${Group1}
gui_sg_addsignal -group ${Group1} { testbench.pipeline_0.LSQ.Dcash_load_valid testbench.pipeline_0.LSQ.Dcash_load_valid_data testbench.pipeline_0.LSQ.Dcash_response testbench.pipeline_0.LSQ.Dcash_store_valid testbench.pipeline_0.LSQ.Dcash_tag testbench.pipeline_0.LSQ.Dcash_tag_data testbench.pipeline_0.LSQ.Ex_load_port1_address testbench.pipeline_0.LSQ.Ex_load_port1_address_en testbench.pipeline_0.LSQ.Ex_load_port1_address_insert_position testbench.pipeline_0.LSQ.Ex_load_port2_address testbench.pipeline_0.LSQ.Ex_load_port2_address_en testbench.pipeline_0.LSQ.Ex_load_port2_address_insert_position testbench.pipeline_0.LSQ.Ex_store_port1_address testbench.pipeline_0.LSQ.Ex_store_port1_address_en testbench.pipeline_0.LSQ.Ex_store_port1_address_insert_position testbench.pipeline_0.LSQ.Ex_store_port2_address testbench.pipeline_0.LSQ.Ex_store_port2_address_en testbench.pipeline_0.LSQ.Ex_store_port2_address_insert_position testbench.pipeline_0.LSQ.LSQ_Dcash_load_address testbench.pipeline_0.LSQ.LSQ_Dcash_load_address_en testbench.pipeline_0.LSQ.LSQ_Dcash_store_address testbench.pipeline_0.LSQ.LSQ_Dcash_store_address_en testbench.pipeline_0.LSQ.LSQ_Dcash_store_data testbench.pipeline_0.LSQ.LSQ_NPC_stack testbench.pipeline_0.LSQ.LSQ_PreDe_tail_position testbench.pipeline_0.LSQ.LSQ_PreDe_tail_position_plus_one testbench.pipeline_0.LSQ.LSQ_Rob_NPC testbench.pipeline_0.LSQ.LSQ_Rob_data testbench.pipeline_0.LSQ.LSQ_Rob_destination testbench.pipeline_0.LSQ.LSQ_Rob_write_dest_n_data_en testbench.pipeline_0.LSQ.LSQ_address_stack testbench.pipeline_0.LSQ.LSQ_data_stack testbench.pipeline_0.LSQ.LSQ_destination_stack testbench.pipeline_0.LSQ.LSQ_ld_or_st_stack testbench.pipeline_0.LSQ.LSQ_ready_bit_stack testbench.pipeline_0.LSQ.LSQ_response_stack testbench.pipeline_0.LSQ.LSQ_retire_enable testbench.pipeline_0.LSQ.LSQ_store_retire_accumulator testbench.pipeline_0.LSQ.LSQ_store_retire_accumulator_minus_one testbench.pipeline_0.LSQ.LSQ_store_retire_accumulator_plus_one testbench.pipeline_0.LSQ.LSQ_store_retire_accumulator_plus_two testbench.pipeline_0.LSQ.LSQ_str_hazard testbench.pipeline_0.LSQ.PreDe_load_port1_NPC testbench.pipeline_0.LSQ.PreDe_load_port1_allocate_en testbench.pipeline_0.LSQ.PreDe_load_port1_destination testbench.pipeline_0.LSQ.PreDe_load_port2_NPC testbench.pipeline_0.LSQ.PreDe_load_port2_allocate_en testbench.pipeline_0.LSQ.PreDe_load_port2_destination testbench.pipeline_0.LSQ.PreDe_store_port1_NPC testbench.pipeline_0.LSQ.PreDe_store_port1_allocate_en testbench.pipeline_0.LSQ.PreDe_store_port1_data testbench.pipeline_0.LSQ.PreDe_store_port2_NPC testbench.pipeline_0.LSQ.PreDe_store_port2_allocate_en testbench.pipeline_0.LSQ.PreDe_store_port2_data testbench.pipeline_0.LSQ.Rob_store_port1_retire_en testbench.pipeline_0.LSQ.Rob_store_port2_retire_en testbench.pipeline_0.LSQ.br_marker_num_stack testbench.pipeline_0.LSQ.br_marker_port1_en testbench.pipeline_0.LSQ.br_marker_port1_num testbench.pipeline_0.LSQ.br_marker_port2_en testbench.pipeline_0.LSQ.br_marker_port2_num testbench.pipeline_0.LSQ.br_marker_tail_stack testbench.pipeline_0.LSQ.clock testbench.pipeline_0.LSQ.head_plus_one testbench.pipeline_0.LSQ.head_ptr testbench.pipeline_0.LSQ.recovery_br_marker_num testbench.pipeline_0.LSQ.recovery_en testbench.pipeline_0.LSQ.reset testbench.pipeline_0.LSQ.stall testbench.pipeline_0.LSQ.tail_plus_one testbench.pipeline_0.LSQ.tail_plus_three testbench.pipeline_0.LSQ.tail_plus_two testbench.pipeline_0.LSQ.tail_ptr testbench.pipeline_0.LSQ.write_in_1 testbench.pipeline_0.LSQ.write_in_case_2 }
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_NPC_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_address_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_data_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_destination_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_ld_or_st_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_ready_bit_stack}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.LSQ.PreDe_store_port1_data}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.PreDe_store_port1_data}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.LSQ.PreDe_store_port2_data}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.PreDe_store_port2_data}
set Group2 Group2
gui_sg_create ${Group2}
gui_sg_addsignal -group ${Group2} { testbench.pipeline_0.Dispatch.C_cdb_data_1 testbench.pipeline_0.Dispatch.C_cdb_data_2 testbench.pipeline_0.Dispatch.C_cdb_en_1 testbench.pipeline_0.Dispatch.C_cdb_en_2 testbench.pipeline_0.Dispatch.C_cdb_idx_1 testbench.pipeline_0.Dispatch.C_cdb_idx_2 testbench.pipeline_0.Dispatch.D_IR_1 testbench.pipeline_0.Dispatch.D_IR_2 testbench.pipeline_0.Dispatch.D_NPC_1 testbench.pipeline_0.Dispatch.D_NPC_2 testbench.pipeline_0.Dispatch.D_alu_func_out_1 testbench.pipeline_0.Dispatch.D_alu_func_out_2 testbench.pipeline_0.Dispatch.D_cond_branch_out_1 testbench.pipeline_0.Dispatch.D_cond_branch_out_2 testbench.pipeline_0.Dispatch.D_dest_reg_idx_out_1 testbench.pipeline_0.Dispatch.D_dest_reg_idx_out_2 testbench.pipeline_0.Dispatch.D_opa_reg_idx_out_1 testbench.pipeline_0.Dispatch.D_opa_reg_idx_out_2 testbench.pipeline_0.Dispatch.D_opa_select_out_1 testbench.pipeline_0.Dispatch.D_opa_select_out_2 testbench.pipeline_0.Dispatch.D_opb_reg_idx_out_1 testbench.pipeline_0.Dispatch.D_opb_reg_idx_out_2 testbench.pipeline_0.Dispatch.D_opb_select_out_1 testbench.pipeline_0.Dispatch.D_opb_select_out_2 testbench.pipeline_0.Dispatch.D_rd_mem_out_1 testbench.pipeline_0.Dispatch.D_rd_mem_out_2 testbench.pipeline_0.Dispatch.D_rs_inst_status testbench.pipeline_0.Dispatch.D_rs_inst_status_1 testbench.pipeline_0.Dispatch.D_rs_inst_status_2 testbench.pipeline_0.Dispatch.D_rs_rd_bmask_1 testbench.pipeline_0.Dispatch.D_rs_rd_bmask_2 testbench.pipeline_0.Dispatch.D_rs_rd_br_marker_1 testbench.pipeline_0.Dispatch.D_rs_rd_br_marker_2 testbench.pipeline_0.Dispatch.D_rs_rd_brpTN_1 testbench.pipeline_0.Dispatch.D_rs_rd_brpTN_2 testbench.pipeline_0.Dispatch.D_rs_rd_brp_TAR_PC_1 testbench.pipeline_0.Dispatch.D_rs_rd_brp_TAR_PC_2 testbench.pipeline_0.Dispatch.D_rs_rd_lsq_tail_1 testbench.pipeline_0.Dispatch.D_rs_rd_lsq_tail_2 testbench.pipeline_0.Dispatch.D_stall testbench.pipeline_0.Dispatch.D_uncond_branch_out_1 testbench.pipeline_0.Dispatch.D_uncond_branch_out_2 testbench.pipeline_0.Dispatch.D_wr_mem_out_1 testbench.pipeline_0.Dispatch.D_wr_mem_out_2 testbench.pipeline_0.Dispatch.Dispatch_NPC_1 testbench.pipeline_0.Dispatch.Dispatch_NPC_2 testbench.pipeline_0.Dispatch.Dispatch_T_1 testbench.pipeline_0.Dispatch.Dispatch_T_2 testbench.pipeline_0.Dispatch.Dispatch_T_en_1 testbench.pipeline_0.Dispatch.Dispatch_T_en_2 testbench.pipeline_0.Dispatch.Dispatch_Told_1 testbench.pipeline_0.Dispatch.Dispatch_Told_2 testbench.pipeline_0.Dispatch.Dispatch_rega_1 testbench.pipeline_0.Dispatch.Dispatch_rega_2 testbench.pipeline_0.Dispatch.Dispatch_rega_plus_1 testbench.pipeline_0.Dispatch.Dispatch_rega_plus_2 testbench.pipeline_0.Dispatch.Dispatch_regb_1 testbench.pipeline_0.Dispatch.Dispatch_regb_2 testbench.pipeline_0.Dispatch.Dispatch_regb_plus_1 testbench.pipeline_0.Dispatch.Dispatch_regb_plus_2 testbench.pipeline_0.Dispatch.Dispatch_valid_inst_1 testbench.pipeline_0.Dispatch.Dispatch_valid_inst_2 testbench.pipeline_0.Dispatch.F_rs_wr_data_brpTN_1 testbench.pipeline_0.Dispatch.F_rs_wr_data_brpTN_2 testbench.pipeline_0.Dispatch.F_rs_wr_data_brp_TAR_PC_1 testbench.pipeline_0.Dispatch.F_rs_wr_data_brp_TAR_PC_2 testbench.pipeline_0.Dispatch.I_rs_rd_inst_1 testbench.pipeline_0.Dispatch.I_rs_rd_inst_2 testbench.pipeline_0.Dispatch.LSQ_rs_wr_data_lsq_tail_1 testbench.pipeline_0.Dispatch.LSQ_rs_wr_data_lsq_tail_2 testbench.pipeline_0.Dispatch.LSQ_rs_wr_data_lsq_tail_in_1 testbench.pipeline_0.Dispatch.LSQ_rs_wr_data_lsq_tail_in_2 testbench.pipeline_0.Dispatch.Retire_NPC_out_1 testbench.pipeline_0.Dispatch.Retire_NPC_out_2 testbench.pipeline_0.Dispatch.Retire_wr_data_1 testbench.pipeline_0.Dispatch.Retire_wr_data_2 testbench.pipeline_0.Dispatch.Retire_wr_en_1 testbench.pipeline_0.Dispatch.Retire_wr_en_2 testbench.pipeline_0.Dispatch.Retire_wr_idx_1 testbench.pipeline_0.Dispatch.Retire_wr_idx_2 testbench.pipeline_0.Dispatch.X_br_marker_1 testbench.pipeline_0.Dispatch.X_br_marker_2 testbench.pipeline_0.Dispatch.X_br_mispre_marker testbench.pipeline_0.Dispatch.X_br_mispredict testbench.pipeline_0.Dispatch.X_br_wr_en_1 }
gui_sg_addsignal -group ${Group2} { testbench.pipeline_0.Dispatch.X_br_wr_en_2 testbench.pipeline_0.Dispatch.X_rs_bmask_clear_location_1 testbench.pipeline_0.Dispatch.X_rs_bmask_clear_location_2 testbench.pipeline_0.Dispatch.X_rs_clear_bmask_bits_1 testbench.pipeline_0.Dispatch.X_rs_clear_bmask_bits_2 testbench.pipeline_0.Dispatch.X_rs_clear_en_1 testbench.pipeline_0.Dispatch.X_rs_clear_en_2 testbench.pipeline_0.Dispatch.X_rs_clear_inst_1 testbench.pipeline_0.Dispatch.X_rs_clear_inst_2 testbench.pipeline_0.Dispatch.arch_wr_idx_1 testbench.pipeline_0.Dispatch.arch_wr_idx_2 testbench.pipeline_0.Dispatch.clock testbench.pipeline_0.Dispatch.dispatch_en_1 testbench.pipeline_0.Dispatch.dispatch_en_2 testbench.pipeline_0.Dispatch.fl_R_en_1 testbench.pipeline_0.Dispatch.fl_R_en_2 testbench.pipeline_0.Dispatch.fl_T_1 testbench.pipeline_0.Dispatch.fl_T_1_out testbench.pipeline_0.Dispatch.fl_T_2 testbench.pipeline_0.Dispatch.fl_T_2_out testbench.pipeline_0.Dispatch.fl_stall testbench.pipeline_0.Dispatch.id_alu_func_out_1 testbench.pipeline_0.Dispatch.id_alu_func_out_2 testbench.pipeline_0.Dispatch.id_br_en_1 testbench.pipeline_0.Dispatch.id_br_en_2 testbench.pipeline_0.Dispatch.id_cond_branch_out_1 testbench.pipeline_0.Dispatch.id_cond_branch_out_2 testbench.pipeline_0.Dispatch.id_dest_reg_idx_out_1 testbench.pipeline_0.Dispatch.id_dest_reg_idx_out_2 testbench.pipeline_0.Dispatch.id_halt_out_1 testbench.pipeline_0.Dispatch.id_halt_out_2 testbench.pipeline_0.Dispatch.id_illegal_out_1 testbench.pipeline_0.Dispatch.id_illegal_out_2 testbench.pipeline_0.Dispatch.id_opa_select_out_1 testbench.pipeline_0.Dispatch.id_opa_select_out_2 testbench.pipeline_0.Dispatch.id_opb_select_out_1 testbench.pipeline_0.Dispatch.id_opb_select_out_2 testbench.pipeline_0.Dispatch.id_ra_reg_idx_out_1 testbench.pipeline_0.Dispatch.id_ra_reg_idx_out_2 testbench.pipeline_0.Dispatch.id_rb_reg_idx_out_1 testbench.pipeline_0.Dispatch.id_rb_reg_idx_out_2 testbench.pipeline_0.Dispatch.id_rd_mem_out_1 testbench.pipeline_0.Dispatch.id_rd_mem_out_2 testbench.pipeline_0.Dispatch.id_uncond_branch_out_1 testbench.pipeline_0.Dispatch.id_uncond_branch_out_2 testbench.pipeline_0.Dispatch.id_valid_inst_out_1 testbench.pipeline_0.Dispatch.id_valid_inst_out_2 testbench.pipeline_0.Dispatch.id_wb_en_1 testbench.pipeline_0.Dispatch.id_wb_en_2 testbench.pipeline_0.Dispatch.id_wr_mem_out_1 testbench.pipeline_0.Dispatch.id_wr_mem_out_2 testbench.pipeline_0.Dispatch.if_D_bmask_1 testbench.pipeline_0.Dispatch.if_D_bmask_2 testbench.pipeline_0.Dispatch.if_D_br_marker_1 testbench.pipeline_0.Dispatch.if_D_br_marker_2 testbench.pipeline_0.Dispatch.if_id_IR_1 testbench.pipeline_0.Dispatch.if_id_IR_2 testbench.pipeline_0.Dispatch.if_id_NPC_1 testbench.pipeline_0.Dispatch.if_id_NPC_2 testbench.pipeline_0.Dispatch.if_id_valid_inst_1 testbench.pipeline_0.Dispatch.if_id_valid_inst_2 testbench.pipeline_0.Dispatch.lsq_NPC_out_1 testbench.pipeline_0.Dispatch.lsq_NPC_out_2 testbench.pipeline_0.Dispatch.lsq_br_inst_out_1 testbench.pipeline_0.Dispatch.lsq_br_inst_out_2 testbench.pipeline_0.Dispatch.lsq_rd_dest_idx_out_1 testbench.pipeline_0.Dispatch.lsq_rd_dest_idx_out_2 testbench.pipeline_0.Dispatch.lsq_rd_en_out_1 testbench.pipeline_0.Dispatch.lsq_rd_en_out_2 testbench.pipeline_0.Dispatch.lsq_wr_en_out_1 testbench.pipeline_0.Dispatch.lsq_wr_en_out_2 testbench.pipeline_0.Dispatch.mt_dest_reg_old_1 testbench.pipeline_0.Dispatch.mt_dest_reg_old_2 testbench.pipeline_0.Dispatch.ra_reg_idx_out_1 testbench.pipeline_0.Dispatch.ra_reg_idx_out_2 testbench.pipeline_0.Dispatch.ra_reg_ready_out_1 testbench.pipeline_0.Dispatch.ra_reg_ready_out_2 testbench.pipeline_0.Dispatch.rb_reg_idx_out_1 testbench.pipeline_0.Dispatch.rb_reg_idx_out_2 testbench.pipeline_0.Dispatch.rb_reg_ready_out_1 testbench.pipeline_0.Dispatch.rb_reg_ready_out_2 testbench.pipeline_0.Dispatch.reset testbench.pipeline_0.Dispatch.retire_NPC_out_1 testbench.pipeline_0.Dispatch.retire_NPC_out_2 testbench.pipeline_0.Dispatch.retire_store testbench.pipeline_0.Dispatch.retire_wb_data_out_1 testbench.pipeline_0.Dispatch.retire_wb_data_out_2 }
gui_sg_addsignal -group ${Group2} { testbench.pipeline_0.Dispatch.rob_T_out_1 testbench.pipeline_0.Dispatch.rob_T_out_2 testbench.pipeline_0.Dispatch.rob_T_valid_1 testbench.pipeline_0.Dispatch.rob_T_valid_2 testbench.pipeline_0.Dispatch.rob_Told_out_1 testbench.pipeline_0.Dispatch.rob_Told_out_2 testbench.pipeline_0.Dispatch.rob_stall testbench.pipeline_0.Dispatch.rs_stall testbench.pipeline_0.Dispatch.system_halt }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.D_NPC_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.D_NPC_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.D_NPC_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.D_NPC_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.fl_stall}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.fl_stall}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.if_id_NPC_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.if_id_NPC_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.if_id_NPC_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.if_id_NPC_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.rob_stall}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.rob_stall}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.rs_stall}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.rs_stall}
set Group3 Group3
gui_sg_create ${Group3}
gui_sg_addsignal -group ${Group3} { testbench.pipeline_0.D_stall testbench.pipeline_0.F_stall_in testbench.pipeline_0.bmask_stall testbench.pipeline_0.LSQ_stall }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.bmask_stall}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.bmask_stall}
set Group4 Group4
gui_sg_create ${Group4}
gui_sg_addsignal -group ${Group4} { testbench.pipeline_0.X_br_inst_NPC testbench.pipeline_0.Fetch.ex_mem_target_pc testbench.pipeline_0.Fetch.ex_mem_take_branch testbench.pipeline_0.X_br_mispredict_bmask testbench.pipeline_0.bmask1 testbench.pipeline_0.current_bmask testbench.pipeline_0.Dispatch.if_id_NPC_1 testbench.pipeline_0.Dispatch.if_id_NPC_2 testbench.pipeline_0.Dispatch.if_id_valid_inst_1 testbench.pipeline_0.Dispatch.if_id_valid_inst_2 testbench.pipeline_0.Dispatch.clock testbench.pipeline_0.Dispatch.reset }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.X_br_inst_NPC}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.X_br_inst_NPC}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.ex_mem_target_pc}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.ex_mem_target_pc}
gui_set_radix -radix {binary} -signals {Sim:testbench.pipeline_0.X_br_mispredict_bmask}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.X_br_mispredict_bmask}
gui_set_radix -radix {binary} -signals {Sim:testbench.pipeline_0.bmask1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.bmask1}
gui_set_radix -radix {binary} -signals {Sim:testbench.pipeline_0.current_bmask}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.current_bmask}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.if_id_NPC_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.if_id_NPC_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.if_id_NPC_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.if_id_NPC_2}
set Group5 Group5
gui_sg_create ${Group5}
gui_sg_addsignal -group ${Group5} { testbench.pipeline_0.Fetch.PC_enable testbench.pipeline_0.Fetch.PC_plus_8 testbench.pipeline_0.Fetch.PC_reg testbench.pipeline_0.Fetch.clock testbench.pipeline_0.Fetch.ctr2proc_rd_data testbench.pipeline_0.Fetch.ctr2proc_rd_valid testbench.pipeline_0.Fetch.ex_mem_take_branch testbench.pipeline_0.Fetch.ex_mem_target_pc testbench.pipeline_0.Fetch.id_str_hazard testbench.pipeline_0.Fetch.inst_out_a testbench.pipeline_0.Fetch.inst_out_a_PC testbench.pipeline_0.Fetch.inst_out_a_en testbench.pipeline_0.Fetch.inst_out_b testbench.pipeline_0.Fetch.inst_out_b_PC testbench.pipeline_0.Fetch.inst_out_b_en testbench.pipeline_0.Fetch.next_PC testbench.pipeline_0.Fetch.proc2ctr_rd_addr testbench.pipeline_0.Fetch.reset }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.PC_plus_8}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.PC_plus_8}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.PC_reg}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.PC_reg}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.ctr2proc_rd_data}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.ctr2proc_rd_data}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.ex_mem_target_pc}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.ex_mem_target_pc}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.id_str_hazard}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.id_str_hazard}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_a}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_a}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_a_PC}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_a_PC}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_b}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_b}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_b_PC}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_b_PC}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.next_PC}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.next_PC}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.proc2ctr_rd_addr}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.proc2ctr_rd_addr}
set Group6 Group6
gui_sg_create ${Group6}
gui_sg_addsignal -group ${Group6} { testbench.pipeline_0.Dispatch.rob.C testbench.pipeline_0.Dispatch.rob.NPC testbench.pipeline_0.Dispatch.rob.T testbench.pipeline_0.Dispatch.rob.Told testbench.pipeline_0.Dispatch.rob.wb_data testbench.pipeline_0.Dispatch.rob.wr_mem testbench.pipeline_0.Dispatch.rob.br }
set Group7 Group7
gui_sg_create ${Group7}
gui_sg_addsignal -group ${Group7} { testbench.pipeline_0.Dispatch.rob.h testbench.pipeline_0.Dispatch.rob.t }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.rob.h}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.rob.h}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.rob.t}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.rob.t}
set Group8 Group8
gui_sg_create ${Group8}
gui_sg_addsignal -group ${Group8} { testbench.pipeline_0.X_dest_reg_idx_in_alu3 testbench.pipeline_0.X_valid_inst_in_alu3 testbench.pipeline_0.X_bmask_in_alu3 testbench.pipeline_0.X_alu_result_in_alu3 testbench.pipeline_0.LSQ_Rob_data testbench.pipeline_0.LSQ_Rob_write_dest_n_data_en testbench.pipeline_0.LSQ_Rob_destination }
set Group9 Group9
gui_sg_create ${Group9}
gui_sg_addsignal -group ${Group9} { testbench.pipeline_0.LSQ.Dcash_load_valid testbench.pipeline_0.LSQ.Dcash_load_valid_data testbench.pipeline_0.LSQ.Dcash_response testbench.pipeline_0.LSQ.Dcash_store_valid testbench.pipeline_0.LSQ.Dcash_tag testbench.pipeline_0.LSQ.Dcash_tag_data testbench.pipeline_0.LSQ.Ex_load_port1_address testbench.pipeline_0.LSQ.Ex_load_port1_address_en testbench.pipeline_0.LSQ.Ex_load_port1_address_insert_position testbench.pipeline_0.LSQ.Ex_load_port2_address testbench.pipeline_0.LSQ.Ex_load_port2_address_en testbench.pipeline_0.LSQ.Ex_load_port2_address_insert_position testbench.pipeline_0.LSQ.Ex_store_port1_address testbench.pipeline_0.LSQ.Ex_store_port1_address_en testbench.pipeline_0.LSQ.PreDe_store_port1_data testbench.pipeline_0.LSQ.Ex_store_port1_address_insert_position testbench.pipeline_0.LSQ.Ex_store_port2_address testbench.pipeline_0.LSQ.Ex_store_port2_address_en testbench.pipeline_0.LSQ.PreDe_store_port2_data testbench.pipeline_0.LSQ.Ex_store_port2_address_insert_position testbench.pipeline_0.LSQ.LSQ_Dcash_load_address testbench.pipeline_0.LSQ.LSQ_Dcash_load_address_en testbench.pipeline_0.LSQ.LSQ_Dcash_store_address testbench.pipeline_0.LSQ.LSQ_Dcash_store_address_en testbench.pipeline_0.LSQ.LSQ_Dcash_store_data testbench.pipeline_0.LSQ.LSQ_NPC_stack testbench.pipeline_0.LSQ.LSQ_PreDe_tail_position testbench.pipeline_0.LSQ.LSQ_PreDe_tail_position_plus_one testbench.pipeline_0.LSQ.LSQ_Rob_NPC testbench.pipeline_0.LSQ.LSQ_Rob_data testbench.pipeline_0.LSQ.LSQ_Rob_destination testbench.pipeline_0.LSQ.LSQ_Rob_write_dest_n_data_en testbench.pipeline_0.LSQ.LSQ_address_stack testbench.pipeline_0.LSQ.LSQ_data_stack testbench.pipeline_0.LSQ.LSQ_destination_stack testbench.pipeline_0.LSQ.LSQ_ld_or_st_stack testbench.pipeline_0.LSQ.LSQ_ready_bit_stack testbench.pipeline_0.LSQ.LSQ_response_stack testbench.pipeline_0.LSQ.LSQ_retire_enable testbench.pipeline_0.LSQ.LSQ_store_retire_accumulator testbench.pipeline_0.LSQ.LSQ_store_retire_accumulator_minus_one testbench.pipeline_0.LSQ.LSQ_store_retire_accumulator_plus_one testbench.pipeline_0.LSQ.LSQ_store_retire_accumulator_plus_two testbench.pipeline_0.LSQ.LSQ_str_hazard testbench.pipeline_0.LSQ.PreDe_load_port1_NPC testbench.pipeline_0.LSQ.PreDe_load_port1_allocate_en testbench.pipeline_0.LSQ.PreDe_load_port1_destination testbench.pipeline_0.LSQ.PreDe_load_port2_NPC testbench.pipeline_0.LSQ.PreDe_load_port2_allocate_en testbench.pipeline_0.LSQ.PreDe_load_port2_destination testbench.pipeline_0.LSQ.PreDe_store_port1_NPC testbench.pipeline_0.LSQ.PreDe_store_port1_allocate_en testbench.pipeline_0.LSQ.PreDe_store_port2_NPC testbench.pipeline_0.LSQ.PreDe_store_port2_allocate_en testbench.pipeline_0.LSQ.Rob_store_port1_retire_en testbench.pipeline_0.LSQ.Rob_store_port2_retire_en testbench.pipeline_0.LSQ.br_marker_num_stack testbench.pipeline_0.LSQ.br_marker_port1_en testbench.pipeline_0.LSQ.br_marker_port1_num testbench.pipeline_0.LSQ.br_marker_port2_en testbench.pipeline_0.LSQ.br_marker_port2_num testbench.pipeline_0.LSQ.br_marker_tail_stack testbench.pipeline_0.LSQ.clock testbench.pipeline_0.LSQ.head_plus_one testbench.pipeline_0.LSQ.head_ptr testbench.pipeline_0.LSQ.recovery_br_marker_num testbench.pipeline_0.LSQ.recovery_en testbench.pipeline_0.LSQ.reset testbench.pipeline_0.LSQ.stall testbench.pipeline_0.LSQ.tail_plus_one testbench.pipeline_0.LSQ.tail_plus_three testbench.pipeline_0.LSQ.tail_plus_two testbench.pipeline_0.LSQ.tail_ptr testbench.pipeline_0.LSQ.write_in_1 testbench.pipeline_0.LSQ.write_in_case_2 }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.LSQ.PreDe_store_port1_data}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.PreDe_store_port1_data}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.LSQ.PreDe_store_port2_data}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.PreDe_store_port2_data}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_NPC_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_address_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_data_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_destination_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_ld_or_st_stack}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.LSQ.LSQ_ready_bit_stack}
set Group10 Group10
gui_sg_create ${Group10}
gui_sg_addsignal -group ${Group10} { testbench.pipeline_0.bmask_stall testbench.pipeline_0.LSQ_stall testbench.pipeline_0.Dispatch.rs_stall testbench.pipeline_0.Dispatch.rob_stall testbench.pipeline_0.Dispatch.fl_stall }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.bmask_stall}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.bmask_stall}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.rs_stall}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.rs_stall}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.rob_stall}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.rob_stall}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.fl_stall}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.fl_stall}
set Group11 Group11
gui_sg_create ${Group11}
set Group12 Group12
gui_sg_create ${Group12}
gui_sg_addsignal -group ${Group12} { testbench.pipeline_0.Fetch.PC_enable testbench.pipeline_0.Fetch.PC_plus_4 testbench.pipeline_0.Fetch.PC_plus_8 testbench.pipeline_0.Fetch.PC_reg testbench.pipeline_0.Fetch.clock testbench.pipeline_0.Fetch.ctr2proc_rd_data testbench.pipeline_0.Fetch.ctr2proc_rd_valid testbench.pipeline_0.Fetch.ex_mem_take_branch testbench.pipeline_0.Fetch.ex_mem_target_pc testbench.pipeline_0.Fetch.id_str_hazard testbench.pipeline_0.Fetch.inst_out_a testbench.pipeline_0.Fetch.inst_out_a_PC testbench.pipeline_0.Fetch.inst_out_a_en testbench.pipeline_0.Fetch.inst_out_b testbench.pipeline_0.Fetch.inst_out_b_PC testbench.pipeline_0.Fetch.inst_out_b_en testbench.pipeline_0.Fetch.next_PC testbench.pipeline_0.Fetch.proc2ctr_rd_addr testbench.pipeline_0.Fetch.reset }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.PC_plus_4}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.PC_plus_4}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.PC_plus_8}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.PC_plus_8}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.PC_reg}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.PC_reg}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.ctr2proc_rd_data}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.ctr2proc_rd_data}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.ex_mem_target_pc}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.ex_mem_target_pc}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.id_str_hazard}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.id_str_hazard}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_a}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_a}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_a_PC}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_a_PC}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_b}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_b}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_b_PC}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.inst_out_b_PC}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.next_PC}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.next_PC}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Fetch.proc2ctr_rd_addr}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Fetch.proc2ctr_rd_addr}
set Group13 Group13
gui_sg_create ${Group13}
gui_sg_addsignal -group ${Group13} { {testbench.pipeline_0.Dispatch.rs.reservation_station[15].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[14].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[13].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[12].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[11].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[10].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[9].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[8].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[7].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[6].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[5].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[4].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[3].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[2].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[1].NPC} {testbench.pipeline_0.Dispatch.rs.reservation_station[0].NPC} }
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[15].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[15].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[14].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[14].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[13].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[13].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[12].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[12].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[11].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[11].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[10].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[10].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[9].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[9].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[8].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[8].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[7].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[7].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[6].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[6].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[5].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[5].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[4].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[4].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[3].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[3].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[2].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[2].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[1].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[1].NPC}}
gui_set_radix -radix {decimal} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[0].NPC}}
gui_set_radix -radix {unsigned} -signals {{Sim:testbench.pipeline_0.Dispatch.rs.reservation_station[0].NPC}}
set Group14 Group14
gui_sg_create ${Group14}
gui_sg_addsignal -group ${Group14} { testbench.pipeline_0.icache_0.MSHR_addr testbench.pipeline_0.icache_0.MSHR_valid testbench.pipeline_0.icache_0.addr_change_caused_miss testbench.pipeline_0.icache_0.cache2ctr_rd_data testbench.pipeline_0.icache_0.cache2ctr_rd_valid testbench.pipeline_0.icache_0.clock testbench.pipeline_0.icache_0.ctr2cache_rd_addr testbench.pipeline_0.icache_0.ctr2cache_wr_addr testbench.pipeline_0.icache_0.ctr2cache_wr_data testbench.pipeline_0.icache_0.ctr2cache_wr_enable testbench.pipeline_0.icache_0.ctr2mem_command testbench.pipeline_0.icache_0.ctr2mem_req_addr testbench.pipeline_0.icache_0.ctr2proc_rd_data testbench.pipeline_0.icache_0.ctr2proc_rd_valid testbench.pipeline_0.icache_0.halt_pc testbench.pipeline_0.icache_0.halt_pc_known testbench.pipeline_0.icache_0.halt_read testbench.pipeline_0.icache_0.last_miss_addr testbench.pipeline_0.icache_0.lm_counter testbench.pipeline_0.icache_0.mem2ctr_response testbench.pipeline_0.icache_0.mem2ctr_tag testbench.pipeline_0.icache_0.mem2ctr_wr_data testbench.pipeline_0.icache_0.next_MSHR_valid testbench.pipeline_0.icache_0.next_halt_pc testbench.pipeline_0.icache_0.next_halt_read testbench.pipeline_0.icache_0.next_last_miss_addr testbench.pipeline_0.icache_0.next_lm_counter testbench.pipeline_0.icache_0.next_requesting_addr testbench.pipeline_0.icache_0.proc2ctr_rd_addr testbench.pipeline_0.icache_0.requesting_addr testbench.pipeline_0.icache_0.requesting_inst_exceed_bound testbench.pipeline_0.icache_0.reset }
set Group15 Group15
gui_sg_create ${Group15}
gui_sg_addsignal -group ${Group15} { testbench.pipeline_0.X_br_inst_1 testbench.pipeline_0.X_br_inst_2 testbench.pipeline_0.X_br_mispredict_1 testbench.pipeline_0.X_br_mispredict_2 }
set Group16 Group16
gui_sg_create ${Group16}
gui_sg_addsignal -group ${Group16} { testbench.pipeline_0.Issue.clock testbench.pipeline_0.Issue.reset testbench.pipeline_0.Issue.D_NPC_1 testbench.pipeline_0.Issue.D_NPC_2 testbench.pipeline_0.Issue.I_rs_rd_inst_en_1 testbench.pipeline_0.Issue.I_rs_rd_inst_en_2 }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Issue.D_NPC_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Issue.D_NPC_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Issue.D_NPC_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Issue.D_NPC_2}
set Group17 Group17
gui_sg_create ${Group17}
gui_sg_addsignal -group ${Group17} { testbench.pipeline_0.Execute.I_X_NPC_alu0 testbench.pipeline_0.Execute.I_X_valid_inst_alu0 testbench.pipeline_0.Execute.I_X_NPC_alu1 testbench.pipeline_0.Execute.I_X_valid_inst_alu1 testbench.pipeline_0.Execute.I_X_NPC_alu2 testbench.pipeline_0.Execute.I_X_valid_inst_alu2 testbench.pipeline_0.Execute.I_X_NPC_alu3 testbench.pipeline_0.Execute.I_X_valid_inst_alu3 }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu0}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu0}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu3}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu3}
set Group18 Group18
gui_sg_create ${Group18}
gui_sg_addsignal -group ${Group18} { testbench.pipeline_0.Issue.regfile.registers }
set Group19 Group19
gui_sg_create ${Group19}
gui_sg_addsignal -group ${Group19} { testbench.pipeline_0.Execute.I_X_IR_alu0 testbench.pipeline_0.Execute.I_X_IR_alu1 testbench.pipeline_0.Execute.I_X_IR_alu2 testbench.pipeline_0.Execute.I_X_IR_alu3 testbench.pipeline_0.Execute.I_X_NPC_alu0 testbench.pipeline_0.Execute.I_X_NPC_alu1 testbench.pipeline_0.Execute.I_X_NPC_alu2 testbench.pipeline_0.Execute.I_X_NPC_alu3 testbench.pipeline_0.Execute.I_X_alu_func_alu0 testbench.pipeline_0.Execute.I_X_alu_func_alu1 testbench.pipeline_0.Execute.I_X_alu_func_alu2 testbench.pipeline_0.Execute.I_X_alu_func_alu3 testbench.pipeline_0.Execute.I_X_bmask_alu0 testbench.pipeline_0.Execute.I_X_bmask_alu1 testbench.pipeline_0.Execute.I_X_bmask_alu2 testbench.pipeline_0.Execute.I_X_bmask_alu3 testbench.pipeline_0.Execute.I_X_br_marker_alu0 testbench.pipeline_0.Execute.I_X_br_marker_alu1 testbench.pipeline_0.Execute.I_X_br_marker_alu2 testbench.pipeline_0.Execute.I_X_br_marker_alu3 testbench.pipeline_0.Execute.I_X_cond_branch_alu0 testbench.pipeline_0.Execute.I_X_cond_branch_alu1 testbench.pipeline_0.Execute.I_X_cond_branch_alu2 testbench.pipeline_0.Execute.I_X_cond_branch_alu3 testbench.pipeline_0.Execute.I_X_dest_reg_idx_alu0 testbench.pipeline_0.Execute.I_X_dest_reg_idx_alu1 testbench.pipeline_0.Execute.I_X_dest_reg_idx_alu2 testbench.pipeline_0.Execute.I_X_dest_reg_idx_alu3 testbench.pipeline_0.Execute.I_X_opa_select_alu0 testbench.pipeline_0.Execute.I_X_opa_select_alu1 testbench.pipeline_0.Execute.I_X_opa_select_alu2 testbench.pipeline_0.Execute.I_X_opa_select_alu3 testbench.pipeline_0.Execute.I_X_opb_select_alu0 testbench.pipeline_0.Execute.I_X_opb_select_alu1 testbench.pipeline_0.Execute.I_X_opb_select_alu2 testbench.pipeline_0.Execute.I_X_opb_select_alu3 testbench.pipeline_0.Execute.I_X_rd_mem_alu0 testbench.pipeline_0.Execute.I_X_rd_mem_alu1 testbench.pipeline_0.Execute.I_X_rd_mem_alu2 testbench.pipeline_0.Execute.I_X_rd_mem_alu3 testbench.pipeline_0.Execute.I_X_rega_alu0 testbench.pipeline_0.Execute.I_X_rega_alu1 testbench.pipeline_0.Execute.I_X_rega_alu2 testbench.pipeline_0.Execute.I_X_rega_alu3 testbench.pipeline_0.Execute.I_X_regb_alu0 testbench.pipeline_0.Execute.I_X_regb_alu1 testbench.pipeline_0.Execute.I_X_regb_alu2 testbench.pipeline_0.Execute.I_X_regb_alu3 testbench.pipeline_0.Execute.I_X_rs_rd_brpTN_alu0 testbench.pipeline_0.Execute.I_X_rs_rd_brpTN_alu1 testbench.pipeline_0.Execute.I_X_rs_rd_brp_TAR_PC_alu0 testbench.pipeline_0.Execute.I_X_rs_rd_brp_TAR_PC_alu1 testbench.pipeline_0.Execute.I_X_rs_rd_lsq_tail_alu0 testbench.pipeline_0.Execute.I_X_rs_rd_lsq_tail_alu1 testbench.pipeline_0.Execute.I_X_uncond_branch_alu0 testbench.pipeline_0.Execute.I_X_uncond_branch_alu1 testbench.pipeline_0.Execute.I_X_uncond_branch_alu2 testbench.pipeline_0.Execute.I_X_uncond_branch_alu3 testbench.pipeline_0.Execute.I_X_valid_inst_alu0 testbench.pipeline_0.Execute.I_X_valid_inst_alu1 testbench.pipeline_0.Execute.I_X_valid_inst_alu2 testbench.pipeline_0.Execute.I_X_valid_inst_alu3 testbench.pipeline_0.Execute.I_X_wr_mem_alu0 testbench.pipeline_0.Execute.I_X_wr_mem_alu1 testbench.pipeline_0.Execute.I_X_wr_mem_alu2 testbench.pipeline_0.Execute.I_X_wr_mem_alu3 testbench.pipeline_0.Execute.X_NPC_out_alu0 testbench.pipeline_0.Execute.X_NPC_out_alu1 testbench.pipeline_0.Execute.X_NPC_out_alu2 testbench.pipeline_0.Execute.X_NPC_out_alu3 testbench.pipeline_0.Execute.X_alu_result_out_alu0 testbench.pipeline_0.Execute.X_alu_result_out_alu1 testbench.pipeline_0.Execute.X_alu_result_out_alu2 testbench.pipeline_0.Execute.X_alu_result_out_alu3 testbench.pipeline_0.Execute.X_bmask_out_alu0 testbench.pipeline_0.Execute.X_bmask_out_alu1 testbench.pipeline_0.Execute.X_bmask_out_alu2 testbench.pipeline_0.Execute.X_bmask_out_alu3 testbench.pipeline_0.Execute.X_br_bmask_age_out_alu0 testbench.pipeline_0.Execute.X_br_bmask_age_out_alu1 testbench.pipeline_0.Execute.X_br_inst_1 testbench.pipeline_0.Execute.X_br_inst_2 testbench.pipeline_0.Execute.X_br_marker_1 testbench.pipeline_0.Execute.X_br_marker_2 testbench.pipeline_0.Execute.X_br_marker_out_alu0 testbench.pipeline_0.Execute.X_br_marker_out_alu1 }
gui_sg_addsignal -group ${Group19} { testbench.pipeline_0.Execute.X_br_mispredict_1 testbench.pipeline_0.Execute.X_br_mispredict_2 testbench.pipeline_0.Execute.X_dest_reg_idx_out_alu0 testbench.pipeline_0.Execute.X_dest_reg_idx_out_alu1 testbench.pipeline_0.Execute.X_dest_reg_idx_out_alu2 testbench.pipeline_0.Execute.X_dest_reg_idx_out_alu3 testbench.pipeline_0.Execute.X_rd_mem_out_alu0 testbench.pipeline_0.Execute.X_rd_mem_out_alu1 testbench.pipeline_0.Execute.X_rs_rd_brpTN_out_alu0 testbench.pipeline_0.Execute.X_rs_rd_brpTN_out_alu1 testbench.pipeline_0.Execute.X_rs_rd_brp_TAR_PC_out_alu0 testbench.pipeline_0.Execute.X_rs_rd_brp_TAR_PC_out_alu1 testbench.pipeline_0.Execute.X_rs_rd_lsq_tail_out_alu0 testbench.pipeline_0.Execute.X_rs_rd_lsq_tail_out_alu1 testbench.pipeline_0.Execute.X_take_branch_out_alu0 testbench.pipeline_0.Execute.X_take_branch_out_alu1 testbench.pipeline_0.Execute.X_take_branch_target_out_alu0 testbench.pipeline_0.Execute.X_take_branch_target_out_alu1 testbench.pipeline_0.Execute.X_valid_inst_out_alu0 testbench.pipeline_0.Execute.X_valid_inst_out_alu1 testbench.pipeline_0.Execute.X_valid_inst_out_alu2 testbench.pipeline_0.Execute.X_valid_inst_out_alu3 testbench.pipeline_0.Execute.X_wr_mem_out_alu0 testbench.pipeline_0.Execute.X_wr_mem_out_alu1 testbench.pipeline_0.Execute.X_wr_men_value_alu0 testbench.pipeline_0.Execute.X_wr_men_value_alu1 testbench.pipeline_0.Execute.alu_imm_alu2 testbench.pipeline_0.Execute.alu_imm_alu3 testbench.pipeline_0.Execute.alu_result_out_alu0 testbench.pipeline_0.Execute.alu_result_out_alu1 testbench.pipeline_0.Execute.alu_take_branch_out_alu0 testbench.pipeline_0.Execute.alu_take_branch_out_alu1 testbench.pipeline_0.Execute.br_disp_alu2 testbench.pipeline_0.Execute.br_disp_alu3 testbench.pipeline_0.Execute.clock testbench.pipeline_0.Execute.mem_disp_alu2 testbench.pipeline_0.Execute.mem_disp_alu3 testbench.pipeline_0.Execute.opa_mux_out_alu2 testbench.pipeline_0.Execute.opa_mux_out_alu3 testbench.pipeline_0.Execute.opb_mux_out_alu2 testbench.pipeline_0.Execute.opb_mux_out_alu3 testbench.pipeline_0.Execute.reset }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu0}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu0}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu3}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Execute.I_X_NPC_alu3}
set Group20 Group20
gui_sg_create ${Group20}
gui_sg_addsignal -group ${Group20} { testbench.pipeline_0.Dispatch.maptable.br_mispre_marker testbench.pipeline_0.Dispatch.maptable.br_mispredict testbench.pipeline_0.Dispatch.maptable.br_tag0 testbench.pipeline_0.Dispatch.maptable.br_tag1 testbench.pipeline_0.Dispatch.maptable.br_tag2 testbench.pipeline_0.Dispatch.maptable.br_tag3 testbench.pipeline_0.Dispatch.maptable.br_tag_ready0 testbench.pipeline_0.Dispatch.maptable.br_tag_ready1 testbench.pipeline_0.Dispatch.maptable.br_tag_ready2 testbench.pipeline_0.Dispatch.maptable.br_tag_ready3 testbench.pipeline_0.Dispatch.maptable.br_tmp_1 testbench.pipeline_0.Dispatch.maptable.br_tmp_2 testbench.pipeline_0.Dispatch.maptable.br_tmp_ready_1 testbench.pipeline_0.Dispatch.maptable.br_tmp_ready_2 testbench.pipeline_0.Dispatch.maptable.br_wr_en_1 testbench.pipeline_0.Dispatch.maptable.br_wr_en_2 testbench.pipeline_0.Dispatch.maptable.br_marker_in_1 testbench.pipeline_0.Dispatch.maptable.br_marker_in_2 testbench.pipeline_0.Dispatch.maptable.cdb_wr_en_1 testbench.pipeline_0.Dispatch.maptable.cdb_wr_en_2 testbench.pipeline_0.Dispatch.maptable.cdb_wr_en_now_1 testbench.pipeline_0.Dispatch.maptable.cdb_wr_en_now_2 testbench.pipeline_0.Dispatch.maptable.cdb_wr_idx_1 testbench.pipeline_0.Dispatch.maptable.cdb_wr_idx_2 testbench.pipeline_0.Dispatch.maptable.clock testbench.pipeline_0.Dispatch.maptable.fl_wr_en_1 testbench.pipeline_0.Dispatch.maptable.fl_wr_en_2 testbench.pipeline_0.Dispatch.maptable.fl_wr_idx_in_1 testbench.pipeline_0.Dispatch.maptable.fl_wr_idx_in_2 testbench.pipeline_0.Dispatch.maptable.id_dest_reg_idx_in_1 testbench.pipeline_0.Dispatch.maptable.id_dest_reg_idx_in_2 testbench.pipeline_0.Dispatch.maptable.id_ra_reg_idx_in_1 testbench.pipeline_0.Dispatch.maptable.id_ra_reg_idx_in_2 testbench.pipeline_0.Dispatch.maptable.id_rb_reg_idx_in_1 testbench.pipeline_0.Dispatch.maptable.id_rb_reg_idx_in_2 testbench.pipeline_0.Dispatch.maptable.mispredict_tag testbench.pipeline_0.Dispatch.maptable.mispredict_tag_ready testbench.pipeline_0.Dispatch.maptable.mt_dest_reg_old_1 testbench.pipeline_0.Dispatch.maptable.mt_dest_reg_old_2 testbench.pipeline_0.Dispatch.maptable.next_tmp_dest_reg_idx_1 testbench.pipeline_0.Dispatch.maptable.next_tmp_dest_reg_idx_2 testbench.pipeline_0.Dispatch.maptable.next_tmp_fl_reg_idx_1 testbench.pipeline_0.Dispatch.maptable.next_tmp_fl_reg_idx_2 testbench.pipeline_0.Dispatch.maptable.next_tmp_fl_wr_en_1 testbench.pipeline_0.Dispatch.maptable.next_tmp_fl_wr_en_2 testbench.pipeline_0.Dispatch.maptable.ra_reg_idx_out_1 testbench.pipeline_0.Dispatch.maptable.ra_reg_idx_out_2 testbench.pipeline_0.Dispatch.maptable.ra_reg_ready_out_1 testbench.pipeline_0.Dispatch.maptable.ra_reg_ready_out_2 testbench.pipeline_0.Dispatch.maptable.rb_reg_idx_out_1 testbench.pipeline_0.Dispatch.maptable.rb_reg_idx_out_2 testbench.pipeline_0.Dispatch.maptable.rb_reg_ready_out_1 testbench.pipeline_0.Dispatch.maptable.rb_reg_ready_out_2 testbench.pipeline_0.Dispatch.maptable.reg_tag testbench.pipeline_0.Dispatch.maptable.reg_tag_ready testbench.pipeline_0.Dispatch.maptable.reset testbench.pipeline_0.Dispatch.maptable.tmp_dest_reg_idx_1 testbench.pipeline_0.Dispatch.maptable.tmp_dest_reg_idx_2 testbench.pipeline_0.Dispatch.maptable.tmp_fl_reg_idx_1 testbench.pipeline_0.Dispatch.maptable.tmp_fl_reg_idx_2 testbench.pipeline_0.Dispatch.maptable.tmp_fl_wr_en_1 testbench.pipeline_0.Dispatch.maptable.tmp_fl_wr_en_2 }
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_mispre_marker}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_mispre_marker}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tag0}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tag1}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tag2}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tag3}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tag_ready0}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tag_ready1}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tag_ready2}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tag_ready3}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tmp_1}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tmp_2}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tmp_ready_1}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_tmp_ready_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_marker_in_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_marker_in_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_marker_in_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.br_marker_in_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.cdb_wr_idx_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.cdb_wr_idx_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.cdb_wr_idx_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.cdb_wr_idx_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.fl_wr_idx_in_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.fl_wr_idx_in_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.fl_wr_idx_in_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.fl_wr_idx_in_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_dest_reg_idx_in_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_dest_reg_idx_in_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_dest_reg_idx_in_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_dest_reg_idx_in_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_ra_reg_idx_in_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_ra_reg_idx_in_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_ra_reg_idx_in_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_ra_reg_idx_in_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_rb_reg_idx_in_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_rb_reg_idx_in_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_rb_reg_idx_in_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.id_rb_reg_idx_in_2}
gui_set_radix -radix enum -signals {Sim:testbench.pipeline_0.Dispatch.maptable.mispredict_tag}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.mispredict_tag_ready}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.mispredict_tag_ready}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.mt_dest_reg_old_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.mt_dest_reg_old_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.mt_dest_reg_old_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.mt_dest_reg_old_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.next_tmp_dest_reg_idx_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.next_tmp_dest_reg_idx_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.next_tmp_dest_reg_idx_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.next_tmp_dest_reg_idx_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.next_tmp_fl_reg_idx_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.next_tmp_fl_reg_idx_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.next_tmp_fl_reg_idx_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.next_tmp_fl_reg_idx_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.ra_reg_idx_out_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.ra_reg_idx_out_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.ra_reg_idx_out_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.ra_reg_idx_out_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.rb_reg_idx_out_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.rb_reg_idx_out_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.rb_reg_idx_out_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.rb_reg_idx_out_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.reg_tag}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.reg_tag}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.reg_tag_ready}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.reg_tag_ready}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.tmp_dest_reg_idx_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.tmp_dest_reg_idx_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.tmp_dest_reg_idx_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.tmp_dest_reg_idx_2}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.tmp_fl_reg_idx_1}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.tmp_fl_reg_idx_1}
gui_set_radix -radix {decimal} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.tmp_fl_reg_idx_2}
gui_set_radix -radix {unsigned} -signals {Sim:testbench.pipeline_0.Dispatch.maptable.tmp_fl_reg_idx_2}

# Global: Highlighting

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 2760



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 1} {Process 1} {UnnamedProcess 1} {Function 1} {Block 1} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design Sim
catch {gui_list_expand -id ${Hier.1} testbench}
catch {gui_list_expand -id ${Hier.1} testbench.pipeline_0}
catch {gui_list_expand -id ${Hier.1} testbench.pipeline_0.Dispatch}
catch {gui_list_select -id ${Hier.1} {testbench.pipeline_0.Dispatch.maptable}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {testbench.pipeline_0.Dispatch.maptable}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# DriverLoad 'DriverLoad.1'
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.pipeline_0.Fetch.inst_out_a_en -time 2660
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.pipeline_0.D_stall[1:0]} -time 20000

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active RAS verilog/RAS.v
gui_view_scroll -id ${Source.1} -vertical -set 0
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 10241
gui_list_add_group -id ${Wave.1} -after {New Group} {Group4}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group10}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group13}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group15}
gui_list_select -id ${Wave.1} {{testbench.pipeline_0.Dispatch.rs.reservation_station[15].NPC} }
gui_seek_criteria -id ${Wave.1} {Rising}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group Group15  -position in

gui_marker_move -id ${Wave.1} {C1} 2760
gui_view_scroll -id ${Wave.1} -vertical -set 159
gui_show_grid -id ${Wave.1} -enable false

# View 'Wave.2'
gui_wv_sync -id ${Wave.2} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.2}  C1
gui_wv_zoom_timerange -id ${Wave.2} 1408 3924
gui_list_add_group -id ${Wave.2} -after {New Group} {Group7}
gui_list_add_group -id ${Wave.2} -after {New Group} {Group6}
gui_list_expand -id ${Wave.2} testbench.pipeline_0.Dispatch.rob.NPC
gui_seek_criteria -id ${Wave.2} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.2} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.2} -text {*}
gui_list_set_insertion_bar  -id ${Wave.2} -group Group6  -item {testbench.pipeline_0.Dispatch.rob.br[0:31]} -position below

gui_marker_move -id ${Wave.2} {C1} 2760
gui_view_scroll -id ${Wave.2} -vertical -set 60
gui_show_grid -id ${Wave.2} -enable false

# View 'Wave.5'
gui_wv_sync -id ${Wave.5} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.5}  C1
gui_wv_zoom_timerange -id ${Wave.5} 1679 4045
gui_list_add_group -id ${Wave.5} -after {New Group} {Group16}
gui_list_add_group -id ${Wave.5} -after {New Group} {Group17}
gui_list_select -id ${Wave.5} {testbench.pipeline_0.Execute.I_X_NPC_alu0 }
gui_seek_criteria -id ${Wave.5} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.5} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.5} -text {*}
gui_list_set_insertion_bar  -id ${Wave.5} -group Group17  -item testbench.pipeline_0.Execute.I_X_valid_inst_alu3 -position below

gui_marker_move -id ${Wave.5} {C1} 2760
gui_view_scroll -id ${Wave.5} -vertical -set 0
gui_show_grid -id ${Wave.5} -enable false

# View 'Wave.6'
gui_wv_sync -id ${Wave.6} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.6}  C1
gui_wv_zoom_timerange -id ${Wave.6} 0 11520
gui_list_add_group -id ${Wave.6} -after {New Group} {Group18}
gui_list_expand -id ${Wave.6} testbench.pipeline_0.Issue.regfile.registers
gui_list_select -id ${Wave.6} {{testbench.pipeline_0.Issue.regfile.registers[33]} }
gui_seek_criteria -id ${Wave.6} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.6} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.6} -text {*}
gui_list_set_insertion_bar  -id ${Wave.6} -group Group18  -position in

gui_marker_move -id ${Wave.6} {C1} 2760
gui_view_scroll -id ${Wave.6} -vertical -set 264
gui_show_grid -id ${Wave.6} -enable false

# View 'Wave.7'
gui_wv_sync -id ${Wave.7} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.7}  C1
gui_wv_zoom_timerange -id ${Wave.7} 2543 2977
gui_list_add_group -id ${Wave.7} -after {New Group} {Group19}
gui_seek_criteria -id ${Wave.7} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.7} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.7} -text {*}
gui_list_set_insertion_bar  -id ${Wave.7} -group Group19  -position in

gui_marker_move -id ${Wave.7} {C1} 2760
gui_view_scroll -id ${Wave.7} -vertical -set 0
gui_show_grid -id ${Wave.7} -enable false

# View 'Wave.8'
gui_wv_sync -id ${Wave.8} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.8}  C1
gui_wv_zoom_timerange -id ${Wave.8} 856 5593
gui_list_add_group -id ${Wave.8} -after {New Group} {Group20}
gui_list_expand -id ${Wave.8} testbench.pipeline_0.Dispatch.maptable.reg_tag
gui_list_select -id ${Wave.8} {testbench.pipeline_0.Dispatch.maptable.br_tag0 testbench.pipeline_0.Dispatch.maptable.br_wr_en_2 testbench.pipeline_0.Dispatch.maptable.next_tmp_fl_reg_idx_2 }
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[0]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[0]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[1]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[1]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[2]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[2]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[3]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[3]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[4]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[4]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[5]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[5]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[6]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[6]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[7]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[7]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[8]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[8]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[9]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[9]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[10]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[10]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[11]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[11]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[12]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[12]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[13]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[13]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[14]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[14]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[15]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[15]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[16]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[16]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[17]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[17]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[18]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[18]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[19]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[19]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[20]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[20]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[21]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[21]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[22]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[22]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[23]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[23]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[24]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[24]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[25]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[25]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[26]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[26]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[27]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[27]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[28]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[28]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[29]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[29]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[30]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[30]}}
gui_set_radix -radix unsigned -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[31]}}
gui_set_radix -radix decimal -signal {{testbench.pipeline_0.Dispatch.maptable.reg_tag[31]}}
gui_seek_criteria -id ${Wave.8} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.8}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.8} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.8} -text {*}
gui_list_set_insertion_bar  -id ${Wave.8} -group Group20  -item {testbench.pipeline_0.Dispatch.maptable.br_marker_in_2[2:0]} -position below

gui_marker_move -id ${Wave.8} {C1} 2760
gui_view_scroll -id ${Wave.8} -vertical -set 214
gui_show_grid -id ${Wave.8} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.7}]} {
	gui_set_active_window -window ${TopLevel.7}
	gui_set_active_window -window ${Wave.6}
}
if {[gui_exist_window -window ${TopLevel.8}]} {
	gui_set_active_window -window ${TopLevel.8}
	gui_set_active_window -window ${Wave.7}
}
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
if {[gui_exist_window -window ${TopLevel.3}]} {
	gui_set_active_window -window ${TopLevel.3}
	gui_set_active_window -window ${Wave.2}
}
if {[gui_exist_window -window ${TopLevel.6}]} {
	gui_set_active_window -window ${TopLevel.6}
	gui_set_active_window -window ${Wave.5}
}
if {[gui_exist_window -window ${TopLevel.9}]} {
	gui_set_active_window -window ${TopLevel.9}
	gui_set_active_window -window ${Wave.8}
}
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Source.1}
	gui_set_active_window -window ${DLPane.1}
}
#</Session>

