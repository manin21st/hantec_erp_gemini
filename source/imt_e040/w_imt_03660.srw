$PBExportHeader$w_imt_03660.srw
$PBExportComments$**한도사용현황(출력)
forward
global type w_imt_03660 from w_standard_print
end type
type rr_2 from roundrectangle within w_imt_03660
end type
end forward

global type w_imt_03660 from w_standard_print
string title = "한도사용 현황"
boolean maxbox = true
rr_2 rr_2
end type
global w_imt_03660 w_imt_03660

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_bank_cod1, s_bank_cod2, sgubun
Long Lrow

if dw_ip.AcceptText() = -1 then return -1

s_bank_cod1 = dw_ip.GetItemString(1, 'bank_cod1')
s_bank_cod2 = dw_ip.GetItemString(1, 'bank_cod2')
sgubun		= dw_ip.GetItemString(1, 'gubun')

//은행조회범위 설정
IF (IsNull(s_bank_cod1) OR s_bank_cod1 = "" ) THEN
	s_bank_cod1 = "."
END IF
	
IF (IsNull(s_bank_cod2) OR s_bank_cod2 = "" ) THEN
  	s_bank_cod2 = "zzzzzz"
END IF

dw_print.SetTransObject(sqlca)

IF dw_print.Retrieve( gs_sabu, s_bank_cod1, s_bank_cod2 ) < 1 THEN
	f_message_chk(50,"[한도사용현황]")
	dw_ip.SetColumn('bank_cod1')
	dw_ip.SetFocus()
	return -1
ELSE
	dw_print.ShareData(dw_list)
END IF

sle_msg.text = ''

Return 1
end function

on w_imt_03660.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_imt_03660.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_imt_03660
end type

type p_exit from w_standard_print`p_exit within w_imt_03660
end type

type p_print from w_standard_print`p_print within w_imt_03660
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03660
end type







type st_10 from w_standard_print`st_10 within w_imt_03660
end type



type dw_print from w_standard_print`dw_print within w_imt_03660
string dataobject = "d_imt_03660_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03660
integer x = 23
integer y = 48
integer width = 3525
integer height = 276
string dataobject = "d_imt_03660_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.GetColumnName() = "bank_cod1"	THEN		
	gs_gubun = '3'
	gs_code = this.GetText()
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "bank_cod1", gs_code)
	this.SetItem(1, "bank_nam1", gs_codename)
ELSEIF this.GetColumnName() = "bank_cod2" THEN		
	gs_gubun = '3'
	gs_code = this.GetText()
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "bank_cod2", gs_code)
	this.SetItem(1, "bank_nam2", gs_codename)
END IF
end event

event dw_ip::itemchanged;string s_bank_cod, s_bank_nam, sname2 , s_temp ,s_gubun, s_gubun1 , s_gubun2 , s_gubun3
int    ireturn 

IF this.getcolumnname() = 'gubun' then

	s_gubun = this.gettext()
	s_gubun1 = this.getitemstring(1, "gubun1")
	s_gubun2 = this.getitemstring(1, "gubun2")

	if s_gubun = '1' then
			choose case s_gubun1 
					case '1'
						dw_list.dataobject = 'd_imt_03660_01'
						dw_print.dataobject = 'd_imt_03660_01_p'
					case '2'
						dw_list.dataobject = 'd_imt_03660_02'
						dw_print.dataobject = 'd_imt_03660_02_p'
					case '3' 
						dw_list.dataobject = 'd_imt_03660_03'
						dw_print.dataobject = 'd_imt_03660_03_p'
					case '4'
						dw_list.dataobject = 'd_imt_03660_04'
						dw_print.dataobject = 'd_imt_03660_04_p'
			end choose
	elseif  s_gubun = '2' then
			choose case s_gubun2 
					case '1'
						dw_list.dataobject = 'd_imt_03660_05'
						dw_print.dataobject = 'd_imt_03660_05_p'
					case '2'
						dw_list.dataobject = 'd_imt_03660_06'
						dw_print.dataobject = 'd_imt_03660_06_p'
			end choose
   else
			dw_list.dataobject = 'd_imt_03660_b'
			dw_print.dataobject = 'd_imt_03660_b_p'
   end if
	
	p_print.Enabled =False
	p_print.PictureName =  'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
