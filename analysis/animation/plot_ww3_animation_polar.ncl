;
; This script plots ww3 variables at Arctic
;
; Li Qing, 20170630

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; define parameters
	type	= "ps"  ; plot type
	type@wkPaperWidthF  = 6
	type@wkPaperHeightF = 6
	;type	= "x11"

; define file names
	gtype   = "gx16b"
	yyyymm  = "200907"
	casen	= "testIce_"+yyyymm+"_"+gtype
	datadir = "/glade/u/home/qingli/SCRATCH/wwatch3v5p16/"
	diri	= datadir+casen+"/out/"
	fili	= "ww3_"+yyyymm+".nc"
	f	= addfile(diri+fili,"r")

; set variables
	vars	= (/"hs"/)
	minlv 	= (/0/)
	maxlv 	= (/10/)
	intlv	= (/0.25/)
	nvar 	= dimsizes(vars)
	l_ice   = True ; plot 15% and 85% ice line

; saved time step
	svtstep = (/19, 68, 99, 119/)

; polar regions
	polars  = (/"NH", "SH"/)
	npl	= 2

	lat	= f->latitude
	lon	= f->longitude
	time 	= f->time 
	time@calendar = "julian"
        nt = dimsizes(time)
	ndsize  = dimsizes(dimsizes(lat))

; read ice
if (l_ice) then
	ice	= f->ice
	if (ndsize .eq. 2) then
		ice@lat2d	= lat
		ice@lon2d	= lon
	end if
end if
	
; loop over variables
do iv=0,nvar-1
	var 	= vars(iv) 
	print(var)

; read variables
	dat	= f->$var$
	if (ndsize .eq. 2) then
		dat@lat2d	= lat
		dat@lon2d	= lon
	end if

; loop over polar regions
do ip=0,npl-1
	polar	= polars(ip)
	print(polar)

; open workstation
	res				= True
	res@gsnDraw			= False
	res@gsnFrame			= False
	res@gsnAddCyclic		= True
	res@gsnRightString		= var
        res@lbTitleString               = dat@units
	res@gsnMaximize			= True
	res@gsnPaperOrientation		= "portrait" 
	res@gsnPaperMargin		= 0.2
	res@gsnPolar			= polar
; change the size of the image box
	res@vpWidthF	= 0.4
	res@vpHeightF	= 0.4
; map
	if (polar .eq. "NH") then
		res@mpMinLatF	= 45
	else
		res@mpMaxLatF	= -45
	end if

; line labels
	res@cnLinesOn			= False
	res@cnInfoLabelOn		= False
	res@cnLineLabelsOn		= False

	res@cnFillOn			= True
	res@cnFillMode 			= "CellFill"
	res@gsnSpreadColors		= True
	res@cnLevelSelectionMode	= "ManualLevels"
	res@cnMinLevelValF      	= minlv(iv)
	res@cnMaxLevelValF      	= maxlv(iv)
	res@cnLevelSpacingF     	= intlv(iv)
	res@lbLabelBarOn 		= True
        res@lbOrientation       	= "vertical"    ; vertical label bar
        res@lbLeftMarginF		= 0.0
        res@lbLabelAutoStride		= True
        res@lbTitleFontHeightF 		= 0.013

; for 15% and 85% ice fraction contours
	if (l_ice) then
		ires    = res
		ires@cnLinesOn			= True  ; turn line on and fill off
		ires@cnFillOn			= False
		ires@cnLevelSelectionMode	= "ExplicitLevels"
		ires@cnLevels			= (/0.15, 0.85/)   ; change contour interval
		ires@cnLineColor 		= "white"
		ires@cnLineThicknessF		= 1.5
		ires@gsnLeftString		= ""    ; no string for plot2                                       
		ires@gsnRightString		= ""
		delete(ires@gsnPolar)       ; no longer in use for plot2
		if (polar .eq. "NH") then
			delete(ires@mpMinLatF)
		else
			delete(ires@mpMaxLatF)
		end if
		delete(ires@mpCenterLonF)
		delete(ires@mpShapeMode)
		delete(ires@cnMinLevelValF)
		delete(ires@cnMaxLevelValF)
		delete(ires@cnLevelSpacingF)
	end if

; plot
do it = 0, nt-1
	it_str = sprinti("%03i", it) 
	if (mod(it, 10) .eq. 0) then
		print(it_str)
	end if
	time_str = sprinti("%08i", cd_calendar(time(it), -2))
	filo	= var+"_"+it_str
	wks	= gsn_open_wks(type, filo) 
	gsn_define_colormap(wks, "BlGrYeOrReVi200")
	res@gsnLeftString = time_str
	plot=gsn_csm_contour_map_polar(wks,dat(it,:,:),res)
	if (l_ice) then
		plot2 = gsn_csm_contour(wks,ice(it,:,:),ires)
		overlay(plot,plot2)
	end if
	draw(plot)
	frame(wks)
	delete(wks)
end do

	delete(res)

; create directory
	cmd = "mkdir -p "+casen
	system(cmd)

; create gif
	cmd = "convert -density 150 -delay 25 "+var+"_*.ps "+casen+"/"+var+"_"+yyyymm+"_"+gtype+"_"+polar+".gif"
	system(cmd)

; save snapshots
	nsv = dimsizes(svtstep)
do is = 0, nsv-1
	svtstep_str = sprinti("%03i", svtstep(is))
	cmd = "mv "+var+"_"+svtstep_str+".ps "+casen+"/"+gtype+"_"+var+"_"+svtstep_str+"_"+polar+".ps"
	system(cmd)
end do

; clean up .ps files
	cmd = "rm "+var+"_*.ps"
	system(cmd)

end do ; end loop over polars

end do ; end loop over variables

end 