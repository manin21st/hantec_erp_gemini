$PBExportHeader$w_pdt_01560.srw
$PBExportComments$** 생산 계획 현황
forward
global type w_pdt_01560 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01560
end type
end forward

global type w_pdt_01560 from w_standard_print
string title = "생산 계획 현황"
rr_1 rr_1
end type
global w_pdt_01560 w_pdt_01560

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_year, s_frdate, s_todate, s_gub, s_ittyp, s_mrplastdate, stxt, sfitnbr, stitnbr
decimal dactno

dw_ip.AcceptText()

s_gub   			= dw_ip.GetItemString(1,"gubun")
s_ittyp 			= dw_ip.GetItemString(1,"ittyp")
s_mrplastdate 	= dw_ip.getitemstring(1, "mrprun")
stxt			  	= dw_ip.getitemstring(1, "caltxt")
s_year 			= dw_ip.GetItemString(1,"syear")
dactno 			= dw_ip.GetItemdecimal(1,"actno")
sfitnbr 			= dw_ip.GetItemString(1,"sitnbr")
stitnbr 			= dw_ip.GetItemString(1,"eitnbr")

IF s_year = "" OR IsNull(s_year) THEN
	if s_gub = '1' then
		f_message_chk(302,'[기준년도]')
	else
		f_message_chk(302,'[기준년월]')		
	end if
	dw_ip.SetColumn("syear")
	dw_ip.SetFocus()
	Return -1
end if

IF dactno = 0 OR IsNull(dactno) THEN
	f_message_chk(302,'[실행순번]')
	dw_ip.SetColumn("actno")
	dw_ip.SetFocus()
	Return -1
end if

if isnull(sfitnbr) or trim(sFitnbr) = '' then sFitnbr = '.';
if isnull(stitnbr) or trim(sTitnbr) = '' then sTitnbr = 'ZZZZZZZZZZZZZZZ';

if s_gub = '1' then    //년간계획 조회

	s_year = s_year + '%'

   if isnull(s_ittyp) or trim(s_ittyp) = '' then
		s_ittyp = '%'
	else
		s_ittyp = s_ittyp + '%'		
	end if

	if dw_ip.getitemstring(1, "prtgu") = '1' then
		dw_print.DataObject ="d_pdt_01560_1_p" 
		dw_list.DataObject ="d_pdt_01560_1" 
		dw_print.SetTransObject(SQLCA)
		IF dw_print.Retrieve(gs_sabu, dactno, s_gub, s_year, s_ittyp, s_mrplastdate, stxt, gs_saupcd) < 1 THEN
			f_message_chk(50,'')
			dw_ip.Setfocus()
			return -1
		end if
	ELSE
		dw_print.DataObject ="d_pdt_01560_4_p" 
	   dw_list.DataObject ="d_pdt_01560_4" 
		dw_print.SetTransObject(SQLCA)
		IF dw_print.Retrieve(gs_sabu, dactno, s_gub, s_ittyp, s_mrplastdate, stxt, s_year, sfitnbr, stitnbr, gs_saupcd) < 1 THEN
			f_message_chk(50,'')
			dw_ip.Setfocus()
			return -1
		end if		
	END IF
