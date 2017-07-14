$ -------------------------------------------------------------------- $
$ WAVEWATCH III Field preprocessor input file                          $
$ -------------------------------------------------------------------- $
$ Major types of field and time flag
$   Field types  :  IC1   Ice thickness.
$                   IC5   Ice floe mean diameter.
$                   ICE   Ice concentrations.
$                   ISI   Icebergs and sea ice.
$                   LEV   Water levels.
$                   WND   Winds.
$                   WNS   Winds (including air-sea temp. dif.)
$                   CUR   Currents.
$                   DAT   Data for assimilation.
$
$   Format types :  AI    Transfer field 'as is'. (ITYPE 1)
$                   LL    Field defined on regular longitude-latitude
$                         or Cartesian grid. (ITYPE 2)
$   Format types :  AT    Transfer field 'as is', performs tidal 
$                         analysis on the time series (ITYPE 6)
$                         When using AT, another line should be added
$                         with the choice of tidal constituents:
$                         ALL or FAST or VFAST or a list: e.g. 'M2 S2'
$
$        - Format type not used for field type 'DAT'.
$
$   Time flag    : If true, time is included in file.
$   Header flag  : If true, header is added to file.
$                  (necessary for reading, FALSE is used only for
$                   incremental generation of a data file.)
$
  'ICE' 'LL' T T
$
$ Name of spatial dimensions------------------------------------------ $
$ NB: time dimension is expected to be called 'time' and must respect 
$     Julian or Gregorian calendar with leap day.
$
 lon lat
$
$ Variables to use --------------------------------------------------- $
$
  aice
$
$ Additional time input ---------------------------------------------- $
$ If time flag is .FALSE., give time of field in yyyymmdd hhmmss format.
$
$   19680606 053000
$
$ Define data files -------------------------------------------------- $
$ The input line identifies the filename using for the forcing field.
$
  'cice.nc'
$
$ -------------------------------------------------------------------- $
$ End of input file                                                    $
$ -------------------------------------------------------------------- $