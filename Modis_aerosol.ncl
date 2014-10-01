load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

begin

files			= systemfunc("ls *hdf")
dim_files 		= dimsizes(files)

do i 			= 0, dim_files-1
	file2 			= files(i)
	filc		= stringtochar(file2)
	name		= chartostring(filc(0:39))
	if (isfilepresent(name+".png")) then
    		print("File is present. Going to the next file ...!")
	else

	data			= addfile(file2, "r")
	    if (ismissing(data)) then
		print("Error opening "+file2+". Going to the next file ...")
		continue
	    end if
	optical_depth 		= data->Optical_Depth_Land_And_Ocean
	optical_depth@long_name = "Optical Depth Land And Ocean"
	lat 			= data->Latitude
	lon 			= data->Longitude
	optical_depth@lat2d 	= lat
	optical_depth@lon2d 	= lon
;*************************************************************
; create plot
;*************************************************************
  wks = gsn_open_wks("png", name) 

  
  res			= True
  res@cnFillOn		= True               ; color Fill 
  res@cnFillMode	= "RasterFill"       ; Raster Mode
  res@cnLinesOn		= False              ; Turn off contour lines  
  res@gsnSpreadColors	= True               ; use full colormap
  res@gsnRightString	= "None"
  
  res@mpMinLatF           = min(lat)-5       ; choose map limits
  res@mpMaxLatF           = max(lat)+5
  res@mpMinLonF           = min(lon)-5
  res@mpMaxLonF           = max(lon)+5
  res@mpDataBaseVersion   = "Ncarg4_1"       ; higher res coastline
  res@gsnAddCyclic        = False            ; needed b/c data not global
  res@mpOutlineBoundarySets  = "National"    ; turn on country boundaries
  res@mpDataSetName        = "Earth..4"      ; database for non-USA divisions
  res@mpDataBaseVersion    = "MediumRes"     ; Medium resolution database
  res@mpOutlineSpecifiers  = (/"Kenya:states"/)
  
;  res@tiMainString        = optical_depth@long_name
  
  plot = gsn_csm_contour_map_ce(wks,optical_depth, res) ; create plot

;*************************************************************
; clean up
;*************************************************************
	delete (wks)
	delete (res)
	delete (lat)
	delete (lon)
	delete (data)
	delete (optical_depth)
	    end if
end do

end