else      //연동계획 조회
	s_frdate = trim(dw_ip.GetItemString(1,"fr_date"))
	s_todate = trim(dw_ip.GetItemString(1,"to_date"))
	IF s_frdate = "" OR IsNull(s_frdate) THEN 
		s_frdate = s_year+'01'
	END IF

	IF s_todate = "" OR IsNull(s_todate) THEN 
		select to_char(add_months(to_date(:s_frdate, 'yyyymmdd') , 5), 'yyyymmdd')
		  into :s_todate
		  from dual;
	END IF

	if s_frdate > s_todate then 
		f_message_chk(34,'[계획일자]')
		dw_ip.Setcolumn('fr_date')
		dw_ip.SetFocus()
		return -1
	end if	
 
   if isnull(s_ittyp) or trim(s_ittyp) = '' then
		s_ittyp = '%'
	else
		s_ittyp = s_ittyp + '%'		
	end if

   if isnull(s_mrplastdate) then s_mrplastdate = ''
	
	if dw_ip.getitemstring(1, "prtgu") = '1' then
		dw_print.DataObject ="d_pdt_01560_2_p" 
	   dw_list.DataObject ="d_pdt_01560_2" 
		dw_print.SetTransObject(SQLCA)
		IF dw_print.Retrieve(gs_sabu, dactno, s_gub, s_frdate, s_todate, s_ittyp, s_mrplastdate, stxt, gs_saupcd) < 1 THEN
			f_message_chk(50,'')
			dw_ip.Setfocus()
			return -1
		end if
	else
		dw_print.DataObject ="d_pdt_01560_3_p" 
	   dw_list.DataObject ="d_pdt_01560_3" 
		dw_print.SetTransObject(SQLCA)

		dw_list.object.m1_t.text = left(s_year, 4) + '.' + right(s_year, 2) 
      dw_list.object.m2_t.text = String(f_aftermonth( s_year, 1), '@@@@.@@')
      dw_list.object.m3_t.text =  String(f_aftermonth( s_year, 2), '@@@@.@@')
      dw_list.object.m4_t.text =  String(f_aftermonth( s_year, 3), '@@@@.@@')
      dw_list.object.m5_t.text =  String(f_aftermonth( s_year, 4), '@@@@.@@')
      		
		IF dw_print.Retrieve(gs_sabu, dactno, s_gub, s_ittyp, s_mrplastdate, stxt, s_year, sfitnbr, stitnbr, gs_saupcd) < 1 THEN
			f_message_chk(50,'')
			dw_ip.Setfocus()
			return -1
		end if		
	end if

end if

dw_print.sharedata(dw_list)
return 1

end function

on w_pdt_01560.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01560.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String s_yymm, s_mrplastdate, stxt, snull, ssidat, seddat
long	 L_actno

Setnull(snull)

 SELECT MAX("MRPSYS"."ACTNO")
	 INTO :l_actno
	 FROM "MRPSYS"  
	WHERE ( "MRPSYS"."SABU" = :gs_sabu ) AND  
			( "MRPSYS"."MRPDATA" = '1' )   ;
			
Select mrpgiyymm, mrprun, mrptxt, mrpsidat, mrpeddat
  into :s_yymm, :s_mrplastdate, :stxt, :ssidat, :seddat
  from mrpsys
 where sabu = :gs_sabu and actno = :l_actno;

if not isnull(s_yymm) then
	dw_ip.setitem(1, "syear", s_yymm)
	dw_ip.setitem(1, "mrprun", s_mrplastdate)
	dw_ip.setitem(1, "caltxt", stxt)
	dw_ip.setitem(1, "actno",  l_actno)
	dw_ip.setitem(1, "fr_date",  ssidat)
	dw_ip.setitem(1, "to_date",  seddat)
else
	dw_ip.setitem(1, "syear", snull)
	dw_ip.setitem(1, "mrprun", snull)
	dw_ip.setitem(1, "caltxt", snull)		
	dw_ip.setitem(1, "actno",  snull)
	dw_ip.setitem(1, "fr_date",  snull)
	dw_ip.setitem(1, "to_date",  snull)
end if	

dw_ip.SetColumn("gubun")
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_01560
end type

type p_exit from w_standard_print`p_exit within w_pdt_01560
end type

type p_print from w_standard_print`p_print within w_pdt_01560
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01560
end type











