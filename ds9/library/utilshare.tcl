#  Copyright (C) 1999-2023
#  Smithsonian Astrophysical Observatory, Cambridge, MA, USA
#  For conditions of distribution and use, see copyright notice in "copyright"

package provide DS9 1.0

proc GetEnvHome {} {
    global env
    global tcl_platform

    switch $tcl_platform(platform) {
	unix {
	    if {[info exists env(HOME)]} {
		return $env(HOME)
	    }
	}
	windows {
	    if {[info exists env(HOME)]} {
		set hh [file normalize [file nativename $env(HOME)]]
		if {[file isdirectory $hh]} {
		    return $hh
		}
	    }
	    # this is just a backup, the above should always work
	    if {[info exists env(HOMEDRIVE)] &&	[info exists env(HOMEPATH)]} {
		return "$env(HOMEDRIVE)$env(HOMEPATH)"
	    }
	}
    }
    return {}
}

# location for ds9-managed persistent state (prefs, autosave, ...).
# on windows, this is the per-user roaming app data dir, since HOME
# (or its HOMEDRIVE/HOMEPATH fallback) is not the recommended place for
# an app to keep its own files. unix/aqua are unaffected.
proc GetAppDataHome {} {
    global env
    global tcl_platform

    switch $tcl_platform(platform) {
	windows {
	    if {[info exists env(APPDATA)]} {
		set hh [file normalize [file nativename $env(APPDATA)]]
		if {[file isdirectory $hh]} {
		    return $hh
		}
	    }
	}
    }

    # unix/aqua, or as a windows fallback if APPDATA is unset/unusable
    return [GetEnvHome]
}

proc ParseURL {url varname} {
    upvar $varname r

    set r(scheme) {}
    set r(authority) {}
    set r(path) {}
    set r(query) {}
    set r(fragment) {}
    set exp {^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?}

    if {![regexp -nocase $exp $url x a r(scheme) c r(authority) r(path) f r(query) h r(fragment)]} {
	return 0
    }

    # check for windows disk drives
    global tcl_platform
    switch $tcl_platform(platform) {
	unix {
	    if {($r(scheme) == {} || $r(scheme) == {file}) &&
		($r(authority) == {zipfs} || $r(authority) == {zipfs:})} {
		# Tcl 9 zipfs paths are volumes like //zipfs:/mntpt.
		# Keep the volume prefix as part of the filesystem path.
		set r(path) "//$r(authority)$r(path)"
		set r(authority) {}
		if {$r(scheme) == {file}} {
		    set r(scheme) {}
		}
	    }

	    switch -- $r(scheme) {
		zipfs {
		    # special case for zipfs
		    set r(path) "$r(scheme):$r(path)"
		    set r(scheme) {}
		}
		ftp {
		    # strip any username/passwd
		    set id [string first {@} $r(authority)]
		    if { $id != -1} {
			set r(authority) [string range $r(authority) [expr $id+1] end]
		    }
		}
	    }
	}
	windows {
	    switch -- $r(scheme) {
		{} -
		ftp -
		http -
		https -
		file {
		    if {[regexp {/([A-Z]:)(/.*)} $r(path) a b c]} {
			set r(path) "$b$c"
		    }
		}
		default {
		    set r(path) "$r(scheme):$r(path)"
		    set r(scheme) {}
		}
	    }
	}
    }

    return 1
}

proc XMLQuote {val} {
    return [string map {& &amp; < &lt; > &gt; \' &apos; \" &quot; \n \r} $val]
}

proc XMLUnQuote {val} {
    return [string map {&amp; & &lt; < &gt; > &apos; \' &quot; \" \r \n} $val]
}
