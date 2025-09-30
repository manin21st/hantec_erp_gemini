$PBExportHeader$w_sal_01720.srw
$PBExportComments$견적의뢰 현황
forward
global type w_sal_01720 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_01720
end type
end forward

global type w_sal_01720 from w_standard_print
string title = "견적의뢰 현황"
rr_1 rr_1
end type
global w_sal_01720 w_sal_01720

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate,ls_edate,ls_status,ls_rdtcod,ls_empno,ls_pdept,ls_ofepnm,ls_itnbr,sItdsc,txt_name ,tx_name
string ls_redptnm,ls_pdeptnm
String sIspec, sJijil

if dw_ip.accepttext() <> 1 then return -1

ls_sdate=trim(dw_ip.getitemstring(1,"sdate"))
ls_edate=trim(dw_ip.getitemstring(1,"edate"))


IF ls_sdate= "" or isnull(ls_sdate) then 
	f_message_chk(30, '[견적의뢰일 FROM]')
	dw_ip.setcolumn("sdate")
	return -1
end if
IF ls_edate="" or isnull(ls_edate) then 
	f_message_chk(30, '[견적의뢰일 TO]')
	dw_ip.setcolumn("edate")
	return -1
end if

ls_status	=	Trim(dw_ip.getitemstring(1,"status"))
ls_rdtcod	=	Trim(dw_ip.getitemstring(1,"redptcod"))
ls_redptnm	=	Trim(dw_ip.getitemstring(1,"redptnm"))
ls_empno		=	Trim(dw_ip.getitemstring(1,"empno"))
ls_pdept		=	Trim(dw_ip.getitemstring(1,"pdept"))
ls_pdeptnm	=	Trim(dw_ip.getitemstring(1,"pdeptnm"))
ls_ofepnm	=	Trim(dw_ip.getitemstring(1,"ofempno"))
ls_itnbr		=	Trim(dw_ip.getitemstring(1,"itnbr"))
sItdsc 		= 	Trim(dw_ip.getitemstring(1,"itdsc"))
sIspec 		= Trim(dw_ip.getitemstring(1,"ispec"))
sJijil 		= Trim(dw_ip.getitemstring(1,"jijil"))

If IsNull(sItdsc) Then sItdsc = ''
If IsNull(sIspec) Then sIspec = ''
If IsNull(sJijil) Then sJijil = ''

if dw_list.retrieve(gs_sabu,ls_sdate,ls_edate,ls_status,ls_rdtcod,ls_empno,ls_pdept,ls_ofepnm,ls_itnbr,sItdsc, sIspec, sJijil ) < 1 then
 		f_message_chk(50,'')
		dw_ip.Setfocus()
	   return -1
end if

txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(status) ', 1)"))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
//dw_list.Object.tx_status.text = txt_name

if isnull(ls_redptnm) or ls_redptnm="" then ls_redptnm="전체"
//dw_list.object.tx_rdept.text=ls_redptnm

txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(empno) ', 1)"))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
//dw_list.Object.tx_semp.text = txt_name
//
if isnull(ls_pdeptnm) or ls_pdeptnm="" then ls_pdeptnm="전체"
//dw_list.object.tx_pdept.text=ls_pdeptnm
//
tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ofempno) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_empnm.text = '"+tx_name+"'")

if isnull(ls_itnbr) or ls_itnbr="" then ls_itnbr="전체"
//dw_list.object.tx_itnbr.text=ls_itnbr

if isnull(sItdsc) or sItdsc="" then sItdsc="전체"
//dw_list.object.tx_itdsc.text=sItdsc

return 1

end function

on w_sal_01720.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_01720.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;//string ls_date

dw_ip.settransobject(sqlca)

//ls_date=today()
dw_ip.setitem(1,"sdate",mid(string(today(),"yyyymm"),1,6) +'01')
dw_ip.setitem(1,"edate",string(today(),"yyyymmdd"))

end event

type p_preview from w_standard_print`p_preview within w_sal_01720
end type

type p_exit from w_standard_print`p_exit within w_sal_01720
end type

type p_print from w_standard_print`p_print within w_sal_01720
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01720
end type







type st_10 from w_standard_print`st_10 within w_sal_01720
end type



type dw_print from w_standard_print`dw_print within w_sal_01720
string dataobject = "d_sal_01720_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01720
integer y = 24
integer width = 3314
integer height = 376
string dataobject = "d_sal_01720_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string  snull,ls_sdate,ls_edate
string ls_rdcod,ls_rdnm,ls_pdept,ls_pdeptnm
String sItnbr, sItdsc, sIspec, sJijil

setnull(snull)

IF this.GetColumnName() = "sdate"	THEN
	ls_sdate = trim(this.GetText())
	
	if ls_sdate = "" or isnull(ls_sdate) then	return 

  	IF f_datechk(ls_sdate) = -1	then
      f_message_chk(35, '[견적의뢰일자 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	ls_edate = trim(this.GetText())
	
	if ls_edate = "" or isnull(ls_edate) then	return 

  	IF f_datechk(ls_edate) = -1	then
      f_message_chk(35, '[견적의뢰일자 TO]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
end if

Choose Case GetColumnName() 
  Case "redptcod"

		ls_rdcod = this.GetText()
		IF ls_rdcod ="" OR IsNull(ls_rdcod) THEN
			this.SetItem(1,"redptnm",snull)
			Return
		END IF
		
		SELECT DEPTNAME
		INTO   :ls_rdnm
		FROM  P0_DEPT
		WHERE DEPTCODE = :ls_rdcod  ;

		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
			this.setcolumn("redptcod")
		ELSE
			this.SetItem(1,"redptnm", ls_rdnm)
		END IF
	 Case "pdept"

		ls_rdcod = this.GetText()
		IF ls_rdcod ="" OR IsNull(ls_rdcod) THEN
			this.SetItem(1,"pdeptnm",snull)
			Return
		END IF
		
		SELECT DEPTNAME
		INTO   :ls_rdnm
		FROM  P0_DEPT
		WHERE DEPTCODE = :ls_rdcod  ;

		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"pdeptnm", ls_rdnm)
		END IF
	 Case "itnbr"
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetItem(1,'jijil',sNull)
			Return
		END IF
		
		SELECT "ITDSC", "ISPEC", "JIJIL"
		  INTO :sItdsc, :sIspec, :sJijil
		  FROM "ITEMAS"
		 WHERE "ITNBR" = :sItnbr ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		END IF
		
		SetItem(1,"itdsc", sItdsc)
		SetItem(1,"ispec", sIspec)
		SetItem(1,"jijil", sJijil)
END Choose

end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'redptcod' then
	gs_gubun = '1'
	gs_code = this.GetText()
	open(w_vndmst_4_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"redptcod",gs_code)
	this.SetItem(1,"redptnm",gs_codename)
elseif this.GetColumnName() = 'pdept' then
	gs_gubun = '1'
   gs_code = this.GetText()
	open(w_vndmst_4_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"pdept",gs_code)
	this.SetItem(1,"pdeptnm",gs_codename)
elseif this.GetColumnName() = 'itnbr' then
	gs_gubun = '1'
   gs_code = this.GetText()
	open(w_itemas_popup3)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itnbr",gs_code)
	this.SetItem(1,"itdsc",gs_codename)
end if	

end event

type dw_list from w_standard_print`dw_list within w_sal_01720
integer x = 50
integer y = 424
integer width = 4549
integer height = 1896
string dataobject = "d_sal_01720"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_01720
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 416
integer width = 4567
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