type dw_print from w_standard_print`dw_print within w_pdt_01560
string dataobject = "d_pdt_01560_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01560
integer x = 69
integer y = 32
integer width = 3090
integer height = 284
string dataobject = "d_pdt_01560_a"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string snull, s_name, s_itt, s_date, s_mrplastdate, stxt, s_gub, s_yymm, ssidat, seddat
long	 l_actno

setnull(snull)

if this.getcolumnname() = 'actno' then
	
	l_actno = double(gettext())

	Select mrpgiyymm, mrprun, mrptxt, mrpsidat, mrpeddat
	  into :s_yymm, :s_mrplastdate, :stxt, :ssidat, :seddat
	  from mrpsys
	 where sabu = :gs_sabu and actno = :l_actno;
	
	if not isnull(s_yymm) then
		this.setitem(1, "syear", s_yymm)
		this.setitem(1, "mrprun", s_mrplastdate)
		this.setitem(1, "caltxt", stxt)
		this.setitem(1, "actno",  l_actno)
		this.setitem(1, "fr_date",  ssidat)
		this.setitem(1, "to_date",  seddat)
	else
		f_message_chk(302,'[실행순번]')		
		this.setitem(1, "syear", snull)
		this.setitem(1, "mrprun", snull)
		this.setitem(1, "caltxt", snull)		
		this.setitem(1, "actno",  snull)
		this.setitem(1, "fr_date",  snull)
		this.setitem(1, "to_date",  snull)
		return 1
	end if	

elseif this.getcolumnname() = 'gubun' then
	
	  s_gub = this.gettext()
	  
	  if s_gub = '1' then
		  this.object.syear.editmask.mask = '####'
		  this.object.fr_date[1] = snull
		  this.object.to_date[1] = snull
	  else
		  this.object.syear.editmask.mask = '####.##'	  
	  end if
	  
	  SELECT MAX("MRPSYS"."ACTNO")
		 INTO :l_actno
		 FROM "MRPSYS"  
		WHERE ( "MRPSYS"."SABU" = :gs_sabu ) AND  
				( "MRPSYS"."MRPDATA" = :s_gub )   ;
				
	Select mrpgiyymm, mrprun, mrptxt, mrpsidat, mrpeddat
	  into :s_yymm, :s_mrplastdate, :stxt, :ssidat, :seddat
	  from mrpsys
	 where sabu = :gs_sabu and actno = :l_actno;
	
	if not isnull(s_yymm) then
		this.setitem(1, "syear", s_yymm)
		this.setitem(1, "mrprun", s_mrplastdate)
		this.setitem(1, "caltxt", stxt)
		this.setitem(1, "actno",  l_actno)
		this.setitem(1, "fr_date",  ssidat)
		this.setitem(1, "to_date",  seddat)
	else
		this.setitem(1, "syear", snull)
		this.setitem(1, "mrprun", snull)
		this.setitem(1, "caltxt", snull)		
		this.setitem(1, "actno",  snull)
		this.setitem(1, "fr_date",  snull)
		this.setitem(1, "to_date",  snull)
	end if	
	
end if

IF this.GetColumnName() = 'fr_date' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[계획일자]')
		this.SetItem(1,"fr_date",snull)
		Return 1
	END IF
ELSEIF this.GetColumnName() = 'to_date' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[계획일자]')
		this.SetItem(1,"to_date",snull)
		Return 1
	END IF
END IF

end event

event dw_ip::rbuttondown;Long l_actno
String 	s_yymm, s_mrplastdate, stxt, ssidat, seddat, snull, sgubun

Setnull(snull)
Setnull(gs_gubun)
Setnull(gs_code)
Setnull(gs_codename)

if this.getcolumnname() = 'actno' then
	open(w_mrpsys_popup)
	setitem(1, "actno", double(gs_code))
	
	L_actno = double(gs_code)
	
	Select mrpgiyymm, mrprun, mrptxt, mrpsidat, mrpeddat, mrpdata
	  into :s_yymm, :s_mrplastdate, :stxt, :ssidat, :seddat, :sgubun
	  from mrpsys
	 where sabu = :gs_sabu and actno = :l_actno;
	
	if not isnull(s_yymm) then
		this.setitem(1, "syear", s_yymm)
		this.setitem(1, "mrprun", s_mrplastdate)
		this.setitem(1, "caltxt", stxt)
		this.setitem(1, "actno",  l_actno)
		this.setitem(1, "fr_date",  ssidat)
		this.setitem(1, "to_date",  seddat)
		this.setitem(1, "gubun",  sgubun)
	else
		this.setitem(1, "syear", snull)
		this.setitem(1, "mrprun", snull)
		this.setitem(1, "caltxt", snull)		
		this.setitem(1, "actno",  snull)
		this.setitem(1, "fr_date",  snull)
		this.setitem(1, "to_date",  snull)
	end if	
elseif this.GetColumnName() = 'sitnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"sitnbr",gs_code)
elseif this.GetColumnName() = 'eitnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"eitnbr",gs_code)

end if	
end event

type dw_list from w_standard_print`dw_list within w_pdt_01560
integer x = 82
integer y = 352
integer width = 4512
integer height = 1948
string dataobject = "d_pdt_01560_1"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within w_pdt_01560
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 344
integer width = 4535
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

