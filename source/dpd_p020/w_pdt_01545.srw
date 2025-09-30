$PBExportHeader$w_pdt_01545.srw
$PBExportComments$** 연동판매계획 대 생산계획
forward
global type w_pdt_01545 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01545
end type
end forward

global type w_pdt_01545 from w_standard_print
string title = "연동 판매계획 대 생산계획"
boolean maxbox = true
rr_1 rr_1
end type
global w_pdt_01545 w_pdt_01545

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, pdtgu, pdtnm, sittyp, sitcls, sgubun, sLmsgu, ssaupj

if dw_ip.AcceptText() = -1 then	return -1

ym     = trim(dw_ip.object.ym[1])
pdtgu  = trim(dw_ip.object.pdtgu[1])
sittyp = dw_ip.object.ittyp[1]
sitcls = dw_ip.object.fitcls[1]
sgubun = dw_ip.object.gubun[1]
sLmsgu = dw_ip.GetItemString(1,"lmsgu")
ssaupj = dw_ip.GetItemString(1,"saupj")

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(pdtgu) or pdtgu = "")  then 
	f_message_chk(30, "[생산팀]")
	dw_ip.SetColumn("pdtgu")
	dw_ip.Setfocus()
	return -1
end if

if IsNull(sittyp) or sittyp = ""  then sittyp = '%'

if IsNull(sitcls) or sitcls = ""  then
	sitcls = '%'
else
	sitcls = sitcls + '%'
end if	

IF sgubun = '1' Then //생성시점
   dw_print.DataObject = "d_pdt_01545_02_p" 
   dw_list.DataObject = "d_pdt_01545_02" 
   dw_list.SetTransObject(SQLCA)
  
ELSE  //현재시점
   dw_print.DataObject = "d_pdt_01545_03_p" 
   dw_list.DataObject = "d_pdt_01545_03"
	dw_list.SetTransObject(SQLCA)
   
END IF
dw_print.SetTransObject(SQLCA)

if dw_print.Retrieve(gs_sabu, ym, pdtgu, sittyp, sitcls, sLmsgu, ssaupj) <= 0 then
	f_message_chk(50,'[연동 판매계획 대 생산계획]')
	dw_ip.Setfocus()
	return -1
end if
  dw_print.sharedata(dw_list)

dw_print.object.txt_ym.text = String(ym, "@@@@년 @@월")
select rfna1 into :pdtnm from reffpf
 where sabu = '1' and rfcod = '03' and rfgub = :pdtgu;
dw_print.object.txt_pdtgu.text = pdtnm


return 1
end function

on w_pdt_01545.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01545.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;
dw_ip.SetItem(1, "ym", left(is_today,6))


f_mod_saupj(dw_ip, 'saupj')
f_child_saupj(dw_ip, 'pdtgu', gs_saupj)

dw_ip.SetColumn("ym")
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_01545
end type

type p_exit from w_standard_print`p_exit within w_pdt_01545
end type

type p_print from w_standard_print`p_print within w_pdt_01545
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01545
end type







type st_10 from w_standard_print`st_10 within w_pdt_01545
end type



type dw_print from w_standard_print`dw_print within w_pdt_01545
string dataobject = "d_pdt_01545_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01545
integer x = 69
integer y = 32
integer width = 2971
integer height = 300
string dataobject = "d_pdt_01545_01"
end type

event dw_ip::itemchanged;string s_cod, sitnbr, sispec, snull, sitdsc
integer ireturn

if this.GetColumnName() = "ym" then
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
ELSEIF this.GetColumnName() = 'fitcls' then
	sItnbr = this.GetText()
   this.accepttext()	
	sispec = this.getitemstring(1, 'ittyp')
	
	if sitnbr = '' or isnull(sitnbr) then 
		this.setitem(1, "fclsnm", sNull)	
		return
	end if	
	
	ireturn = f_get_name2('품목분류', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fitcls", sitnbr)	
	this.setitem(1, "fclsnm", sitdsc)	
	RETURN ireturn
ELSEIF Getcolumnname() = 'saupj' then
	f_child_saupj(this, 'pdtgu', gettext())
END IF

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sittyp
str_itnct lstr_sitnct

this.accepttext()
if this.GetColumnName() = 'fitcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"fclsnm", lstr_sitnct.s_titnm)
end if	


end event

type dw_list from w_standard_print`dw_list within w_pdt_01545
integer x = 87
integer y = 352
integer width = 4512
integer height = 1944
string dataobject = "d_pdt_01545_02"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within w_pdt_01545
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 344
integer width = 4535
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