ELSEIF this.getcolumnname() = 'gubun1' then

	s_gubun1 = this.gettext()
	s_gubun = this.getitemstring(1, "gubun")
	s_gubun2 = this.getitemstring(1, "gubun2")

	if s_gubun = '1' then
			choose case s_gubun1 
					case '1'
						dw_list.dataobject = 'd_imt_03660_01'
						dw_print.dataobject = 'd_imt_03660_01_p'
					case '2'
						dw_list.dataobject = 'd_imt_03660_02'
						dw_print.dataobject = 'd_imt_03660_02_p'
					case '3' 
						dw_list.dataobject = 'd_imt_03660_03'
						dw_print.dataobject = 'd_imt_03660_03_p'
					case '4'
						dw_list.dataobject = 'd_imt_03660_04'
						dw_print.dataobject = 'd_imt_03660_04_p'
			end choose
	elseif  s_gubun = '2' then
			choose case s_gubun2 
					case '1'
						dw_list.dataobject = 'd_imt_03660_05'
						dw_print.dataobject = 'd_imt_03660_05_p'
					case '2'
						dw_list.dataobject = 'd_imt_03660_06'
						dw_print.dataobject = 'd_imt_03660_06_p'
			end choose
   else
			dw_list.dataobject = 'd_imt_03660_b'
			dw_print.dataobject = 'd_imt_03660_b_p'
   end if
	
	p_print.Enabled =False
	p_print.PictureName =  'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
ELSEIF this.getcolumnname() = 'gubun2' then

	s_gubun2 = this.gettext()
	s_gubun = this.getitemstring(1, "gubun")
	s_gubun1 = this.getitemstring(1, "gubun1")

	if s_gubun = '1' then
			choose case s_gubun1 
					case '1'
						dw_list.dataobject = 'd_imt_03660_01'
						dw_print.dataobject = 'd_imt_03660_01_p'
					case '2'
						dw_list.dataobject = 'd_imt_03660_02'
						dw_print.dataobject = 'd_imt_03660_02_p'
					case '3' 
						dw_list.dataobject = 'd_imt_03660_03'
						dw_print.dataobject = 'd_imt_03660_03_p'
					case '4'
						dw_list.dataobject = 'd_imt_03660_04'
						dw_print.dataobject = 'd_imt_03660_04_p'
			end choose
	elseif  s_gubun = '2' then
			choose case s_gubun2 
					case '1'
						dw_list.dataobject = 'd_imt_03660_05'
						dw_print.dataobject = 'd_imt_03660_05_p'
					case '2'
						dw_list.dataobject = 'd_imt_03660_06'
						dw_print.dataobject = 'd_imt_03660_06_p'
			end choose
   else
			dw_list.dataobject = 'd_imt_03660_b'
			dw_print.dataobject = 'd_imt_03660_b_p'
   end if
	
	p_print.Enabled =False
	p_print.PictureName =  'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
//은행코드를 은행명으로		
ELSEIF this.GetColumnName() = 'bank_cod1' THEN   
	s_bank_cod = Trim(this.GetText())
	ireturn = f_get_name2('은행', 'N', s_bank_cod, s_bank_nam, sname2)    //1이면 실패, 0이 성공	
   this.setitem(1, 'bank_cod1', s_bank_cod )
   this.setitem(1, 'bank_nam1', s_bank_nam )
	RETURN ireturn
ELSEIF this.GetColumnName() = 'bank_cod2' THEN   
	s_bank_cod = Trim(this.GetText())
	ireturn = f_get_name2('은행', 'N', s_bank_cod, s_bank_nam, sname2)    //1이면 실패, 0이 성공	
   this.setitem(1, 'bank_cod2', s_bank_cod )
   this.setitem(1, 'bank_nam2', s_bank_nam )
	RETURN ireturn
END IF
end event

type dw_list from w_standard_print`dw_list within w_imt_03660
integer x = 27
integer y = 344
integer width = 4576
integer height = 1976
string dataobject = "d_imt_03660_01"
boolean border = false
end type

type rr_2 from roundrectangle within w_imt_03660
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 336
integer width = 4603
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

